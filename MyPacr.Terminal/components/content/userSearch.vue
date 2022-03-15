<template>
  <b-card
    border-variant="primary"
    header="Klant Opzoeken"
    header-bg-variant="primary"
    header-text-variant="white"
    align="center"
    style="height: 100%"
  >
    <vue-simple-suggest
      :list="getCustomers"
      :listIsRequest="true"
      :filter-by-query="true"
      :max-suggestions="15"
      :min-length="3"
      :debounce="200"
      mode="select"
      display-attribute="fullName"
      @blur="hide"
      @select="getFullcustomer"
      data-layout="normal"
      :styles="styleObject"
    >
      <div slot="suggestion-item" slot-scope="{ suggestion }">
        <span>{{ suggestion.first_name }} {{ suggestion.last_name }}</span>
      </div>
    </vue-simple-suggest>
    <hr />
    <div class="text-center" v-if="spinner">
      <b-spinner
        variant="primary"
        label="Klant aan het ophalen..."
        class="m-5"
      ></b-spinner>
      <h4>Klant aan het ophalen...</h4>
    </div>
    <div v-else>
      <div v-if="currentCustomer">
        <h4 class="text-center">
          {{ currentCustomer.first_name }}
          {{ currentCustomer.last_name }}
        </h4>
        <hr />
        <b-container class="bv-example-row">
          <b-row>
            <b-col>
              <img
                :src="createArticleThumbnail(currentCustomer.picture)"
                class="float-left"
            /></b-col>

            <b-col>
              <div><span class=" m-1 align-top">Klas: </span></div>
              <div><span class=" m-1 align-top">Campus: </span></div>
              <div><span class=" m-1 align-top">Groep: </span></div>
            </b-col>
            <b-col>
              <div>
                <span class=" m-1 align-top">{{
                  currentCustomer.classgroup
                    ? currentCustomer.classgroup.name
                    : ''
                }}</span>
              </div>
              <div>
                <span class=" m-1 align-top"
                  >{{
                    currentCustomer.campus
                      ? currentCustomer.campus.short_name
                      : ''
                  }}
                </span>
              </div>
              <div>
                <span class=" m-1 align-top"
                  >{{ usergroupArrayToString(currentCustomer.usergroup) }}
                </span>
              </div>
            </b-col>
          </b-row>
        </b-container>
      </div>
      <div v-else>
        <h4>Geen Klant geselecteerd</h4>
      </div>
    </div>
    <hr />
    <div></div>
    <div slot="footer" class="text-center">
      <div v-if="currentCustomer">
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
</template>

<script>
import tobackend from '~/plugins/2backend.js'
import VueSimpleSuggest from 'vue-simple-suggest'
import 'vue-simple-suggest/dist/styles.css' // Using a css-loader
import VueTouchKeyboard from 'vue-touch-keyboard'
import 'vue-touch-keyboard/dist/vue-touch-keyboard.css' // load default style
import Vue from 'vue'
Vue.use(VueTouchKeyboard)

export default {
  name: 'userSearch',
  data() {
    return {
      visible: false,
      layout: 'normal',
      input: null,
      options: {
        useKbEvents: false,
        preventClickEvent: true
      },
      lastText: '',
      spinner: false,
      customers: [],
      customerSearch: '',
      styleObject: {
        defaultInput: 'btn-rounded-left btn-rounded-right text-center'
      }
    }
  },
  computed: {
    currentCustomer: {
      get() {
        var tmp = this.$store.state.currentCustomerForLink
        return tmp
      },
      set() {
        //
      }
    }
  },
  methods: {
    setTyping: function(typing) {
      this.$store.commit('setCurrentlyTyping', typing)
    },
    clearCurrentUser: function() {
      console.log("clearing")
      this.$store.commit('setCurrentCustomerForLink', null)
    },
    usergroupArrayToString: function(userGroupsArray) {
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
    createArticleThumbnail: function(filename) {
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
    getCustomers(query) {
      return tobackend.getUserSuggestionsBySearchKey(query)
    },
    getFullcustomer(item) {
      if (item != null) {
        this.customerSearch = ''
        console.log(item);
        tobackend.getUserByIdForLink(this.$store, item.id).then(() => {
          //wait for completion
        })
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
    }
  },
  beforeMount: function() {
    //check if articles are already loaded. If not, get it from server
    if (tobackend.isLoggedIn(this.$store)) {
      if (!this.$store.state.userGroups) {
        tobackend.getUserGroups(this.$store).then(() => {
          //wait for complete
        })
      }
    }
  },
  components: {
    VueSimpleSuggest
  }
}
</script>

<style scoped></style>
