<template>
  <div class="d-sm-flex  justify-content-between col-12">
    <div class="col-lg-2"></div>
    <div class="col-lg-8">
      <div>
        <div class="row">
          <div class="col-12">
            <b-card
              border-variant="primary"
              header="Transacties"
              header-bg-variant="primary"
              header-text-variant="white"
              style="min-height: 20rem;"
            >
              <b-alert show
                >Opgelet! Verbruiksgegevens van de transacties zichtbaar vanaf
                26/09</b-alert
              >
              <p v-if="linkedCards.length + inactiveCards.length == 0">
                Geen Kaarten teruggevonden voor deze account
              </p>
              <div>
                <b-list-group>
                  <b-list-group-item
                    v-for="linkedCard in linkedCards"
                    v-bind:key="linkedCard.id"
                    v-bind:variant="activeVariant(linkedCard)"
                  >
                    <b-container class="bv-example-row">
                      <b-row>
                        <b-col
                          >Gebruiker: {{ linkedCard.user.first_name }}
                          {{ linkedCard.user.last_name }} <br />
                          KaartCode: {{ linkedCard.card.code }}
                        </b-col>
                        <b-col
                          >KaartType: {{ linkedCard.card_leasing_type.name }}
                          <br />
                          Beschrijving: {{ linkedCard.description }} <br />
                          Saldo: {{ showPrice(linkedCard.saldo) }}</b-col
                        >
                      </b-row>
                    </b-container>
                    <hr />
                    <p>
                      <b-button
                        variant="outline-primary"
                        @click="openTransactions(linkedCard)"
                        >Transacties & Verbruik</b-button
                      >
                    </p>
                  </b-list-group-item>
                </b-list-group>
              </div>
            </b-card>
          </div>
        </div>
      </div>
    </div>
    <div class="col-lg-2"></div>
    <b-modal
      id="transactiesModal"
      size="xl"
      title="Transacties"
      style="max-width:70%"
    >
      <h5 v-if="selectedCard">
        Transacties voor {{ selectedCard.user.first_name }}
        {{ selectedCard.user.last_name }}<br />
        {{ selectedCard.card_leasing_type.name }} --
        {{ selectedCard.description }} <br />
      </h5>
      <div class="text-center" v-if="gettingTransactions">
        <b-spinner variant="primary" label="Ophalen..." class="m-5"></b-spinner>
      </div>
      <b-table
        :items="transactionList"
        :fields="transactionFields"
        :tbody-tr-class="rowClass"
        v-else
        small
        responsive
      >
        <template v-slot:cell(return)="row">
          {{ row.item.top_off ? "Ja" : "Nee" }}
        </template>
        <template v-slot:cell(Verbruik)="row">
          <b-button
            size="sm"
            variant="primary"
            @click="row.toggleDetails"
            class="mr-2"
            v-if="row.item.order"
          >
            {{ row.detailsShowing ? "Verberg" : "Toon" }} Verbruik
          </b-button>
        </template>

        <template v-slot:row-details="row">
          <b-table-lite
            :items="row.item.order.order_items"
            :fields="orderFields"
            small
            v-if="row.item.order"
          >
          </b-table-lite>
          <b-button size="sm" @click="row.toggleDetails"
            >Verberg Verbruik</b-button
          >
        </template>
      </b-table>
      <b-row class="my-1">
        <b-col sm="9">
          <b-pagination
            v-model="currentPage"
            :total-rows="totalRows"
            :per-page="itemsPerPage"
          ></b-pagination>
        </b-col>
        <b-col sm="3">
          <label for="inputPerPage">items per pagina: </label>
          <b-form-input
            id="inputPerPage"
            type="number"
            v-model="itemsPerPage"
          ></b-form-input>
        </b-col>
      </b-row>
      <div></div>
      <template v-slot:modal-footer>
        <div class="w-100">
          <b-button
            variant="primary"
            size="sm"
            class="float-right"
            @click="closeTransactions()"
          >
            Sluiten
          </b-button>
        </div>
      </template>
    </b-modal>
  </div>
</template>

<script>
import tobackend from "~/plugins/2backend.js";
const moment = require("moment");

