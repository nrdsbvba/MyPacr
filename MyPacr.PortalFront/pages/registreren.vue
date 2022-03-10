<template>
  <div class="justify-content-center">
    <div class="card o-hidden border-0 shadow-lg my-5">
      <div class="card-body p-3">
        <b-row align-h="center">
          <b-col cols="auto">
            <h2>Nieuwe account</h2>
          </b-col>
        </b-row>
        <b-row align-h="center">
          <b-col sm="10" md="8" lg="6">
            <b-form class="mt-3">
              <!-- firstname address input -->
              <b-row>
                <b-col sm="12" md="6">
                  <b-form-group
                    id="input-group-first_name"
                    label="Voornaam:"
                    label-for="input-first_name"
                  >
                    <b-form-input
                      id="input-first_name"
                      v-model.trim="$v.form.first_name.$model"
                      type="text"
                      required
                      placeholder="Vul hier u voornaam in"
                      :class="{ 'invalid-input': $v.form.first_name.$error }"
                    ></b-form-input>
                  </b-form-group>
                  <div
                    class="invalid-feedback d-block"
                    v-if="
                      !$v.form.first_name.required &&
                        $v.form.first_name.$error &&
                        $v.form.first_name.$dirty
                    "
                  >
                    Dit is een verplicht veld.
                  </div>
                </b-col>
                <b-col sm="12" md="6">
                  <!-- Lastname address input -->
                  <b-form-group
                    id="input-group-last_name"
                    label="Achternaam:"
                    label-for="input-last_name"
                  >
                    <b-form-input
                      id="input-last_name"
                      v-model.trim="$v.form.last_name.$model"
                      type="text"
                      required
                      placeholder="Vul hier u achternaam in"
                      :class="{ 'invalid-input': $v.form.last_name.$error }"
                    ></b-form-input>
                  </b-form-group>
                  <div
                    class="invalid-feedback d-block"
                    v-if="
                      !$v.form.last_name.required &&
                        $v.form.last_name.$error &&
                        $v.form.last_name.$dirty
                    "
                  >
                    Dit is een verplicht veld.
                  </div>
                </b-col>
              </b-row>

              <b-row>
                <b-col sm="12">
                  <!-- Email address input -->
                  <b-form-group
                    id="input-group-email"
                    label="Email adres:"
                    label-for="input-email"
                  >
                    <b-form-input
                      id="input-email"
                      v-model.trim="$v.form.email.$model"
                      type="email"
                      required
                      placeholder="Vul hier u email adres in"
                      :class="{ 'invalid-input': emailFormGroupInvalid }"
                    ></b-form-input>
                  </b-form-group>
                  <div
                    class="invalid-feedback d-block"
                    v-if="
                      !$v.form.email.required &&
                        $v.form.email.$error &&
                        $v.form.email.$dirty
                    "
                  >
                    Dit is een verplicht veld.
                  </div>
                  <div
                    class="invalid-feedback d-block"
                    v-if="
                      !$v.form.email.email &&
                        $v.form.email.$error &&
                        $v.form.email.$dirty
                    "
                  >
                    Gebruik een geldig email adres om in te registreren.
                  </div>
                </b-col>
              </b-row>
              <b-row>
                <b-col sm="12" md="5">
                  <!-- Password input -->
                  <b-form-group
                    id="input-group-password"
                    label="Wachtwoord:"
                    label-for="input-password"
                  >
                    <b-form-input
                      id="input-password"
                      v-model.trim="$v.form.password.$model"
                      :type="passwordFieldType"
                      required
                      placeholder="Vul hier u wachtwoord in"
                      :class="{ 'invalid-input': passwordFormGroupInvalid }"
                    ></b-form-input>
                  </b-form-group>
                  <div
                    class="invalid-feedback d-block"
                    v-if="
                      !$v.form.password.required &&
                        $v.form.password.$error &&
                        $v.form.password.$dirty
                    "
                  >
                    Dit is een verplicht veld.
                  </div>
                </b-col>
                <b-col sm="12" md="5">
                  <!-- Password repeat input -->
                  <b-form-group
                    id="input-group-passwordrepeat"
                    label="Wachtwoord:"
                    label-for="input-passwordrepeat"
                  >
                    <b-form-input
                      id="input-passwordrepeat"
                      v-model.trim="$v.form.passwordrepeat.$model"
                      :type="passwordFieldType"
                      required
                      placeholder="Herhaal u wachtwoord"
                      :class="{
                        'invalid-input': passwordrepeatFormGroupInvalid
                      }"
                    ></b-form-input>
                  </b-form-group>
                  <div
                    class="invalid-feedback d-block"
                    v-if="
                      !$v.form.passwordrepeat.required &&
                        $v.form.passwordrepeat.$error &&
                        $v.form.passwordrepeat.$dirty
                    "
                  >
                    Dit is een verplicht veld.
                  </div>
                  <div
                    class="invalid-feedback d-block"
                    v-if="!doPasswordsMatch && $v.form.passwordrepeat.$dirty"
                  >
                    Wachtwoorden moeten identiek zijn.
                  </div>
                </b-col>
                <b-col sm="12" md="2">
                  <label class="d-block">&nbsp;</label>
                  <b-button @click="togglePasswordVisibility()">
                    <i class="fal fa-eye"></i>
                  </b-button>
                </b-col>
              </b-row>
            </b-form>
          </b-col>
        </b-row>
        <b-row align-h="center" class="mt-3">
          <b-col cols="auto">
            <nuxt-link class="nav-link" to="/login"
              >Ik heb al een account.</nuxt-link
            >
          </b-col>
        </b-row>
        <b-row align-h="center" class="mt-3">
          <b-col cols="auto">
            <b-button variant="primary" @click="onRegister()"
              >Registreren</b-button
            >
          </b-col>
        </b-row>
        <b-row align-h="center" class="mt-3">
          <b-col cols="auto">
            <b-alert variant="danger" :show="registerError.length > 0">{{
              registerError
            }}</b-alert>
          </b-col>
        </b-row>
      </div>
    </div>
  </div>
