<template>
  <private-view title="Rapportage">
    <v-sheet>
      <div class="container">
        <div class="left">
          <!-- Selecting the desired type of report to generate-->
          <label>Type Rapport</label>
          <v-select v-model="selectedReport" :items="reportOptions" />
        </div>
        <div class="right">
          <!-- Selecting the desired output format-->
          <label>Formaat</label>
          <v-select
            v-model="selectedOutput"
            :items="[
              {
                text: 'PDF',
                value: 'pdf',
              },
              {
                text: 'Excel',
                value: 'excel',
              },
              {
                text: 'In scherm',
                value: 'data',
              },
            ]"
          />
        </div>
      </div>
      <div v-if="generatingReport">
        <v-progress-circular indeterminate />
      </div>

      <div
        v-if="
          selectedReportComputed &&
          selectedReportComputed.parameterobject &&
          selectedReportComputed.parameterobject.length > 0
        "
      >
        <div v-if="gettingData">
          <v-progress-circular indeterminate />
        </div>
        <div v-else>
          <!-- Looping over every parameter and displaying the correct inputfield-->
          <div
            v-for="item in selectedReportComputed.parameterobject"
            :key="item.name"
            class="container"
          >
            <div class="left">
              <label>{{ item.name }}</label>
              <div v-if="item.isCollectionItem">
                <!-- If the parameter is a collection, create a searchable dropdown, in which can be typed to search -->
                <v-search-select
                  :options="item.options"
                  @option:selected="selectOption($event, item)"
                >
                </v-search-select>
                <!-- If showInputAs is set to SELECT, create a regular dropdown menu, without searching -->
                <v-select
                  v-model="item.value"
                  v-if="item.showInputAs == 'SELECT'"
                  :items="item.options"
                />
              </div>
              <div v-else>
                <div v-if="item.type == 'DATE'">
                  <v-date-picker v-model="item.value" type="date" />
                </div>

                <div v-if="item.type == 'STRING'">
                  <v-input v-model="item.value" />
                </div>
                <div v-if="item.type == 'BOOLEAN'">
                  <v-checkbox v-model="item.value" :label="item.name" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Button to generate report-->
      <v-button @click="generateReport"> Genereer Rapport</v-button>
    </v-sheet>

    <!-- Show the report on the screen if needed-->
    <div v-if="renderedReport">
      <v-card :tile="false">
        <v-card-title>{{ renderedReport.title }}</v-card-title>
        <v-card-text
          v-for="(paramItem, index) in renderedReport.parameters"
          :key="`paramItem.name-${index}`"
        >
          {{ paramItem.name }} : {{ paramItem.value }} <br />
        </v-card-text>

        <v-card-text>
          Moment van rapport: {{ renderedReport.currentDate }}
        </v-card-text>
      </v-card>

      <v-table
        :headers="renderedReport.keys"
        :items="renderedReport.data"
        show-resize
      >
      </v-table>
    </div>

    <!-- Error dialog -->
    <v-dialog v-model="errorDialogActive">
      <v-sheet>
        <h2>{{ modalTitle }}</h2>
        <p>{{ modalText }}</p>
        <v-button @click="errorDialogActive = false">OK</v-button>
      </v-sheet>
    </v-dialog>

    <!-- Download dialog -->
    <v-dialog v-model="downloadDialogActive">
      <v-sheet>
        <h2 style="font-weight: bold;">Download file</h2>
        <p>
          Download link:
          <a :href="fileLocation" target="_blank">{{ fileLocation }}</a>
        </p>
        <p>
          <v-button download :href="this.fileLocation" class="append"
            >Download</v-button
          >
        </p>
      </v-sheet>
    </v-dialog>
  </private-view>
</template>
<script>
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";

import * as jose from "jose";

import axios from "axios";
import { Directus } from "@directus/sdk";

import environmentManager from "./environmentManager.js";
const environmentSettings = environmentManager.getEnvironmentSettings();

var uint8array = new TextEncoder("utf-8").encode(
  environmentSettings.portalSettings.tokenSettings.key
);
const token = await new jose.SignJWT({
  passphrase: environmentSettings.portalSettings.tokenSettings.passphrase,
})
  .setProtectedHeader({ alg: "HS256" })
  .sign(uint8array);

const service = {
  settings: {
    url: environmentSettings.directusSettings.url,
    token: environmentSettings.directusSettings.token,
  },
};

const client = new Directus(service.settings.url);

const portalLink = environmentSettings.portalSettings.apiUrl;
const portalFileLink = environmentSettings.portalSettings.fileLink;

const axiosInstance = axios.create({
  baseURL: portalLink,
  timeout: 100000,
  headers: { "x-auth": token },
});

