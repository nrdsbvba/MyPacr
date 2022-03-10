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
                  Even geduld, wij melden u aan
                </h1>
              </div>
              <div class="text-center" v-if="loggingIn">
                <b-spinner
                  variant="primary"
                  label="Loading..."
                  class="m-5"
                ></b-spinner>
              </div>
            </div>
          </div>
          <div class="col-lg-3"></div>
        </div>
      </div>
    </div>
    <b-modal
      id="loginModal"
      title="LoginResultaat"
      no-close-on-backdrop
      ok-disabled
      cancel-disabled
    >
      <div>
        <p>{{ errorMessage }}</p>
        <nuxt-link class="btn btn-primary" to="/login">
          <span>terug naar login</span>
        </nuxt-link>
      </div>
    </b-modal>
  </div>
</template>

<script>
const axios = require("axios");
var qs = require("qs");
axios.defaults.headers.post["Content-Type"] =
  "application/x-www-form-urlencoded";

export default {
  data() {
    return {
      loggingIn: true,
      errorMessage: ""
    };
  },
  layout: "clean",
  middleware: function(context) {
    axios
      .post(
        process.env.apiUrl + "/user/Smartschoolauthenticate",
        {
          code: context.query.code
        }
      )
      .then(resp => {
        if (resp.data.error) {
          context.store.commit("setLoginObject", null);
          context.store.commit("setLoginError", true);
          context.store.commit("setLoginMessage", resp.data.data);
          return context.redirect("/");
        } else {
          context.store.commit("setLoginObject", resp.data);
          return context.redirect("/");
        }
      })
      .catch(err => {
        context.store.commit("setLoginObject", null);
        context.store.commit("setLoginError", true);
        context.store.commit(
          "setLoginMessage",
          "Kan niet inloggen, er is iets fout gegaan."
        );
        console.log(err);
        return context.redirect("/");
      });
  }
};
</script>

<style></style>
