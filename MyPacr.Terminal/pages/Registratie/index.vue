<template>
  <div class="d-sm-flex justify-content-between col-12">
    <div class="col-3"></div>
    <div class="col-6">
      <div>
        <div class="row">
          <div class="col-12">
            <b-card
              border-variant="primary"
              header="RegistratieSysteem"
              header-bg-variant="primary"
              header-text-variant="white"
              style="min-height: 20rem"
            >
              <div class="text-center" v-if="spinner">
                <b-spinner
                  variant="primary"
                  label="Gebruiker aan het ophalen..."
                  class="m-5"
                ></b-spinner>
                <h4>Gebruiker aan het ophalen...</h4>
              </div>
              <div v-else>
                <div v-if="currentParticipant">
                  <h4 class="text-center">
                    {{ currentParticipant.user.first_name }}
                    {{ currentParticipant.user.last_name }}
                  </h4>
                  <hr />
                  <b-container class="bv-example-row">
                    <b-row>
                      <b-col>
                        <img
                          :src="
                            createArticleThumbnail(
                              currentParticipant.user.picture
                            )
                          "
                          class="float-left"
                      /></b-col>

                      <b-col>
                        <h4 class="m-3 align-top">Saldo:</h4>
                        <div><span class="m-3 align-top">Klas: </span></div>
                        <div><span class="m-3 align-top">Campus: </span></div>
                        <div><span class="m-3 align-top">Groep: </span></div>
                      </b-col>
                      <b-col
                        ><h4
                          class="m-3 align-top"
                          :class="{
                            'text-danger':
                              parseFloat(currentParticipant.saldo) <= 0,
                            'text-success':
                              parseFloat(currentParticipant.saldo) < 0,
                          }"
                        >
                          {{
                            '€ ' +
                            parseFloat(currentParticipant.saldo).toFixed(2)
                          }}
                        </h4>
                        <div>
                          <span class="m-3 align-top">{{
                            currentParticipant.user.classgroup
                              ? currentParticipant.user.classgroup.name
                              : ''
                          }}</span>
                        </div>
                        <div>
                          <span class="m-3 align-top"
                            >{{
                              currentParticipant.user.campus
                                ? currentParticipant.user.campus.short_name
                                : ''
                            }}
                          </span>
                        </div>
                        <div>
                          <span class="m-3 align-top"
                            >{{
                              usergroupArrayToString(
                                currentParticipant.user.usergroup
                              )
                            }}
                          </span>
                        </div>
                      </b-col>
                    </b-row>
                  </b-container>
                </div>
                <div v-else>
                  <div v-if="eventLocked">
                    <h4>{{ currentSelectedEvent.name }}</h4>
                  </div>
                  <div v-else>
                    <b-row class="my-1">
                      <b-col sm="4">
                        <label for="input-large">Selecteer Event:</label>
                      </b-col>
                      <b-col sm="8">
                        <b-form-select
                          v-model="currentSelectedEvent"
                          :options="knownEvents"
                          class="btn-rounded-left btn-rounded-right text-center"
                          style="
                            padding: 0 0 0 0 !important;
                            padding-left: 10px !important;
                          "
                          size="lg"
                        ></b-form-select>
                      </b-col>
                    </b-row>
                  </div>
                  <h4>Zoek gebruiker of scan kaart</h4>

                  <vue-simple-suggest
                    :list="getCards"
                    :listIsRequest="true"
                    :filter-by-query="true"
                    :max-suggestions="15"
                    :min-length="3"
                    :debounce="200"
                    mode="select"
                    display-attribute="fullName"
                    @blur="hide"
                    @select="getFullCardUser"
                    data-layout="normal"
                    :styles="styleObject"
                  >
                  </vue-simple-suggest>
                </div>
              </div>

              <div></div>
              <div slot="footer" class="text-center">
                <div v-if="currentParticipant">
                  <b-button
                    variant="outline-danger"
                    class="btn-rounded-left btn-rounded-right text-center"
                    size="lg"
                    @click="clearCurrentUser"
                  >
                    <i class="fas fa-user-times fa-lg"
                  /></b-button>
                </div>
              </div>
              <vue-touch-keyboard
                id="keyboard"
                :options="options"
                v-if="visible"
                :layout="layout"
                :cancel="hide"
                :accept="accept"
                :input="input"
              />
            </b-card>
          </div>
        </div>
      </div>
    </div>
    <div class="col-3"></div>
  </div>
</template>

<script>
import VueSimpleSuggest from 'vue-simple-suggest'
import 'vue-simple-suggest/dist/styles.css' // Using a css-loader
import VueTouchKeyboard from 'vue-touch-keyboard'
import 'vue-touch-keyboard/dist/vue-touch-keyboard.css' // load default style
import Vue from 'vue'
Vue.use(VueTouchKeyboard)

import converter from '~/plugins/altcodeConverter.js'
import tobackend from '~/plugins/2backend.js'

var defaultUserGroupObject = ''