export default {
  setup() {
    var authComplete = false;
    client.auth.static(service.settings.token).then(() => {
      console.log("auth complete");
      authComplete = true;
    });
    // allowed to spin wait?
    while (authComplete == false) {}
  },
  data: function () {
    return {
      allReports: [],

      selectedReport: "Selecteer rapport type",
      renderedReport: false,
      selectedOutput: "Selecteer formaat",
      gettingData: false,
      generatingReport: false,

      errorDialogActive: false,
      modalText: "",
      modalTitle: "",

      downloadDialogActive: false,
      fileLocation: "",

      value: "",
      allValues: {},
    };
  },
  computed: {
    reportOptions: {
      get() {
        var ray = [];
        this.allReports.forEach((element) => {
          ray.push({
            value: element,
            text: element.title,
          });
        });
        return ray;
      },
      set() {
        //do nothing
      },
    },
    selectedReportComputed: {
      get() {
        return this.selectedReport;
      },
      set() {},
    },
  },

  methods: {
    setupData(item) {
      if (this.allValues[item.name]) return;
      client
        .items(item.collectionName)
        .readByQuery({
          limit: -1,
        })
        .then((resp) => {
          // generate labels for items in searchbox
          resp.data.forEach((arrayItem, index, array) => {
            var txt = "";
            item.showProps.forEach((prop) => {
              txt += arrayItem[prop] + " ";
            });
            array[index].label = txt;
          });
          this.allValues[item.name] = resp.data;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    selectOption(event, item) {
      var option = item.options.find((obj) => {
        return obj.id == event.id;
      });

      this.selectedReport.parameterobject.forEach((element, index, array) => {
        if (item.name == element.name) {
          array[index].value = event.id;
          array[index].text = option.text;
        }
      });
    },
    getData() {
      client
        .items("reports")
        .readByQuery({
          limit: -1,
          fields: "*",
        })
        .then((resp) => {
          this.allReports = resp.data;
        })
        .catch((err) => {
          console.log("getdata error");
          console.log(err);
        });
    },
    generateReport() {
      this.generatingReport = true;
      //form jsonObject
      var args = {
        output: this.selectedOutput,
        parameters: this.selectedReport.parameterobject,
        fields: this.selectedReport.fieldsobject,
        reportKey: this.selectedReport.key,
      };
      var error = false;
      this.modalTitle = "Ontbrekende Argumenten";

      if (!this.selectedReport || this.selectedReport == {}) {
        error = true;
        this.modalText = "Gelieve een rapport te kiezen";
        this.errorDialogActive = true;
        this.generatingReport = false;
        return;
      }
      if (!args.output || args.output == "") {
        error = true;
        this.modalText = "Gelieve een formaat voor het rapport te kiezen";
        this.errorDialogActive = true;
        this.generatingReport = false;
        return;
      }
      if (args.parameters && args.parameters.length > 0) {
        var paramNotFilled = false;
        args.parameters.forEach((item) => {
          if (item.type != "BOOLEAN" && item.value == "") {
            paramNotFilled = true;
          }
        });
        if (paramNotFilled) {
          error = true;
          this.modalText = "Gelieve alle parameters in te vullen";
          this.errorDialogActive = true;
          this.generatingReport = false;
          return;
        }
      }

      if (!error) {
        axiosInstance
          .post("/reports/generateReport", args)
          .then((resp) => {
            if (args.output == "data") {
              //Format for v-table
              resp.data.keys.forEach((item, index, array) => {
                array[index] = {
                  text: item.replace("_", " "),
                  value: item,
                };
              });

              this.renderedReport = resp.data;
            } else {
              this.fileLocation =
                portalFileLink + resp.data.replace("public", "p");
              this.downloadDialogActive = true;
            }
          })
          .catch((err) => {
            console.log(err);
          })
          .finally(() => {
            this.generatingReport = false;
          });
      } else {
        error = false;
      }
    },
  },

  created: function () {
    this.getData();
  },
  components: {
    "v-search-select": vSelect,
  },
  watch: {
    selectedReport: function (newSelectedReport) {
      this.gettingData = true;
      if (this.selectedReport.parameterobject) {
        this.selectedReport.parameterobject.forEach(
          (paramItem, paramIndex, paramArray) => {
            if (
              paramItem.isCollectionItem &&
              (paramItem.showInputAs == "SELECT" ||
                paramItem.showInputAs == "SEARCHBOX")
            )
              client
                .items(paramItem.collectionName)
                .readByQuery({
                  fields: "*",
                })
                .then((resp) => {
                  console.log(resp);
                  resp.data.forEach((item, index, array) => {
                    var txt = "";
                    paramItem.showProps.forEach((prop) => {
                      txt += item[prop] + " ";
                    });
                    array[index].text = txt;
                    array[index].label = txt;
                  });
                  paramArray[paramIndex].options = resp.data;
                  console.log(this.selectedReport);
                })
                .catch((err) => {
                  console.log(err);
                  return [];
                });
          }
        );
      }

      this.gettingData = false;
    },
  },
};
</script>

<style scoped>
input,
select {
  padding: 0.75em 0.5em;
  font-size: 100%;
  border: 1px solid #ccc;
  width: 100%;
}

.container {
  width: 100%;
}

.v-button {
  width: 98%;
  padding: 0.5%;
  margin: 0.5%;
}
.left,
.right {
  float: left;
  width: 49%;
  padding: 0.5%;
  margin: 0.5%;
}

label {
  font-weight: bold;
}
</style>
