<template>
  <div>
    <b-card
      border-variant="primary"
      header="Artikels"
      header-bg-variant="primary"
      header-text-variant="white"
      align="center"
    >
      <div class="col-12 row">
        <div class="col-4" align="left">
          <b-button-group side="sm">
            <b-button
              variant="outline-primary"
              class="btn-rounded-left"
              @click="setSort('PriceDown')"
            >
              <i class="fas fa-sort-numeric-down"></i>
            </b-button>
            <b-button variant="outline-primary" @click="setSort('PriceUp')">
              <i class="fas fa-sort-numeric-up"></i>
            </b-button>
            <b-button variant="outline-primary" @click="setSort('NameDown')">
              <i class="fas fa-sort-alpha-down"></i>
            </b-button>
            <b-button variant="outline-primary" @click="setSort('NameUp')">
              <i class="fas fa-sort-alpha-up"></i>
            </b-button>
            <b-button
              variant="outline-primary"
              class="btn-rounded-right"
              @click="setSort('')"
            >
              <i class="fas fa-undo"></i>
            </b-button>
          </b-button-group>
        </div>
        <div class="col-8" align="right">
          <button
            pill
            v-for="(btn, idx) in currentCategoryButtons"
            :key="idx"
            v-on:click="changeState(btn)"
            :class="getClass(btn.state)"
            class="m-1 btn btn-rounded-right btn-rounded-left"
          >
            {{ btn.caption }}
          </button>
        </div>
      </div>
      <hr />
      <b-card-group>
        <b-card
          v-for="article in filterArticles"
          :key="article.id"
          :img-src="createArticleThumbnail(article)"
          img-alt="Image"
          img-top
          tag="article"
          style="max-width:14rem;min-width:10rem;"
          class="m-1"
        >
          <b-card-title style="font-size:1rem;">
            {{ article.name }} <br />
            {{ getCurrentPrice(article) }}
          </b-card-title>
          <div slot="footer">
            <b-input-group size="lg">
              <b-form-input
                type="number"
                :ref="'tempQuantity-' + article.id"
                class="form-control-rounded"
                @focus="show"
                data-layout="numeric"
                value="1"
                readonly="readonly"
                style="background: white"
              ></b-form-input>
              <b-input-group-append>
                <b-button
                  variant="primary"
                  @click="AddToCart(article)"
                  class="btn-rounded-right"
                >
                  <i class="fas fa-cart-plus fa-lg"
                /></b-button>
              </b-input-group-append>
            </b-input-group>
          </div>
        </b-card>
      </b-card-group>
    </b-card>
    <vue-touch-keyboard
      id="keyboard"
      :options="options"
      v-if="visible"
      :layout="layout"
      :cancel="hide"
      :accept="accept"
      :input="input"
    />
  </div>
</template>

<script>
import tobackend from '~/plugins/2backend.js'
import VueTouchKeyboard from 'vue-touch-keyboard'
import 'vue-touch-keyboard/dist/vue-touch-keyboard.css' // load default style
import Vue from 'vue'
Vue.use(VueTouchKeyboard)

