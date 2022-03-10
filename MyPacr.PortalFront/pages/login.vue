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
                <p>
                  Om deze toepassing te gebruiken dient u in te loggen. Klik op
                  één van de knoppen hieronder.
                </p>
              </div>
              <div class="text-center" v-if="loggingIn">
                <b-spinner
                  variant="primary"
                  label="Loading..."
                  class="m-5"
                ></b-spinner>
              </div>
              <template v-if="showOwnLogin">
                <b-button
                  @click="onLogin()"
                  variant="primary"
                  class="btn-user btn-block"
                >
                  Login
                </b-button>
              </template>
              <template v-if="showSmartschoolLogin">
                <a
                  :href="createSmartSchoolUrl()"
                  class="btn btn-warning btn-block"
                >
                  Login Met Smartschool
                </a>
              </template>
            </div>
          </div>
          <div class="col-lg-3"></div>
        </div>
      </div>
    </div>
    <b-modal id="loginModal" title="LoginResultaat" cancel-disabled>
      <div>
        <p>{{ errorMessage }}</p>
      </div>
    </b-modal>
    <b-modal id="loginOwnModal" hide-footer hide-header>
      <login-own></login-own>
    </b-modal>
  </div>
</template>

<script>
import LoginOwn from "~/components/login/LoginOwn";
import tobackend from "~/plugins/2backend.js";

export default {
  middleware: "notauthenticated",
  layout: "clean",
  components: {
    LoginOwn
  },
  data() {
    //adding oauth client info in plain sight, set this to globalsetting later
    return {
      smartschoolurl: process.env.smartschoolUrl,
      callbackURL: process.env.portalFrontUrl + "/#/smartschoolauth",
      clientID: process.env.smartSchoolClientId,
      loggingIn: false,
      errorMessage: ""
    };
  },
  computed: {
    showOwnLogin() {
      return (
        this.$store.state.authProviderSettings &&
        this.$store.state.authProviderSettings.own.enabled
      );
    },
    showSmartschoolLogin() {
      return (
        this.$store.state.authProviderSettings &&
        this.$store.state.authProviderSettings.smartschool.enabled
      );
    }
  },
  methods: {
    createSmartSchoolUrl: function() {
      var url =
        this.smartschoolurl +
        "/OAuth?" +
        "client_id=" +
        this.clientID +
        "&" +
        "redirect_uri=" +
        encodeURIComponent(this.callbackURL) +
        "&" +
        "scope=userinfo fulluserinfo groupinfo";

      return url;
    },
    onLogin: function() {
      this.$bvModal.show("loginOwnModal");
    }
  },
  mounted: function() {
    if (this.$store.state.loginError) {
      this.errorMessage = this.$store.state.loginMessage;
      this.$bvModal.show("loginModal");
      this.store.commit("setLoginObject", null);
      this.store.commit("setLoginError", false);
      this.store.commit("setLoginMessage", "");
    }

    if (!this.$store.state.authProviderSettings) {
      tobackend
        .getAuthProviderSettings()
        .then(resp => {
          this.$store.commit("setAuthProviderSettings", resp);
        })
        .catch(err => {
          if (err.response.status === 500) {
            this.error = "Ophalen login opties mislukt.";
          }
        });
    }
  }
};
</script>

<style></style>
