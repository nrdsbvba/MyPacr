<template>
  <div class="d-sm-flex  justify-content-between col-12">
    <div class="col-lg-8">
      <div>
        <div class="row">
          <div class="col-12">
            <b-card
              border-variant="primary"
              header="Kaart Herladen"
              header-bg-variant="primary"
              header-text-variant="white"
              style="min-height: 20rem;"
            >
              <p v-if="linkedCards.length == 0">
                Geen Kaarten teruggevonden voor deze account
              </p>
              <b-card-group>
                <b-card
                  v-for="linkedCard in linkedCards"
                  :key="linkedCard.id"
                  style="max-width:20rem;"
                  class="m-1"
                >
                  <b-card-title style="font-size:1rem;">
                    Gebruiker: {{ linkedCard.user.first_name }}
                    {{ linkedCard.user.last_name }} <br />
                    KaartCode: {{ linkedCard.card.code }} <br />KaartType:
                    {{ linkedCard.card_leasing_type.name }} <br />
                    Beschrijving: {{ linkedCard.description }} <br />
                    Saldo: {{ showPrice(linkedCard.saldo) }}
                  </b-card-title>
                  <div slot="footer">
                    <b-input-group size="lg">
                      <b-form-input
                        type="number"
                        :ref="'tempQuantity-' + linkedCard.id"
                        class="form-control-rounded"
                        placeholder="Bedrag"
                      ></b-form-input>
                      <b-input-group-append>
                        <b-button
                          variant="primary"
                          @click="StartTopOff(linkedCard)"
                          class="btn-rounded-right"
                        >
                          Opladen</b-button
                        >
                      </b-input-group-append>
                    </b-input-group>
                  </div>
                </b-card>
              </b-card-group></b-card
            >
          </div>
        </div>
      </div>
    </div>
    <div class="col-lg-4">
      <b-card
        border-variant="primary"
        header="OpladingsMandje"
        header-bg-variant="primary"
        header-text-variant="white"
        style="min-height: 20rem;"
      >
        <b-table :items="checkoutList" :fields="checkoutFields" responsive>
          <template v-slot:cell(actions)="row">
            <b-button
              size="sm"
              variant="outline-danger"
              @click="deleteRow(row.item)"
              class
            >
              <i class="fas fa-trash" />
            </b-button>
          </template>
        </b-table>
        <span class="text-right text-warning" v-if="countdossierskost">
          Voor deze transactie wordt een dossierskost van
          {{
            "€ " +
              parseFloat(dossierskost)
                .toFixed(2)
                .replace(".", ",")
          }}
          aangerekend</span
        >
        <div slot="footer">
          <h4 class="float-right">Totaal: {{ totaalkost }}</h4>
          <b-button-group size="lg">
            <b-button
              variant="outline-danger"
              class="btn-rounded-left"
              @click="clearCart"
              :disabled="sendingOrder"
            >
              <i class="fas fa-trash fa-lg" />
            </b-button>
            <b-button
              variant="primary"
              class="btn-rounded-right"
              @click="completeOrder(false)"
              :disabled="sendingOrder"
            >
              <b-spinner small v-if="sendingOrder"></b-spinner>
              <i class="fas fa-shopping-cart fa-lg" /> Bestellen
            </b-button>
          </b-button-group>
        </div>
        <b-modal id="my-checkoutmessage-modal">{{ modalmessage }}</b-modal>
      </b-card>
    </div>
    <b-modal
      id="betalingsModal"
      title="Betalen"
      no-close-on-backdrop
      ok-disabled
      cancel-disabled
    >
      <div class="text-center" v-if="gettingPaymentLink">
        <b-spinner
          variant="primary"
          label="Even geduld..."
          class="m-5"
        ></b-spinner>
        <h4>Even Geduld...</h4>
      </div>
      <div v-else>
        Klik op onderstaande knop om de transactie te betalen
        <a :href="thePaymentLink" class="btn btn-primary">Betalen</a>
      </div>
    </b-modal>
  </div>
</template>

<script>
import tobackend from "~/plugins/2backend.js";

