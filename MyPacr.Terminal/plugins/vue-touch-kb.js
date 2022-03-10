import Vue from 'vue'
import VueTouchKeyboard from 'vue-touch-keyboard'
import 'vue-touch-keyboard/dist/vue-touch-keyboard.css' // load default style

Vue.use(VueTouchKeyboard)

export default {
  data: {
    visible: false,
    layout: 'normal',
    input: null,
    options: {
      useKbEvents: false,
      preventClickEvent: false
    }
  },

  methods: {
    accept(text) {
      alert('Input text: ' + text)
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
