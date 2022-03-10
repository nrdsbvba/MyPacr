const mysql = require("mysql");
const directusService = require("../external/directusService");

const xl = require("excel4node");
const puppeteer = require("puppeteer");
const fs = require("fs");
const path = require("path");
const handlebars = require("handlebars");
const moment = require("moment");
const Pivot = require("quick-pivot");
const config = require("config");

var createConnection = () => {
  var directusSettings = config.get("directusSettings");
  var connection = mysql.createPool({
    connectionLimit: 10,
    host: directusSettings.databaseSettings.host,
    user: directusSettings.databaseSettings.user,
    password: directusSettings.databaseSettings.password,
    database: directusSettings.databaseSettings.database
  });
  return connection;
};

var generateReport = payload => {
  console.log(payload);
  return new Promise((resolve, reject) => {
    var output = payload.output;
    var parameters = payload.parameters;
    var definedFields = payload.fields;
    var reportKey = payload.reportKey;
    var query = "";
    var reportInfo;
    var data;

    //Get Report item from directus
    directusService
      .getReportByKey(reportKey)
      .then(resp => {
        if (resp) {
          reportInfo = resp;
          query = resp.query;

          if (parameters && parameters.length > 0) {
            //merge sql with given parameters
            var queryRay = query.split(resp.parameterchars);
            queryRay.forEach((element, index, ray) => {
              parameters.forEach((innerElement, innerIndex, innerRay) => {
                tmpValue = innerElement.value;
                if (element == innerElement.name) {
                  if (innerElement.type == "DATE") {
                    ray[index] = tmpValue;
                  } else {
                    ray[index] = innerElement.value;
                  }
                }
              });
            });

            query = queryRay.join("");
            console.log(query);
          }

          var connection = createConnection();

          connection.query(query, function(error, results, fields) {
            if (error) {
              console.log(error);
              return reject(error);
            } else {
              if (definedFields) {
                definedFields.forEach(fieldElement => {
                  if (
                    Object.keys(results[0]).includes(fieldElement.fieldsName)
                  ) {
                    results.forEach((item, index, ray) => {
                      if (fieldElement.showAs == "STRING") {
                        //do nothing, default is handled as String
                      }
                      if (fieldElement.showAs == "DATE") {
                        var theDate = moment(
                          item[fieldElement.fieldsName]
                        ).format("DD-MM-YYYY");
                        ray[index][fieldElement.fieldsName] = theDate;
                      }
                      if (fieldElement.showAs == "CURRENCY") {
                        var theValue = parseFloat(item[fieldElement.fieldsName])
                          .toFixed(2)
                          .replace(".", ",");
                        ray[index][fieldElement.fieldsName] = theValue;
                      }
                      if (fieldElement.showAs == "BOOLEAN") {
                        var theBoolean = item[fieldElement.fieldsName] == 1;
                        ray[index][fieldElement.fieldsName] = theBoolean
                          ? fieldElement.booleanTrueValue
                          : fieldElement.booleanFalseValue;
                      }
                      if (fieldElement.showAs == "NUMBER") {
                        //do nothing for now
                      }
                    });
                  }
                });
              }
              data = results;

              //Do Pivot?
              if (reportInfo.pivot_table && data != null && data.length > 0) {
                //prepareData
                var newRay = [];

                newRay.push(Object.keys(data[0]));
                data.forEach(element => {
                  singleRay = [];
                  Object.keys(data[0]).forEach(key => {
                    singleRay.push(element[key]);
                  });
                  newRay.push(singleRay);
                });

                var pivot = new Pivot(
                  newRay,
                  [reportInfo.pivot_info.rows],
                  [reportInfo.pivot_info.columns],
                  reportInfo.pivot_info.columns,
                  reportInfo.pivot_info.aggregator
                );
                var newData = pivot.data;
                var pivotted = [];
                var headerRow = [];
                pivot.data.table[0].value.forEach((element, index, array) => {
                  if (index == 0) {
                    headerRow.push(reportInfo.pivot_info.rows);
                  } else {
                    if (element != "Totals") {
                      headerRow.push(element);
                    }
                  }
                });
                pivot.data.table.forEach((element, index, array) => {
                  if (index > 0) {
                    var rowObject = {};
                    var element = element.value;
                    headerRow.forEach((innerElement, innerIndex, innerRay) => {
                      if (
                        reportInfo.pivot_info.valueFor1 != null &&
                        element[innerIndex] == 1
                      ) {
                        rowObject[innerElement] =
                          reportInfo.pivot_info.valueFor1;
                      } else {
                        if (
                          reportInfo.pivot_info.valueFor0 != null &&
                          element[innerIndex] == 0
                        ) {
                          rowObject[innerElement] =
                            reportInfo.pivot_info.valueFor0;
                        } else {
                          rowObject[innerElement] = element[innerIndex];
                        }
                      }
                    });
                    pivotted.push(rowObject);
                  }
                });

                data = pivotted;
              }
              // fields
              if (parameters && parameters.length > 0) {
                //do stuff for formatting the given parameters
                parameters.forEach((innerElement, innerIndex, innerRay) => {
                  if (innerElement.type == "DATE") {
                    innerRay[innerIndex].value = moment(
                      innerElement.value,
                      "YYYY-MM-DD"
                    ).format("DD-MM-YYYY");
                  }
                  if (innerElement.isCollectionItem) {
                    innerRay[innerIndex].value = innerElement.text;
                  }
                });
              }

              if (output == "data") {
                //if output is data, return the data
                var templateData = {
                  title: reportInfo.title,
                  parameters: parameters,
                  keys: data[0] ? Object.keys(data[0]) : [],
                  currentDate: moment().format("DD/MM/YYYY - HH:mm"),
                  data: data
                };
                return resolve(templateData);
              } else {
                if (output == "excel") {
                  generateExcel(data, reportInfo)
                    .then(resp => {
                      return resolve(resp);
                    })
                    .catch(err => {
                      console.log(err);
                      return reject(err);
                    });
                }

                if (output == "pdf") {
                  generatePdf(data, reportInfo, parameters)
                    .then(resp => {
                      return resolve(resp);
                    })
                    .catch(err => {
                      console.log(err);
                      return reject(err);
                    });
                }
              }
            }
          });
        } else {
          return reject(null);
        }

        //run sql
      })
      .catch(err => {
        console.log(err);
        return reject(err);
      });

    //if file --> return filename
  });
};

