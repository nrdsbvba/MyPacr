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
                  Login
                </h1>
              </div>
              <form class="user">
                <div class="form-group">
                  <input
                    type="email"
                    v-model="email"
                    class="form-control form-control-user"
                    id="exampleInputEmail"
                    aria-describedby="emailHelp"
                    placeholder="Enter Email Address..."
                    @focus="show"
                    @blur="hide"
                    data-layout="normal"
                  />
                </div>
                <div class="form-group">
                  <input
                    type="password"
                    v-model="password"
                    class="form-control form-control-user"
                    id="exampleInputPassword"
                    placeholder="Password"
                    @focus="show"
                    @blur="hide"
                    data-layout="normal"
                  />
                </div>
                <div class="text-center" v-if="loggingIn">
                  <b-spinner
                    variant="primary"
                    label="Loading..."
                    class="m-5"
                  ></b-spinner>
                </div>
                <a
                  href="#"
                  @click="postLogin"
                  class="btn btn-primary btn-user btn-block"
                >
                  Login
                </a>
              </form>
            </div>
          </div>
          <div class="col-lg-3"></div>
        </div>
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
  </div>
</template>

<script>
import tobackend from '~/plugins/2backend.js'
import VueTouchKeyboard from 'vue-touch-keyboard'
import 'vue-touch-keyboard/dist/vue-touch-keyboard.css' // load default style
import Vue from 'vue'
Vue.use(VueTouchKeyboard)

export default {
  middleware: 'notAuthenticated',
  layout: 'clean',
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
      email: '',
      password: '',
      loggingIn: false
    }
  },
  methods: {
    postLogin() {
      this.loggingIn = true
      tobackend
        .login(this.$store, this.email, this.password)
        .then((result) => {
          console.log(result)
          this.$bvToast.toast('succesfully Logged In. Redirecting...', {
            title: 'LoginResponse',
            variant: 'success',
            autoHideDelay: 5000,
            appendToast: false,
            toaster: 'b-toaster-top-center'
          })
          setTimeout(() => {
            this.$router.push('/kassa')
          }, 10)
        })
        .catch((result) => {
          console.log(result)
        })
        .finally(() => {
          this.loggingIn = false
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
