<template>
  <b-card
    border-variant="primary"
    header="Kaart Scannen"
    header-bg-variant="primary"
    header-text-variant="white"
    align="center"
    style="height: 100%"
  >
    <div class="text-center" v-if="spinner">
      <b-spinner
        variant="primary"
        label="Klant aan het ophalen..."
        class="m-5"
      ></b-spinner>
      <h4>Kaart aan het ophalen</h4>
    </div>
    <div v-else>
      <div v-if="currentCardForLink != null">
        <h4 class="text-center">
          {{ cardCode }}
        </h4>
        <hr />
        <p v-if="currentCardForLinkInUse" class="text-danger">
          Kaart reeds in gebruik, kan niet koppelen
        </p>
        <p v-else class="text-success">
          Kaart kan gekoppeld worden
        </p>
        <p></p>
      </div>
      <div v-else>
        <p>Leg een kaart op de reader</p>
        <hr />
        <h4>Geen Kaart geselecteerd</h4>
      </div>
    </div>
    <hr />
    <div></div>
  </b-card>
</template>

<script>
import converter from '~/plugins/altcodeConverter.js'
import tobackend from '~/plugins/2backend.js'

export default {
  name: 'cardSearch',
  data() {
    return {
      msAfterScans: 500,
      isScanning: false,
      currentCode: '',
      currentCharSeq: '',
      spinner: false,
      cardCode: ''
    }
  },
  computed: {
    currentCardForLinkInUse: {
      get() {
        return this.$store.state.currentCardForLinkInUse
      },
      set() {
        //
      }
    },
    currentCardForLink: {
      get() {
        return this.$store.state.currentCardForLink
      },
      set() {
        //
      }
    },
    currentAttendenceCustomer: {
      get() {
        return this.$store.state.currentCustomerForAttendence
      },
      set() {
        //
      }
    }
  },
  created: function() {
    window.addEventListener('keydown', this.scanEvent)
  },
  destroyed: function() {
    window.removeEventListener('keydown', this.scanEvent)
  },
  methods: {
    scanEvent: function(event) {
      if (!this.$store.state.currentlyTyping) {
        if (!this.isScanning) {
          this.initiateScan()
        }
        this.currentCharSeq += event.key
      }
    },
    initiateScan: function() {
      this.isScanning = true
      setTimeout(() => {
        //convert char Sequence
        var ray = this.currentCharSeq.split('Alt')
        var code = ''
        if (ray.length > 1) {
          ray.forEach((item) => {
            code += converter.convertAltCode(Number(item).toString())
          })
        } else {
          code = this.currentCharSeq.split('Shift').join('')
        }
        if (code.endsWith(';')) {
          code = code.slice(0, code.length - 1)
          if (code.length == 16) {
            code = code.substring(8)
            this.getUserByCardAttendence(code)
          }
        } else {
          if (code.length == 16) {
            code = code.substring(8)
            this.spinner = true
            this.getUserByCard(code)
          } else {
            //wrong format?
          }
          //print entire Card Id
        }
        this.isScanning = false
        this.currentCharSeq = ''
      }, this.msAfterScans)
    },
    getUserByCard: function(cardId) {
      tobackend.getCardForLinking(this.$store, cardId).then(() => {
        //wait for complete
        this.cardCode = cardId
        this.spinner = false
      })
    },
    getUserByCardAttendence: function(cardId) {
      tobackend
        .getUserCardByCardId(this.$store, cardId, true)
        .then((resp) => {
          //wait for complete

          if (!resp) {
            this.spinner = false
            this.$bvToast.toast(
              'Kan gebruiker: ' +
                this.currentAttendenceCustomer.user.first_name +
                ' ' +
                this.currentAttendenceCustomer.user.last_name +
                ' niet vinden',
              {
                toaster: 'b-toaster-top-center',
                title: 'Aanwezigheden',
                variant: 'danger',
                autoHideDelay: 5000,
                appendToast: false
              }
            )
          } else {
            return tobackend.createAttendence(this.$store)
          }
        })
        .then(() => {
          this.spinner = false
          this.$bvToast.toast(
            'Aanwezigheid Geregistreerd voor gebruiker: ' +
              this.currentAttendenceCustomer.user.first_name +
              ' ' +
              this.currentAttendenceCustomer.user.last_name,
            {
              toaster: 'b-toaster-top-center',
              title: 'Aanwezigheden',
              variant: 'success',
              autoHideDelay: 5000,
              appendToast: false
            }
          )
        })
    }
  }
}
</script>

<style></style>