var generateExcel = (data, reportInfo) => {
  return new Promise((resolve, reject) => {
    try {
      var wb = new xl.Workbook();
      var ws = wb.addWorksheet(reportInfo.title);

      var currencyStyle = wb.createStyle({
        font: {
          color: "#000000",
          size: 12
        },
        numberFormat: "€# ##0,00; (€# ##0,00); -"
      });
      var stringStyle = wb.createStyle({
        font: {
          color: "#000000",
          size: 12
        }
      });
      var headerStyle = wb.createStyle({
        font: {
          bold: true,
          underline: true
        },
        alignment: {
          wrapText: false,
          horizontal: "center"
        }
      });

      //create the header
      //calculate amount of fields
      var nrOfColumns = (data[0] ? Object.keys(data[0]) : []).length;
      //write the headerTitle into the excel file
      ws.cell(1, 1, 1, nrOfColumns, true)
        .string(reportInfo.title)
        .style(headerStyle);

      //pass over each propertyname and pass it in as a columnHeader
      var columnNr = 1;
      var theKeys = data[0] ? Object.keys(data[0]) : [];
      theKeys.forEach(element => {
        ws.cell(2, columnNr)
          .string(element)
          .style(stringStyle);
        columnNr++;
      });

      rowNr = 3;
      //write the data into the file
      data.forEach(element => {
        columnNr = 1;
        var theKeys2 = data[0] ? Object.keys(data[0]) : [];
        theKeys2.forEach(keysObject => {
          var value = null;
          if (element[keysObject] != null) {
            var value = element[keysObject].toString();
          }
          ws.cell(rowNr, columnNr)
            .string(value ? value : "")
            .style(stringStyle);

          columnNr++;
        });
        rowNr++;
      });
      var internalFile =
        "/public/reports/excel/" +
        reportInfo.key +
        "-" +
        new Date().getTime() +
        ".xlsx";
      var outputFile = path.join(process.cwd(), "src/" + internalFile);
      wb.write(outputFile);

      return resolve(internalFile);
    } catch (err) {
      return reject(err);
    }
  });
};

var generatePdf = (data, reportInfo, parameters) => {
  return new Promise((resolve, reject) => {
    try {
      var browser;
      var page;

      var templateHtml = fs.readFileSync(
        path.join(
          process.cwd(),
          "/src/reportTemplates/defaultReport.handlebars"
        ),
        "utf8"
      );
      var template = handlebars.compile(templateHtml);
      var templateData = {
        title: reportInfo.title,
        parameters: parameters,
        keys: data[0] ? Object.keys(data[0]) : [],
        currentDate: moment().format("DD/MM/YYYY - HH:mm"),
        data: data
      };
      var html = template(templateData);

      var internalFile =
        "/public/reports/pdf/" +
        reportInfo.key +
        "-" +
        new Date().getTime() +
        ".pdf";
      var outputFile = path.join(process.cwd(), "src/" + internalFile);
      var cssHeaderStyle =
        "<style> h1 { font-size:20px; margin-left:50px;}</style>";
      var options = {
        format: "A4",
        headerTemplate: "<p></p>",
        footerTemplate:
          '<div class="page-footer" style="width:100%; text-align:center; font-size:8px;"> <span class="pageNumber"></span>/<span class="totalPages"></span></div>',
        displayHeaderFooter: true,
        margin: {
          top: "50px",
          bottom: "50px",
          left: "30px",
          right: "30px"
        },
        printBackground: false,
        path: outputFile
      };
      if (reportInfo.landscape) {
        options.landscape = true;
      }

      puppeteer
        .launch({
          args: ["--no-sandbox"],
          headless: true
        })
        .then(resp => {
          browser = resp;
          return browser.newPage();
        })
        .then(resp => {
          page = resp;
          return page.goto(`data:text/html;charset=UTF-8,${html}`, {
            waitUntil: "networkidle0"
          });
        })
        .then(resp => {
          return page.pdf(options);
        })
        .then(resp => {
          return browser.close();
        })
        .then(resp => {
          return resolve(internalFile);
        })
        .catch(err => {
          console.log(err);
          return reject(err);
        });
    } catch (err) {
      return reject(err);
    }
  });
};

module.exports = {
  generateReport
};
