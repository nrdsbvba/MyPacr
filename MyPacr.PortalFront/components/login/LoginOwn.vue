<template>
  <div>
    <b-row align-h="center">
      <b-col cols="auto">
        <h2>Login</h2>
      </b-col>
    </b-row>
    <b-row align-h="center">
      <b-col cols="auto">
        <b-form class="mt-3">
          <b-input-group
            :class="{ 'invalid-input-group': $v.form.email.$error }"
          >
            <template v-slot:prepend>
              <b-input-group-text>
                <i class="fal fa-at"></i
              ></b-input-group-text>
            </template>
            <b-input
              id="input-email"
              v-model.trim="$v.form.email.$model"
              type="email"
              required
              placeholder="Email"
            ></b-input>
          </b-input-group>
          <div
            class="invalid-feedback d-block"
            v-if="!$v.form.email.required && $v.form.email.$error"
          >
            Dit is een verplicht veld.
          </div>
          <div
            class="invalid-feedback d-block"
            v-if="!$v.form.email.email && $v.form.email.$error"
          >
            Gebruik een geldig email adres om in te loggen.
          </div>
          <b-input-group
            class="mt-3"
            :class="{ 'invalid-input-group': $v.form.password.$error }"
          >
            <template v-slot:prepend>
              <b-input-group-text>
                <i class="fal fa-key"></i
              ></b-input-group-text>
            </template>
            <b-input
              id="input-password"
              v-model.trim="$v.form.password.$model"
              :type="passwordFieldType"
              required
              placeholder="Wachtwoord"
            ></b-input>
            <b-input-group-append>
              <b-button @click="togglePasswordVisibility()">
                <i :class="passwordVisibilityClass"></i>
              </b-button>
            </b-input-group-append>
          </b-input-group>
          <div
            class="invalid-feedback d-block"
            v-if="!$v.form.password.required && $v.form.password.$error"
          >
            Dit is een verplicht veld.
          </div>
        </b-form>
      </b-col>
    </b-row>
    <b-row align-h="center" class="mt-3">
      <b-col cols="auto">
        <nuxt-link class="nav-link" to="/registreren"
          >Aanmelden/Registreren</nuxt-link
        >
      </b-col>
    </b-row>
    <b-row align-h="end" class="mt-3">
      <b-col cols="auto">
        <b-button variant="primary" @click="onLogin()">Login</b-button>
      </b-col>
    </b-row>
    <b-row align-h="center" class="mt-3">
      <b-col cols="auto">
        <b-alert variant="danger" :show="error.length > 0">{{ error }}</b-alert>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { required, email } from "vuelidate/lib/validators";
import tobackend from "~/plugins/2backend.js";

export default {
  middleware: "notauthenticated",
  name: "login-own",
  layout: "clean",
  data() {
    return {
      form: {
        email: "",
        password: "",
      },
      passwordVisible: false,
      error: "",
    };
  },
  validations: {
    form: {
      email: {
        required,
        email,
      },
      password: {
        required,
      },
    },
  },
  computed: {
    passwordFieldType() {
      if (this.passwordVisible === true) {
        return "text";
      }
      return "password";
    },
    passwordVisibilityClass() {
      if (this.passwordVisible === true) {
        // Does not do a thing. Why?
        return "far fa-eye-slash";
      } else {
        return "far fa-eye";
      }
    },
  },
  methods: {
    onLogin: function () {
      this.$v.$touch();
      if (this.$v.$invalid) {
        return;
      } else {
        tobackend
          .authenticateOwn(this.$store, this.form)
          .then((resp) => {
            this.$store.commit("setLoginObject", resp);
            this.$router.push("/");
          })
          .catch((err) => {
            if (err.response.status === 500) {
              this.error = "Login mislukt.";
            }
          });
      }
    },
    togglePasswordVisibility: function () {
      this.passwordVisible = !this.passwordVisible;
    },
  },
};
</script>