export default {
  name: 'registratieSysteem',
  middleware: ['authenticated', 'terminalSet', 'checkForGlobalData'],
  data() {
    return {
      msAfterScans: 500,
      isScanning: false,
      currentCode: '',
      currentCharSeq: '',
      spinner: false,
      currentUserGroup: defaultUserGroupObject,
      visible: false,
      layout: 'normal',
      input: null,
      options: {
        useKbEvents: false,
        preventClickEvent: true,
      },
      lastText: '',
      styleObject: {
        defaultInput: 'btn-rounded-left btn-rounded-right text-center',
      },
      selectedEvent: null,
    }
  },
  computed: {
    currentParticipant: {
      get() {
        var tmp = this.$store.state.currentParticipant
        console.log(tmp)
        return tmp
      },
      set() {
        //
      },
    },
    currentSelectedEvent: {
      get() {
        var tmp = this.$store.state.currentSelectedEvent
        return tmp
      },
      set(theEvent) {
        this.$store.commit('setCurrentSelectedEvent', theEvent)
        console.log(theEvent)
      },
    },
    eventLocked: {
      get() {
        var tmp = this.$store.state.currentTerminalInfo.eventlocked
        return tmp
      },
      set() {
        //
      },
    },
    knownEvents: {
      get() {
        var returnRay = [{ value: null, text: 'Kies een Event' }]
        console.log('here')
        if (this.$store.state.registeredEvents) {
          this.$store.state.registeredEvents.forEach((element) => {
            console.log(element)
            returnRay.push({
              value: element,
              text: element.name,
            })
          })
          return returnRay
        } else {
          return returnRay
        }
      },
      set() {},
    },
  },
  beforeMount: function () {
    if (tobackend.isLoggedIn(this.$store)) {
      if (!this.$store.state.userGroups) {
        tobackend.getUserGroups(this.$store).then(() => {
          //wait for completion
        })
      }
      if (
        !this.$store.state.registeredEvents ||
        this.$store.state.registeredEvents.length == 0
      )
        tobackend
          .getRegisteredEvents(this.$store)
          .then(() => {
            console.log('registeredEvents:')
            console.log(this.$store.state.registeredEvents)
          })
          .catch(() => {
            //swallow it.
          })
    }
  },
  created: function () {
    window.addEventListener('keydown', this.scanEvent)
  },
  destroyed: function () {
    window.removeEventListener('keydown', this.scanEvent)
  },
  methods: {
    scanEvent: function (event) {
      if (!this.$store.state.currentlyTyping) {
        if (!this.isScanning) {
          this.initiateScan()
        }
        this.currentCharSeq += event.key
      }
    },
    initiateScan: function () {
      this.isScanning = true
      setTimeout(() => {
        //convert char sequence

        var ray = this.currentCharSeq.split('Alt')
        var code = ''
        console.log(ray)
        if (ray.length > 1) {
          ray.forEach((item) => {
            code += converter.convertAltCode(Number(item).toString())
          })
        } else {
          code = this.currentCharSeq.split('Shift').join('')
        }
        if (code.endsWith(';')) {
          //just trim it, doesnt matter on this page
          code = code.slice(0, code.length - 1)
        } else {
          if (code.length == 16) {
            code = code.substring(8)
            console.log(code)
            this.spinner = true
            this.getUserByCard(code)
          } else {
            //wrong format?
          }
          //print the entire CardId
        }
        this.isScanning = false
        this.currentCharSeq = ''
      }, this.msAfterScans)
    },
    getUserByCard: function (cardId) {
      tobackend
        .getUserCardByCardId(this.$store, cardId, true, 'setCurrentParticipant')
        .then((resp) => {
          if (!resp) {
            this.spinner = false
            console.log(this.currentParticipant)
            this.$bvToast.toast(
              'Kan gebruiker: ' +
                this.currentParticipant.user.first_name +
                ' ' +
                this.currentParticipant.user.last_name +
                ' niet vinden',
              {
                toaster: 'b-toaster-top-center',
                title: 'Registratie',
                variant: 'danger',
                autoHideDelay: 5000,
                appenToast: false,
              }
            )
          } else {
            return tobackend.createRegistration(this.$store)
          }
        })
        .then(() => {
          this.spinner = false
          this.$bvToast.toast(
            'Registratie voltooid voor gebruiker: ' +
              this.currentParticipant.user.first_name +
              ' ' +
              this.currentParticipant.user.last_name,
            {
              toaster: 'b-toaster-top-center',
              title: 'Registratie',
              variant: 'success',
              autoHideDelay: 5000,
              appenToast: false,
            }
          )
        })
        .catch((rslt) => {
          console.log(rslt)
          this.spinner = false
          this.$bvToast.toast(rslt.message, {
            toaster: 'b-toaster-top-center',
            title: 'Registratie',
            variant: 'danger',
            autoHideDelay: 5000,
            appenToast: false,
          })
        })
    },
    createArticleThumbnail: function (filename) {
      if (!filename) {
        return ''
      } else {
        return tobackend.getThumbnail(
          filename.filename_download,
          300,
          150,
          'contain'
        )
      }
    },
    getUserGroups: function (userGroupsArray) {
      console.log('Entered usergroupFormat Function')
      console.log(this.$store.state.userGroups)
      console.log(userGroupsArray)
    },
    usergroupArrayToString: function (userGroupsArray) {
      var returnString = ''

      userGroupsArray.forEach((element) => {
        if (returnString == '') {
          returnString += element.usergroups_id.name
        } else {
          var stringToAdd = ', ' + element.usergroups_id.name
          returnString += stringToAdd
        }
      })
      return returnString
    },
    clearCurrentUser: function () {
      this.$store.commit('setCurrentParticipant', null)
    },
    getCards: function (query) {
      return tobackend.getCardSuggestionsBySearchKey(query)
    },
    getFullCardUser: function (item) {
      if (item != null) {
        this.getUserByCard(item.card.code)
      }
    },
    accept(text) {
      this.lastText = text
      this.hide()
    },
    show(e) {
      this.input = e.target
      this.layout = e.target.dataset.layout
      if (!this.visible) this.visible = true
    },
    hide() {
      this.visible = false
    },
    UnlockEvent: function () {
      this.currentSelectedEvent = null
    },
  },
  components: {
    VueSimpleSuggest,
  },
}
</script>

<style></style>
