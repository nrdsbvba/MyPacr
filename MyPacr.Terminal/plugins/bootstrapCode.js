import Vue from 'vue'

const ignoredMessage =
  'The .native modifier for v-on is only valid on components but it was used on <a>.'

Vue.config.warnHandler = (message, vm, componentTrace) => {
  if (message !== ignoredMessage) {
    console.error(message + componentTrace)
  }
}