export default {
  middleware: "authenticated",
  data() {
    return {
      inactiveCards: [],
      selectedCard: null,
      gettingTransactions: false,
      transactionList: [],
      currentPage: 1,
      itemsPerPage: 20,
      totalRows: 0,
      transactionFields: [
        {
          key: "time_of_transaction_with_offset",
          label: "tijdstip",
          sortable: true,
          formatter: value => {
            return moment(value).format("lll");
          }
        },
        {
          key: "amount",
          label: "bedrag",
          sortable: true,
          formatter: value => {
            return ("€ " + parseFloat(value).toFixed(2)).replace(".", ",");
          }
        },
        {
          key: "description",
          label: "beschrijving",
          sortable: true
        },
        {
          key: "return",
          label: "Teruggave / Oplading"
        },
        "Verbruik"
      ],
      orderFields: [
        {
          key: "article.name",
          label: "artikel",
          sortable: true
        },
        {
          key: "amount",
          label: "aantal",
          sortable: true
        },
        {
          key: "netto_total",
          label: "bedrag",
          sortable: true,
          formatter: value => {
            return ("€ " + parseFloat(value).toFixed(2)).replace(".", ",");
          }
        }
      ]
    };
  },
  computed: {
    linkedCards: {
      get() {
        var entireList = [];
        var inactiveCards = [];
        var excludedTypes = [2, 3]; //TODO: this should come from a setting later
        if (this.$store.state.loginObject) {
          this.$store.state.loginObject.FullAccount.users.forEach(element => {
            if (element.users_id.selective_card_visibility) {
              var allowedRay = [];
              this.$store.state.loginObject.FullAccount.allowed_card_leasings.forEach(
                item => {
                  allowedRay.push(item.cardleasings_id.id);
                }
              );
              element.users_id.card_leasings.forEach(nested => {
                if (allowedRay.includes(nested.id)) {
                  if (!excludedTypes.includes(nested.card_leasing_type.id)) {
                    entireList.push(nested);
                  }
                }
              });
            } else {
              element.users_id.card_leasings.forEach(nested => {
                if (!excludedTypes.includes(nested.card_leasing_type.id)) {
                  entireList.push(nested);
                }
              });
            }
          });
        }
        this.inactiveCards = inactiveCards;
        return entireList;
      },
      set() {}
    }
  },
  methods: {
    activeVariant(card) {
      var filterBool =
        new Date(card.from) < new Date() &&
        (new Date(card.till) > new Date() || card.till == null) &&
        card.active;
      if (filterBool) {
        return "";
      } else {
        return "secondary";
      }
    },
    showPrice(price) {
      return ("€ " + parseFloat(price).toFixed(2)).replace(".", ",");
    },
    openTransactions(linkedCard) {
      this.selectedCard = linkedCard;
      this.gettingTransactions = true;
      this.$bvModal.show("transactiesModal");
      tobackend
        .getPagedTransactions(
          this.$store,
          this.itemsPerPage,
          this.pageNumber,
          linkedCard.id
        )
        .then(result => {
          this.transactionList = result;
          if (this.totalRows == 0) {
            return tobackend.getTransactionsCount(this.$store, linkedCard.id);
          } else {
            return null;
          }
        })
        .then(result => {
          if (result) {
            this.totalRows = result.rows;
          }
        })
        .catch(err => {
          console.log(err);
        })
        .finally(() => {
          this.gettingTransactions = false;
        });
    },
    closeTransactions() {
      this.$bvModal.hide("transactiesModal");
    },
    rowClass(item) {
      if (!item) return;
      if (item.top_off) return "table-success";
    },
    getItems(itemsPerPage, page, id) {
      this.gettingTransactions = true;
      tobackend
        .getPagedTransactions(this.$store, itemsPerPage, page, id)
        .then(result => {
          this.transactionList = result;
          if (this.totalRows == 0) {
            return tobackend.getTransactionsCount(this.$store, id);
          } else {
            return null;
          }
        })
        .then(result => {
          if (result) {
            this.totalRows = result.rows;
          }
        })
        .catch(err => {
          console.log(err);
        })
        .finally(() => {
          this.gettingTransactions = false;
        });
    }
  },
  watch: {
    currentPage: {
      handler: function(value) {
        this.getItems(this.itemsPerPage, value, this.selectedCard.id);
      }
    },
    itemsPerPage: {
      handler: function(value) {
        this.getItems(value, this.currentPage, this.selectedCard.id);
      }
    }
  }
};
</script>

<style scoped></style>