export default {
  middleware: "authenticated",
  data() {
    return {
      currentAmount: 0.0,
      cardCode: "",
      gettingPaymentLink: false,
      thePaymentLink: "",
      checkoutFields: [
        { key: "cardName", label: "Kaart", sortable: false },
        {
          key: "amount",
          label: "Bedrag",
          sortable: false,
          formatter: value => {
            return "€ " + parseFloat(value).toFixed(2);
          }
        },
        { key: "actions", label: "" }
      ],
      checkoutList: [],
      modalmessage: "",
      sendingOrder: false,
      dossierskost: 0.2 //TODO: has to come from global settings
    };
  },
  computed: {
    linkedCards: {
      get() {
        var entireList = [];
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
                    var filterBool =
                      new Date(nested.from) < new Date() &&
                      (new Date(nested.till) > new Date() ||
                        nested.till == null) &&
                      nested.active;

                    if (filterBool) {
                      entireList.push(nested);
                    }
                  }
                }
              });
            } else {
              element.users_id.card_leasings.forEach(nested => {
                if (!excludedTypes.includes(nested.card_leasing_type.id)) {
                  var filterBool =
                    new Date(nested.from) < new Date() &&
                    (new Date(nested.till) > new Date() ||
                      nested.till == null) &&
                    nested.active;

                  if (filterBool) {
                    entireList.push(nested);
                  }
                }
              });
            }
          });
        }
        return entireList;
      },
      set() {}
    },
    countdossierskost: {
      get() {
        return this.checkoutList.length > 0;
      },
      set() {
        //
      }
    },
    totaalkost: {
      get() {
        var amount = 0;
        this.checkoutList.forEach(element => {
          amount += parseFloat(element.amount);
        });
        if (amount > 0) {
          amount += parseFloat(this.dossierskost);
        }

        return (
          "€ " +
          parseFloat(amount)
            .toFixed(2)
            .replace(".", ",")
        );
      },
      set() {}
    }
  },
  mounted: () => {
    if (navigator.userAgent.indexOf("Firefox") != -1) {
      $(':input[type="number"]').prop("type", "text");
    }
  },
  methods: {
    showPrice(price) {
      return ("€ " + parseFloat(price).toFixed(2)).replace(".", ",");
    },
    completeOrder() {
      this.$bvModal
        .msgBoxConfirm(
          "Bent u zeker dat u de gekozen opladingen wil betalen voor de totaalprijs van: " +
            this.totaalkost +
            " ?",
          {
            title: "Bent u zeker",
            okVariant: "danger",
            okTitle: "Ja",
            cancelTitle: "Nee",
            footerClass: "p-2",
            hideHeaderClose: false,
            centered: true,
            vaiant: "primary"
          }
        )
        .then(value => {
          if (value) {
            //initiate payment
            console.log("initiate payment");
            this.gettingPaymentLink = true;
            this.sendingOrder = true;
            this.$bvModal.show("betalingsModal");

            //create TopOffArray
            var topOffs = [];
            this.checkoutList.forEach(element => {
              topOffs.push({
                card_leasing: {
                  id: element.card_leasing.id
                },
                amount: element.amount,
                completed: false
              });
            });

            tobackend
              .initiatePayment(
                {
                  email: this.$store.state.loginObject.FullAccount.email,
                  topOffs: topOffs,
                  coaccount_id: this.$store.state.loginObject.FullAccount.id
                },
                this.$store.state.loginObject.token
              )
              .then(url => {
                this.thePaymentLink = url;
                this.gettingPaymentLink = false;
                this.sendingOrder = false;
              });
          } else {
            // do nothing
            console.log("user said no");
          }
        });
    },
    deleteRow(item) {
      var newArray = this.checkoutList.filter(element => {
        return element.card_leasing.id != item.card_leasing.id;
      });
      this.checkoutList = newArray;
    },
    clearCart() {
      this.checkoutList = [];
    },
    StartTopOff(linkedCard) {
      var number = this.$refs["tempQuantity-" + linkedCard.id][0].$el.value.replace(',', '.');
      if (typeof parseFloat(number) != "number" || isNaN(parseFloat(number))) {
        this.$bvModal.msgBoxOk('Uw ingave is geen geldig bedrag, gelieve een geldig bedrag in te geven')
        .then(value=>{
          //do nothing
        })
        .catch(err=>{
          console.log(err)
        })
      } else {
        this.currentAmount = parseFloat(number);
        this.cardCode = linkedCard.card.code;

        this.$bvModal
          .msgBoxConfirm(
            "Oplading Toevoegen aan opladingsmandje voor " +
              linkedCard.user.first_name +
              " " +
              linkedCard.user.last_name +
              " (" +
              linkedCard.description +
              ")" +
              " voor het bedrag van " +
              this.showPrice(this.currentAmount) +
              " ?",
            {
              title: "Bent u zeker",
              okVariant: "danger",
              okTitle: "Ja",
              cancelTitle: "Nee",
              footerClass: "p-2",
              hideHeaderClose: false,
              centered: true,
              variant: "primary"
            }
          )
          .then(value => {
            if (value) {
              this.checkoutList.push({
                card_leasing: linkedCard,
                amount: this.currentAmount,
                cardName:
                  linkedCard.user.first_name +
                  " " +
                  linkedCard.user.last_name +
                  " (" +
                  linkedCard.description +
                  ")"
              });
            } else {
              // do nothing
              console.log("user said no");
            }
          });
      }
    }
  }
};
</script>

<style>
.custom-checkbox.small label {
  line-height: 1.5rem;
}

.form-control-rounded {
  font-size: 0.8rem !important;
  border-top-left-radius: 10rem !important;
  border-bottom-left-radius: 10rem !important;
  padding: 1.5rem 1rem !important;
}

.btn-rounded {
  font-size: 1rem;
  border-top-right-radius: 10rem !important;
  border-bottom-right-radius: 10rem !important;
  padding: 0.75rem 1rem !important;
}
.btn-rounded-left {
  font-size: 0.9rem !important ;
  border-top-left-radius: 10rem !important;
  border-bottom-left-radius: 10rem !important;
  padding: 0.75rem 1rem !important;
}
.btn-rounded-right {
  font-size: 0.9rem !important;
  border-top-right-radius: 10rem !important;
  border-bottom-right-radius: 10rem !important;
  padding: 0.75rem 1rem !important;
}
.btn-center-grp {
  font-size: 0.9rem !important;
  padding: 0.75rem 1rem !important;
}
</style>