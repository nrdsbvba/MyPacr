const express = require("express");
const path = require("path");
const bodyParser = require("body-parser");
const cors = require("cors");
const passport = require("passport");
const directusService = require("./external/directusService");
var session = require("express-session");
var MemoryStore = require("memorystore")(session);
var reportingService = require("./service/reportingService");
var attendenceService = require("./service/attendenceService");
var maintenanceService = require("./service/maintenanceService");
var saldoService = require("./service/saldoService");
var mailService = require("./service/mailService");
var serverConfigurator = require("./serverConfigurator");
const config = require("config");
const moment = require("moment");

const cronJobService = require("./service/cronJobService");

serverConfigurator
  .configServices()
  .then(() => {
    console.log("Services are properly Configured");
  })
  .then(() => {
    return directusService.getGeneralSettings();
  })
  .then(resp => {
    global.generalSettings = resp[0];

    console.log("*** Logging generalSettings ***");
    console.log(JSON.stringify(global.generalSettings));
    console.log("*** End Logging generalSettings ***");
  })
  .then(() => {
    console.log("*** Logging config ***");
    console.log(JSON.stringify(config));
    console.log("*** End Logging config ***");
  })
  .then(() => {
    cronJobService.startCronJob();
  })
  .then(() => {
    //Setup moment Local
    const locale = config.get("localizationSettings").language;
    moment.locale(locale);
    console.log("Moment language set to:" + locale);
    console.log(
      "Moment timezone set to:" + config.get("localizationSettings").timezone
    );
  })
  .catch(err => {
    console.log("Setup went wrong!");
    console.log(JSON.stringify(config));
    console.log(err);
  });

const app = express();
const port = 80;

app.use(
  cors()
);

// app.use(express.static(path.join(__dirname+ 'public/reports/pdf')))
// app.use(express.static(path.join(__dirname+ 'public/reports/excel')))

app.use(bodyParser.json());
app.use(
  bodyParser.urlencoded({
    extended: false
  })
);

var options = {
  dotfiles: "ignore",
  etag: false,
  extensions: ["pdf", "xlsx"],
  index: false,
  maxAge: "1d",
  redirect: false,
  setHeaders: function (res, path, stat) {
    res.set("x-timestamp", Date.now());
  }
};
var serveIndex = require("serve-index");
app.use("/p", serveIndex(path.join(__dirname, "./public")));
app.use("/p", express.static(path.join(__dirname, "./public")));

app.use("/api/user", require("./controllers/userController"));
app.use("/api/sync", require("./controllers/syncController"));

app.use("/api/transactions", require("./controllers/transactionController"));
app.use("/api/attendences", require("./controllers/attendenceController"));
app.use(
  "/api/paymentInternal",
  require("./controllers/paymentInternalController")
);
app.use("/api/payment", require("./controllers/paymentController"));
app.use("/api/reports", require("./controllers/reportingController"));

app.listen(port, () => {
  console.log("Server started at port " + port);
});