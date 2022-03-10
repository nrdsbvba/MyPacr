<template>
  <nav
    class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top  shadow"
  >
    <h4>{{ terminalName }}</h4>
    <span class="vr-line">&nbsp;</span>
    <h4>
      <b-form-checkbox
        switch
        size="lg"
        :class="{
          'text-danger': currentModeVariant,
          'text-primary': !currentModeVariant
        }"
        v-model="salesMode"
        >{{ currentMode }}</b-form-checkbox
      >
    </h4>
    <h4 class="navbar-clock ml-auto">
      {{ clock }}
    </h4>
    <!-- Topbar Navbar -->
    <ul class="navbar-nav ">
      <!-- Nav Item - User Information -->
      <li class="nav-item dropdown no-arrow">
        <a
          id="userDropdown"
          class="nav-link dropdown-toggle"
          href="#"
          role="button"
          data-toggle="dropdown"
          aria-haspopup="true"
          aria-expanded="false"
        >
          <span class="mr-2 d-none d-lg-inline text-gray-600 small"
            >{{ firstName }} {{ lastName }}</span
          >
          <img :src="avatarLink" class="img-profile rounded-circle" />
        </a>
        <!-- Dropdown - User Information -->
        <div
          class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
          aria-labelledby="userDropdown"
        >
          <b-link class="dropdown-item" v-b-modal.logoutModal>
            <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
            Logout
          </b-link>
        </div>
      </li>
    </ul>
  </nav>
</template>
<script>
import tobackend from '~/plugins/2backend.js'

export default {
  name: 'topbarComponent',
  data() {
    return {
      avatarLink: '',
      firstName: '',
      lastName: '',
      clock: '',
      salesMode: false
    }
  },
  computed: {
    terminalName: {
      get() {
        return this.$store.state.currentTerminalInfo
          ? this.$store.state.currentTerminalInfo.code
          : ''
      },
      set() {
        //
      }
    },
    currentMode: {
      get() {
        return this.$store.state.salesMode ? 'Sales Modus' : 'School Modus'
      },
      set() {
        //
      }
    },
    currentModeVariant: {
      get() {
        return this.$store.state.salesMode
      },
      set() {
        //
      }
    }
  },
  beforeMount: function() {
    //check if data for userprofile exists. if not get it from server
    if (tobackend.isLoggedIn(this.$store)) {
      if (!this.$store.state.loggedInInfo) {
        tobackend.getMe(this.$store).then(this.setProfileButton)
      } else {
        this.setProfileButton()
      }
    }
    this.salesMode = this.$store.state.salesMode
    setInterval(this.updateClock, 1000)
    this.updateClock()
  },
  methods: {
    setProfileButton: function() {
      var fileName = this.$store.state.loggedInInfo.avatar
        ? this.$store.state.loggedInInfo.avatar.filename_download
        : ''

      this.avatarLink = tobackend.getThumbnail(fileName, 60, 60)
      this.firstName = this.$store.state.loggedInInfo.first_name
      this.lastName = this.$store.state.loggedInInfo.last_name
    },
    setTerminalName: function() {
      this.terminalName = this.$store.state.currentTerminalInfo.code
    },
    zeroPadding: function(num, digit) {
      var zero = ''
      for (var i = 0; i < digit; i++) {
        zero += '0'
      }
      return (zero + num).slice(-digit)
    },
    updateClock: function() {
      var cd = new Date()
      this.clock =
        this.zeroPadding(cd.getHours(), 2) +
        ':' +
        this.zeroPadding(cd.getMinutes(), 2) +
        ':' +
        this.zeroPadding(cd.getSeconds(), 2)
    }
  },
  watch: {
    salesMode: function(newValue) {
      this.$store.commit('setSalesMode', newValue)
    }
  }
}
</script>
<style scoped>
.vr-line {
  height: 40px;
  margin: 10px;
  border-left: 1px solid #4e73df;
  border-right: 1px solid #4e73df;
  text-align: center;
}
.navbar-clock {
  vertical-align: bottom;
  float: right;
}
</style>
