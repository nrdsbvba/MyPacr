<template>
  <private-view title="My Test Module">
    <div>
      <div class="row">
        <div class="col-12">
          <div class="card border-primary m-2">
            <div class="card-header text-center primary">RapportKeuze</div>
            <div class="card-body">
              <div class="form-group">
                <label>Type Rapport</label>
                <select class="form-control" v-model="selectedReport">
                  <option
                    v-for="item in reportOptions"
                    v-bind:key="item.value.key"
                    :value="item.value"
                  >
                    {{ item.text }}
                  </option>
                </select>
              </div>

              <div class="form-group">
                <label>Format</label>
                <select class="form-control" v-model="selectedOutput">
                  <option value="pdf">pdf</option>
                  <option value="excel">excel</option>
                  <option value="data">in scherm</option>
                </select>
              </div>
              <div v-if="generatingReport">
                <div class="spinner-border" role="status">
                  <!--<span class="visually-hidden">Loading...</span> -->
                </div>
              </div>

              <div
                v-if="
                  selectedReportComputed &&
                  selectedReportComputed.parameterobject &&
                  selectedReportComputed.parameterobject.length > 0
                "
              >
                <hr />
                <div v-if="gettingData">
                  <div class="spinner-border" role="status"></div>
                </div>
                <div v-else>
                  <div
                    class="form-group"
                    v-for="item in selectedReportComputed.parameterobject"
                    :key="item.name"
                  >
                    <label>{{ item.name }}</label>
                    <div v-if="item.isCollectionItem">
                      <v-select
                        :options="allValues[item.name]"
                        @search:focus="setupData(item)"
                        @option:selected="selectOption($event, item)"
                      >
                      </v-select>

                      <select
                        class="form-control"
                        v-model="item.value"
                        v-if="item.showInputAs == 'SELECT'"
                      >
                        <option
                          v-for="option in item.options"
                          v-bind:key="option.id"
                          :value="option.id"
                        >
                          {{ option.text }}
                        </option>
                      </select>
                    </div>
                    <div v-else>
                      <div v-if="item.type == 'DATE'">
                        <input
                          type="date"
                          placeholder="Select Date"
                          v-model="item.value"
                        />
                      </div>

                      <div v-if="item.type == 'STRING'">
                        <input
                          type="text"
                          v-model="item.value"
                          class="form-control"
                        />
                      </div>
                      <div
                        class="custom-control form-control-lg custom-checkbox"
                        v-if="item.type == 'BOOLEAN'"
                      >
                        <input
                          type="checkbox"
                          class="custom-control-input"
                          id="customCheck1"
                          v-model="item.value"
                        />
                        <label
                          class="custom-control-label"
                          for="customCheck1"
                          >{{ item.name }}</label
                        >
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <button
                type="button"
                class="btn btn-primary"
                @click="generateReport"
              >
                Genereer Rapport
              </button>
            </div>
          </div>
        </div>
      </div>
      <div class="row" v-if="renderedReport">
        <div class="col-12">
          <div class="card border-primary m-2">
            <div class="card-header text-center primary">Rapport</div>
            <div class="card-body">
              <h5 class="card-title">{{ renderedReport.title }}</h5>
              <p
                class="card-text"
                v-for="(paramItem, index) in renderedReport.parameters"
                :key="`paramItem.name-${index}`"
              >
                {{ paramItem.name }} : {{ paramItem.value }} <br />
              </p>
              <p class="card-text">
                moment van rapport: {{ renderedReport.currentDate }}
              </p>
            </div>
          </div>
        </div>
      </div>
      <div class="row" v-if="renderedReport">
        <div class="col-12">
          <table class="table table-sm">
            <thead class="thead-dark">
              <tr>
                <th
                  scope="row"
                  v-for="(key, index) in renderedReport.keys"
                  :key="`key-${index}`"
                >
                  {{ key }}
                </th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="(dataItem, index) in renderedReport.data"
                :key="`dataItem-${index}`"
              >
                <td
                  v-for="(keyParam, index) in renderedReport.keys"
                  :key="`keyParam-${index}`"
                >
                  {{ dataItem[keyParam] }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="modal" tabindex="-1" role="dialog" id="myModal">
        <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">{{ modalTitle }}</h5>
              <button
                type="button"
                class="close"
                data-bs-dismiss="modal"
                aria-label="Close"
              >
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <p>{{ modalText }}</p>
            </div>
            <div class="modal-footer">
              <button
                type="button"
                class="btn btn-primary"
                data-bs-dismiss="modal"
              >
                OK
              </button>
            </div>
          </div>
        </div>
      </div>
      <div class="modal" tabindex="-1" role="dialog" id="myDownloadModal">
        <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Download File</h5>
              <button
                type="button"
                class="close"
                data-bs-dismiss="modal"
                aria-label="Close"
              >
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <p>
                downloadLink:
                <a :href="fileLocation" target="_blank">{{ fileLocation }}</a>
              </p>
            </div>
            <div class="modal-footer">
              <button
                type="button"
                class="btn btn-primary"
                data-bs-dismiss="modal"
              >
                Sluiten
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </private-view>
</template>
<script>

import JQuery from "jquery";
let $ = JQuery;

import "bootstrap/dist/css/bootstrap.css";
import bootstrap from "bootstrap/dist/js/bootstrap.js";

import vSelect from "vue-select";
import "vue-select/dist/vue-select.css";

import * as jose from "jose";

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

import axios from "axios";
import { Directus } from "@directus/sdk";

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

      selectedReport: {},
      renderedReport: false,
      selectedOutput: "",
      gettingData: false,
      generatingReport: false,
      modalText: "",
      modalTitle: "",
      fileLocation: "",

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
      this.selectedReport.parameterobject.forEach((element, index, array) => {
        if (item.name == element.name) {
          array[index].value = event.id;
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

      var myModal = new bootstrap.Modal(document.getElementById("myModal"), {
        keyboard: false,
      });

      if (!this.selectedReport || this.selectedReport == {}) {
        error = true;
        this.modalText = "Gelieve een rapport te kiezen";
        myModal.show();
        this.generatingReport = false;
        return;
      }
      if (!args.output || args.output == "") {
        error = true;
        this.modalText = "Gelieve een formaat voor het rapport te kiezen";
        myModal.show();
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
          myModal.show();
          this.generatingReport = false;
          return;
        }
      }
      var downloadModal = new bootstrap.Modal(
        document.getElementById("myDownloadModal"),
        {
          keyboard: false,
        }
      );

      if (!error) {
        axiosInstance
          .post("/reports/generateReport", args)
          .then((resp) => {
            if (args.output == "data") {
              this.renderedReport = resp.data;
            } else {
              // FileDownload(resp.data, 'report.pdf')
              this.fileLocation =
                portalFileLink + resp.data.replace("public", "p");
              downloadModal.show();
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
    vSelect,
  },
  watch: {
    selectedReport: function (newSelectedReport) {
      this.gettingData = true;
      if (this.selectedReport.parameterobject) {
        this.selectedReport.parameterobject.forEach(
          (paramItem, paramIndex, paramArray) => {
            if (paramItem.isCollectionItem && paramItem.showInputAs == "SELECT")
              client
                .items(paramItem.collectionName)
                .readByQuery({
                  fields: "*",
                })
                .then((resp) => {
                  resp.data.forEach((item, index, array) => {
                    var txt = "";
                    paramItem.showProps.forEach((prop) => {
                      txt += item[prop] + " ";
                    });
                    array[index].text = txt;
                  });
                  paramArray[paramIndex].options = resp.data;
                  this.$forceUpdate();
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

<style>
input,
select {
  padding: 0.75em 0.5em;
  font-size: 100%;
  border: 1px solid #ccc;
  width: 100%;
}
</style>