export default {
  name: 'articleList',
  data() {
    return {
      visible: false,
      layout: 'numeric',
      input: null,
      options: {
        useKbEvents: false,
        preventClickEvent: true
      },
      lastText: '',
      currentCategoryButtons: [],
      activeFilter: {
        categories: [],
        sorting: null // PriceDown | PriceUp | NameDown | NameUp
      }
    }
  },
  computed: {
    articles: {
      get() {
        return this.$store.state.articleList
      },
      set() {
        //dont do anything, this should be read only from store
      }
    },
    filterArticles: {
      get() {
        if (!this.$store.state.articleList) {
          return []
        }
        var filtered = this.articles.filter((item) => {
          var thePriceA = item.prices.find((element) => {
            return element.pricelevel == this.activePriceLevel
              ? this.activePriceLevel.id
              : null
          })
          if (thePriceA != null) {
            return thePriceA != 0
          } else {
            return true
          }
        })

        filtered = filtered.filter((item) => {
          return item.categories.some((inner) => {
            return this.activeFilter.categories.some((e) => {
              return e == inner.articlecategories_id.name
            })
          })
        })

        function normalSort(a, b) {
          if (a.order == null) return 1
          if (b.order == null) return -1
          if (a.order > b.order) return 1
          if (a.order < b.order) return -1
          return 0
        }

        var outscope = this
        function PriceDownSort(a, b) {
          if (outscope.getCurrentPrice(a) < outscope.getCurrentPrice(b))
            return 1
          if (outscope.getCurrentPrice(a) > outscope.getCurrentPrice(b))
            return -1
          return 0
        }

        function PriceUpSort(a, b) {
          if (outscope.getCurrentPrice(a) > outscope.getCurrentPrice(b))
            return 1
          if (outscope.getCurrentPrice(a) < outscope.getCurrentPrice(b))
            return -1
          return 0
        }

        function NameDownSort(a, b) {
          if (a.name < b.name) return 1
          if (a.name > b.name) return -1
          return 0
        }

        function NameUpSort(a, b) {
          if (a.name > b.name) return 1
          if (a.name < b.name) return -1
          return 0
        }

        switch (this.activeFilter.sorting) {
          case 'PriceDown':
            filtered.sort(PriceDownSort)
            break
          case 'PriceUp':
            filtered.sort(PriceUpSort)
            break
          case 'NameDown':
            filtered.sort(NameDownSort)
            break
          case 'NameUp':
            filtered.sort(NameUpSort)
            break
          default:
            filtered.sort(normalSort)
            break
        }

        return filtered
      },
      set() {}
    },
    activePriceLevel: {
      get() {
        return this.$store.state.activePriceLevel
      },
      set() {
        //
      }
    }
  },
  beforeMount: function() {
    //check if articles are already loaded. If not, get it from server
    if (tobackend.isLoggedIn(this.$store)) {
      if (!this.$store.state.articleList) {
        tobackend.getArticles(this.$store).then()
      }
      this.handleCategories(this.articles)
    }
  },
  methods: {
    createArticleThumbnail: function(article) {
      var filename = ''
      if (article.picture) {
        filename = article.picture.filename_disk
      }
      if (filename != '') {
        return tobackend.getThumbnail(filename, 300, 150, 'crop')
      } else {
        return ''
      }
    },
    AddToCart: function(article) {
      var number = this.$refs['tempQuantity-' + article.id][0].$el.value
      this.$store.commit('addToCheckOutCart', { article, number })
      this.$refs['tempQuantity-' + article.id][0].$el.value = 1
      this.hide()
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
    getClass(state) {
      return state == true ? 'btn-outline-primary' : 'btn-outline-secondary'
    },
    setSort(order) {
      if (order == '') {
        this.activeFilter.sorting = null
        this.currentCategoryButtons.forEach((element) => {
          element.state = true
          if (
            !this.activeFilter.categories.some((ee) => {
              return ee == element.caption
            })
          ) {
            this.activeFilter.categories.push(element.caption)
          }
        })
      } else {
        this.activeFilter.sorting = order
      }
    },
    getCurrentPrice(article) {
      if (this.activePriceLevel) {
        //find the price with that pricelevel
        var thePriceA = article.prices.find((element) => {
          return element.pricelevel == this.activePriceLevel.id
        })

        //if none, take fallback price
        if (!thePriceA) {
          thePriceA = article.fallback_price
        } else {
          thePriceA = thePriceA.amount
        }
        return ('€ ' + parseFloat(thePriceA).toFixed(2)).replace('.', ',')
      } else {
        //check default pricelevel in settings
        var thePriceB = article.prices.find((element) => {
          return (
            element.pricelevel ==
            this.$store.state.globalSettings.default_pricelevel.id
          )
        })

        //if default privelevel not in pricesarray  get fallback price
        if (!thePriceB) {
          thePriceB = article.fallback_price
        } else {
          thePriceB = thePriceB.amount
        }
        return ('€ ' + parseFloat(thePriceB).toFixed(2)).replace('.', ',')
      }
    },
    changeState(btn) {
      if (btn.state) {
        btn.state = false
        this.activeFilter.categories = this.activeFilter.categories.filter(
          (element) => {
            return element != btn.caption
          }
        )
      } else {
        btn.state = true
        this.activeFilter.categories.push(btn.caption)
      }
    },
    handleCategories(newValue) {
      this.currentCategoryButtons = []
      if (newValue && newValue.length > 0) {
        newValue.forEach((article) => {
          if (article.categories && article.categories.length > 0) {
            article.categories.forEach((cat) => {
              if (
                !this.currentCategoryButtons.some((btn) => {
                  return btn.caption == cat.articlecategories_id.name
                })
              ) {
                this.currentCategoryButtons.push({
                  caption: cat.articlecategories_id.name,
                  state: true
                })
                this.activeFilter.categories.push(cat.articlecategories_id.name)
              }
            })
          }
        })
      }
    }
  },
  watch: {
    articles(newValue) {
      this.handleCategories(newValue)
    }
  }
}
</script>

<style>
#keyboard {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;

  z-index: 1000;
  width: 100%;
  max-width: 1000px;
  margin: 0 auto;

  padding: 1em;

  background-color: #eee;
  box-shadow: 0px -3px 10px rgba(black, 0.3);

  border-radius: 10px;
}
.key.next.control {
  visibility: hidden;
  display: none;
}
</style>
