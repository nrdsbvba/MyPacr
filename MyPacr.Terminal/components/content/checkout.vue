<template>
  <b-card
    border-variant="primary"
    header="BestellingsOverzicht"
    header-bg-variant="primary"
    header-text-variant="white"
    style="min-height: 20rem;"
  >
    <b-table :items="checkoutList" :fields="checkoutFields" responsive="sm">
      <template slot="[actions]" slot-scope="row">
        <b-button
          variant="primary"
          size="sm"
          @click="oneLess(row.item)"
          class="mr-1"
        >
          <i class="fas fa-arrow-down" />
        </b-button>
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
    <span
      class="text-right text-warning"
      v-if="entryFeePayed != null && no_attendence_fee"
    >
      bij het bestellen krijgt u het stoeltjesgeld ter waarde van
      {{ '€ ' + parseFloat(entryFeePayed.amount).toFixed(2) }} terug</span
    >
    <div slot="footer">
      <h4 class="float-right">Totaal: {{ totaal }}</h4>
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
          variant="outline-info"
          class="btn-center-grp"
          @click="completeOrder(true)"
          :disabled="sendingOrder"
        >
          <b-spinner small v-if="sendingOrder"></b-spinner>
          <i class="fas fa-undo fa-lg" /> Teruggave
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
</template>

<script>
import tobackend from '~/plugins/2backend.js'

export default {
  name: 'checkout',
  data() {
    return {
      checkoutFields: [
        { key: 'articleName', label: 'Artikel', sortable: false },
        { key: 'number', label: 'Aantal', sortable: false },
        {
          key: 'cost',
          label: 'Prijs',
          sortable: false,
          formatter: (value) => {
            return '€ ' + parseFloat(value).toFixed(2)
          }
        },
        { key: 'actions', label: '' }
      ],
      modalmessage: '',
      sendingOrder: false
    }
  },
  computed: {
    checkoutList: {
      get() {
        return this.$store.state.checkoutCart
      },
      set() {
        //
      }
    },
    no_attendence_fee: {
      get() {
        if (this.$store.state.currentCustomerEntryFeeRefunded) {
          return false
        }
        if (this.$store.state.checkoutCart == null) {
          return false
        } else {
          return (
            this.$store.state.checkoutCart.filter((element) => {
              return element.article.no_attendence_fee
            }).length > 0
          )
        }
      }
    },
    totaal: {
      get() {
        var total = 0
        if (this.checkoutList != undefined) {
          this.checkoutList.forEach((element) => {
            total += parseFloat(element.cost)
          })
        }
        return '€ ' + parseFloat(total).toFixed(2)
      },
      set() {
        //
      }
    },
    entryFeePayed: {
      get() {
        return this.$store.state.currentCustomerEntryFeePayedToday
      },
      set() {
        //
      }
    }
  },
  methods: {
    oneLess: function(item) {
      this.$store.commit('subsctractSingleFromCheckoutCart', item)
    },
    deleteRow: function(item) {
      this.$store.commit('SubstractArticleLineFromCheckoutCard', item)
    },
    clearCart: function() {
      this.$store.commit('setCheckoutCart', [])
    },
    completeOrder: function(returnOrder) {
      //do checks
      //check if a customer is active
      if (!this.$store.state.currentCustomer) {
        this.modalmessage =
          'Kan bestelling niet plaatsen, er is geen klant geselecteerd'
        this.$bvModal.show('my-checkoutmessage-modal')
      } else {
        //check if checkout is not empty
        if (this.$store.state.checkoutCart.length == 0) {
          this.modalmessage = 'Kan bestelling niet plaatsen, winkelkar is leeg'
          this.$bvModal.show('my-checkoutmessage-modal')
        } else {
          //check for saldo
          var allowedCredit = this.$store.state.currentCustomer
            .card_leasing_type.allowed_credit
          var unlimitedCredit = this.$store.state.currentCustomer
            .card_leasing_type.unlimited_credit

          var currentSaldo = parseFloat(this.$store.state.currentCustomer.saldo)
          var totalPrice = 0
          if (this.checkoutList != undefined) {
            this.checkoutList.forEach((element) => {
              totalPrice += parseFloat(element.cost)
            })
          }
          var botoomBorder = allowedCredit * -1

          if (
            currentSaldo - totalPrice < botoomBorder &&
            !unlimitedCredit &&
            !returnOrder
          ) {
            this.modalmessage =
              'Kan bestelling niet plaatsen, saldo is ontoereikend voor de bestelling'
            this.$bvModal.show('my-checkoutmessage-modal')
          } else {
            //if all good --> completeOrder
            this.sendingOrder = true
            tobackend
              .completeOrder(
                this.$store,
                this.checkoutList,
                this.$store.state.currentCustomer,
                returnOrder
              )
              .then(() => {
                tobackend.resetState(this.$store)
                this.$bvToast.toast('bestelling succesvol  geplaatst...', {
                  title: 'bestelbevestiging',
                  autoHideDelay: 4000,
                  appendToast: false,
                  variant: 'success'
                })
              })
              .catch((err) => {
                console.log(err)
              })
              .finally(() => {
                this.sendingOrder = false
              })
          }
        }
      }
    }
  }
}
</script>

<style></style>