</template>

<script>
import { required, email } from "vuelidate/lib/validators";
import tobackend from "~/plugins/2backend.js";

export default {
  middleware: "notauthenticated",
  layout: "clean",
  data() {
    return {
      form: {
        first_name: "",
        last_name: "",
        email: "",
        password: "",
        passwordrepeat: ""
      },
      passwordVisible: false,
      registerError: ""
    };
  },
  validations: {
    form: {
      first_name: {
        required
      },
      last_name: {
        required
      },
      email: {
        required,
        email
      },
      password: {
        required
      },
      passwordrepeat: {
        required
      }
    }
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
        // Does not do anything. Why?
        return "far fa-eye-slash";
      } else {
        return "far fa-eye";
      }
    },
    emailFormGroupInvalid() {
      return this.checkFieldError(this.$v.form.email);
    },
    passwordFormGroupInvalid() {
      return this.checkFieldError(this.$v.form.password);
    },
    doPasswordsMatch() {
      return this.form.password === this.form.passwordrepeat;
    },
    passwordrepeatFormGroupInvalid() {
      if (!this.$v.form.passwordrepeat.$dirty) {
        return false;
      }
      const check = this.checkFieldError(this.$v.form.passwordrepeat);

      if (check === false) {
        if (this.doPasswordsMatch === false) {
          return true;
        }
        return check;
      }

      return check;
    }
  },
  methods: {
    checkFieldError(field) {
      if (field.$dirty === true) {
        return field.$error;
      }

      return false;
    },
    togglePasswordVisibility: function() {
      this.passwordVisible = !this.passwordVisible;
    },
    onRegister: function() {
      this.$v.$touch();
      if (this.$v.$invalid) {
        return;
      } else {
        tobackend
          .registerOwn(this.$store, this.form)
          .then(resp => {
            this.$store.commit("setLoginObject", resp);
            this.$router.push("/");
          })
          .catch(err => {
            if (err.response.status === 500) {
              this.registerError = "U account kon niet worden aangemaakt.";
            }
          });
      }
    },
    togglePasswordVisibility: function() {
      this.passwordVisible = !this.passwordVisible;
    }
  }
};
</script>
