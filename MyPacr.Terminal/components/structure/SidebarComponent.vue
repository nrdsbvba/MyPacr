<template>
  <ul
    id="accordionSidebar"
    class="navbar-nav bg-gradient-primary sidebar sidebar-dark toggled"
  >
    <!-- Sidebar - Brand -->
    <nuxt-link
      class="sidebar-brand d-flex align-items-center justify-content-center"
      :to="createUrl()"
    >
      <div class="sidebar-brand-icon rotate-n-15">
        <i class="fas fa-home" />
      </div>
      <div class="sidebar-brand-text mx-3">
        MyPacr.POS
      </div>
    </nuxt-link>

    <!-- Divider -->
    <hr class="sidebar-divider my-0" />

    <!-- Nav Item - Dashboard -->
    <li class="nav-item active" v-if="kassaFunction">
      <nuxt-link class="nav-link" to="/kassa">
        <i class="fas fa-fw fa-tachometer-alt" />
        <span>Kassa</span>
      </nuxt-link>
    </li>

    <li class="nav-item" v-if="aanwezighedenFunction">
      <nuxt-link class="nav-link" to="/aanwezigheden">
        <i class="fas fa-fw fa-user" />
        <span>Aanwezigheden</span>
      </nuxt-link>
    </li>

    <li class="nav-item" v-if="kaartKoppelingFunction">
      <nuxt-link class="nav-link" to="/kaartkoppelen">
        <i class="fas fa-fw fa-credit-card" />
        <span>Kaart Koppelen</span>
      </nuxt-link>
    </li>

    <li class="nav-item" v-if="registratieFunction">
      <nuxt-link class="nav-link" to="/registratie">
        <i class="fas fa-clipboard-list-check"></i>
        <span>RegistratieSysteem</span>
      </nuxt-link>
    </li>

    <div class="text-center d-none d-md-inline">
      <button
        class="rounded-circle border-0"
        id="sidebarToggle"
        @click="toggledSideBar"
      ></button>
    </div>
  </ul>
</template>
<script>
export default {
  name: 'sidebarComponent',
  data() {
    return {}
  },
  computed: {
    terminalfunctions: {
      get() {
        return this.$store.state.currentTerminalInfo
          ? this.$store.state.currentTerminalInfo.terminalfunctions
          : []
      },
      set() {
        //
      }
    },
    kassaFunction: {
      get() {
        var kassaFunction = this.terminalfunctions.find((element) => {
          return element.terminalfunctions_id.functionname == 'Kassa'
        })
        return kassaFunction != null
      },
      set() {}
    },

    aanwezighedenFunction: {
      get() {
        var aanwezighedenFunction = this.terminalfunctions.find((element) => {
          return (
            element.terminalfunctions_id.functionname ==
            'AanwezighedenRegistratie'
          )
        })
        return aanwezighedenFunction != null
      },
      set() {}
    },
    kaartKoppelingFunction: {
      get() {
        var kaartKoppelingFunction = this.terminalfunctions.find((element) => {
          return element.terminalfunctions_id.functionname == 'KaartKoppeling'
        })
        return kaartKoppelingFunction != null
      },
      set() {}
    },
    registratieFunction: {
      get() {
        var registratieFunction = this.terminalfunctions.find((element) => {
          return (
            element.terminalfunctions_id.functionname == 'RegistratieSysteem'
          )
        })
        return registratieFunction != null
      },
      set() {}
    }
  },
  methods: {
    toggledSideBar: function() {
      var element = document.getElementById('accordionSidebar')
      element.classList.toggle('toggled')
    },
    createUrl: function() {
      var kassaFunction = this.terminalfunctions.find((element) => {
        return element.terminalfunctions_id.functionname == 'Kassa'
      })
      if (kassaFunction != null) {
        return '/kassa'
      }
      var aanwezighedenFunction = this.terminalfunctions.find((element) => {
        return (
          element.terminalfunctions_id.functionname ==
          'AanwezighedenRegistratie'
        )
      })
      if (aanwezighedenFunction != null) {
        return '/aanwezigheden'
      }
      var kaartKoppelingFunction = this.terminalfunctions.find((element) => {
        return element.terminalfunctions_id.functionname == 'KaartKoppeling'
      })
      if (kaartKoppelingFunction != null) {
        return '/kaartkoppeling'
      }
      return '/'
    }
  }
}
</script>
<style scoped>
.salesmodetogglediv {
  bottom: 50px;
  min-height: 100px;
  width: 100px;
  background-color: brown;
  color: aliceblue;
}
</style>
