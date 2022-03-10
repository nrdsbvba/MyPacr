<template>
  <!-- Logout Modal-->
  <b-modal
    id="logoutModal"
    ref="my-modal"
    role="document"
    title="Afmelden?"
    hide-footer
  >
    <div class="d-block">
      Selecteer "Afmelden" indien u wil afmelden.
    </div>
    <b-button class="mt-3" variant="outline-danger" block @click="hideModal">
      Annuleren
    </b-button>
    <b-button class="mt-2" variant="outline-primary" block @click="doLogOut">
      Afmelden
    </b-button>
  </b-modal>
  <!-- </b-modal> -->
</template>
<script>
import tobackend from '~/plugins/2backend.js'

export default {
  name: 'mainModals',
  methods: {
    doLogOut() {
      // Code will also be required to invalidate the JWT Cookie on external API
      tobackend.logOut(this.$store)
      this.$bvModal.hide('logoutModal')
      this.$router.push('/login')
    },
    hideModal() {
      this.$refs['my-modal'].hide()
    }
  }
}
</script>
