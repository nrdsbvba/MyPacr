<template>
  <div class="justify-content-center">
    <div class="card o-hidden border-0 shadow-lg my-5">
      <div class="card-body p-0">
        <!-- Nested Row within Card Body -->
        <div class="row">
          <div class="col-lg-3" />
          <div class="col-lg-6 justify-content-center">
            <div class="p-5">
              <div class="text-center">
                <h1 class="h4 text-gray-900 mb-4">
                  Terminal Setup
                </h1>

                <p class="text-left ">
                  Om dit sytsteem op dit toestel te gebruiken dienen we te
                  bepalen als welke terminal (zoals aangegeven in de backend)
                  dit toestel zal opereren. Dit wordt gedaan door een cookie op
                  dit toestel te plaatsen met de info van de gekozen
                  terminalinstellingen.<br />
                  Deze Cookie zal geldig zijn tot
                  {{ cookieExperationDate }}. Nadien dient deze registratie
                  opnieuw te gebeuren.<br />Maak een keuze uit de onderstaande
                  terminals die nog niet in gebruik zijn in uw backend. Kan u de
                  correcte terminal niet vinden? Kijk dan na of deze reeds
                  geregistreerd is in de backend of dat deze reeds in gebruik is
                  (en dus geregistreerd aan een ander toestel)
                </p>
              </div>
              <form class="user">
                <div class="form-group">
                  <b-form-select
                    v-model="selected"
                    :options="TerminalOptions"
                    class=""
                  />
                </div>
                <div class="text-center" v-if="savingTerminal">
                  <b-spinner
                    variant="primary"
                    label="Loading..."
                    class="m-5"
                  ></b-spinner>
                </div>
                <a
                  href="#"
                  @click="chooseTerminal"
                  class="btn btn-primary btn-user btn-block"
                >
                  Terminal Opslaan
                </a>
              </form>
            </div>
          </div>
          <div class="col-lg-3"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import tobackend from '~/plugins/2backend.js'
import moment from 'moment'
import uuidv1 from 'uuid/v1'
import cookiePlugin from '~/plugins/vue-cookie.js'

export default {
  middleware: ['authenticated', 'checkForGlobalData'],
  layout: 'clean',
  data() {
    return {
      savingTerminal: false,
      selected: null
    }
  },
  computed: {
    cookieExperationDate: {
      get() {
        console.log(this.$store.state)
        if (this.$store.state.globalSettings) {
          return moment(
            this.$store.state.globalSettings.cookie_expiration
          ).format('DD-MM-YYYY')
        } else {
          return ''
        }
      },
      set() {
        
      }
    },
    cookieExpirationDateAsDate: {
      get() {
        if (this.$store.state.globalSettings) {
          return new Date(this.$store.state.globalSettings.cookie_expiration)
        } else {
          return null
        }
      },
      set() {
        
      }
    },
    TerminalOptions: {
      get() {
        var returnRay = [{ value: null, text: 'Kies een Terminal' }]
        if (this.$store.state.terminalOptions) {
          this.$store.state.terminalOptions.forEach((element) => {
            returnRay.push({
              value: element,
              text: element.code
            })
          })
          return returnRay
        } else {
          return returnRay
        }
      },
      set() {}
    }
  },
  methods: {
    chooseTerminal() {
      this.savingTerminal = true

      //generate Uuid
      var UUID = uuidv1()

      //save terminal to backend
      tobackend
        .setTerminal(
          this.selected,
          UUID,
          moment(this.cookieExpirationDateAsDate).format('YYYY-MM-DD')
        )
        .then(() => {
          //save terminal to cookie
          cookiePlugin.set('terminalinfo', UUID, {
            expires: this.cookieExpirationDateAsDate
          })
          this.$bvToast.toast('succesvol terminal gekoppeld. doorsturen...', {
            title: 'Terminal Gekoppeld',
            variant: 'success',
            toaster: 'b-toaster-top-center',
            autoHideDelay: 5000,
            appendToast: false
          })
          setTimeout(() => {
            this.$router.push('/kassa')
          }, 1000)
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {
          this.savingTerminal = false
        })
    }
  }
}
</script>

<style></style>
