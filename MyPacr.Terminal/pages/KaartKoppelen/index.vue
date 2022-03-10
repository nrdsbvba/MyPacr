<template>
  <div class="d-sm-flex justify-content-between col-12">
    <div class="col-1"></div>
    <div class="col-10">
      <div>
        <div class="row">
          <div class="col-6">
            <userSearch />
          </div>
          <div class="col-6">
            <cardSearch />
          </div>
        </div>
      </div>
      <hr />
      <div class="row">
        <div class="col-2"></div>
        <div class="col-8">
          <b-card
            border-variant="primary"
            header="Kaart Koppelen"
            header-bg-variant="primary"
            header-text-variant="white"
            align="center"
            style="height: 100%"
          >
            <b-row class="my-1">
              <b-col sm="4">
                <label for="input-large"
                  >optionele beschrijving voor de kaart:</label
                >
              </b-col>
              <b-col sm="8">
                <b-form-input
                  id="input-large"
                  v-model="description"
                  @focus="show"
                  @blur="hide"
                  data-layout="normal"
                  class="btn-rounded-left btn-rounded-right text-center"
                  size="lg"
                ></b-form-input>
              </b-col>
            </b-row>
            <b-row class="my-1">
              <b-col sm="4">
                <label for="input-large">KaartType:</label>
              </b-col>
              <b-col sm="8">
                <b-form-select
                  v-model="selectedType"
                  :options="typeOptions"
                  class="btn-rounded-left btn-rounded-right text-center"
                  style="padding:0 0 0 0 !important; padding-left:10px !important"
                  size="lg"
                ></b-form-select>
              </b-col>
            </b-row>
            <b-button
              variant="primary"
              :disabled="PossibleToLink"
              @click="LinkCard"
            >
              <i class="fas fa-link"></i> Kaart Koppelen
            </b-button>
          </b-card>
        </div>
        <div class="col-2"></div>
      </div>
    </div>
    <div class="col-1"></div>
    <vue-touch-keyboard
      id="keyboard"
      :options="options"
      v-if="visible"
      :layout="layout"
      :cancel="hide"
      :accept="accept"
      :input="input"
      ref="kaartKoppelKeyboard"
    />
  </div>
</template>

<script>
import userSearch from '~/components/content/userSearch.vue'
import cardSearch from '~/components/content/cardSearch.vue'
import tobackend from '~/plugins/2backend.js'

export default {
  middleware: ['authenticated', 'terminalSet', 'checkForGlobalData'],
  data() {
    return {
      description: '',
      visible: false,
      layout: 'normal',
      input: null,
      options: {
        useKbEvents: false,
        preventClickEvent: true
      },
      lastText: '',
      selectedType: null
    }
  },
  computed: {
    PossibleToLink: {
      get() {
        if (this.$store.state.currentCustomerForLink == null) {
          return true
        }
        if (this.$store.state.currentCardForLinkInUse) {
          return true
        }
        if (this.$store.state.currentCardForLink == null) {
          return true
        }
        return false
      },
      set() {
        //
      }
    },
    typeOptions: {
      get() {
        var returnRay = [{ value: null, text: 'Kies een kaartType' }]
        if (this.$store.state.cardLeasingTypeOptions) {
          this.$store.state.cardLeasingTypeOptions.forEach((element) => {
            returnRay.push({
              value: element,
              text: element.name
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
  components: {
    userSearch,
    cardSearch
  },
  methods: {
    LinkCard: function() {
      tobackend
        .linkCard(this.$store, this.description, this.selectedType)
        .then(() => {
          this.$store.commit('setCurrentCardForLinkInUse', false)
          this.$store.commit('setCurrentCardForLinkUnkown', false)
          this.$store.commit('setCurrentCardForLink', null)
          this.$store.commit('setCurrentCustomerForLink', null)
          this.$bvToast.toast('Kaart succesvol gekoppeld', {
            title: 'KaartKoppeling',
            autoHideDelay: 5000,
            appendToast: false
          })
        })
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
  }
}
</script>

<style></style>
