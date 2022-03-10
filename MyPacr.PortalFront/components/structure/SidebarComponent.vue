<template>
  <ul
    id="accordionSidebar"
    class="navbar-nav bg-gradient-primary sidebar sidebar-dark toggled"
  >
    <!-- Sidebar - Brand -->
    <nuxt-link
      class="sidebar-brand d-flex align-items-center justify-content-center"
      to="/"
      @click.native="handleSidebar"
    >
      <div class="sidebar-brand-icon rotate-n-15">
        <i class="fas fa-home" />
      </div>
      <div class="sidebar-brand-text mx-3">
        MyPacr.Portal
      </div>
    </nuxt-link>

    <!-- Divider -->
    <hr class="sidebar-divider my-0" />

    <!-- Nav Item - Dashboard -->
    <li class="nav-item active">
      <nuxt-link class="nav-link" to="/herladen" @click.native="handleSidebar">
        <i class="fas fa-credit-card"></i>
        <span>Kaarten</span>
      </nuxt-link>
    </li>

    <li class="nav-item">
      <nuxt-link
        class="nav-link"
        to="/aanwezigheden"
        @click.native="handleSidebar"
      >
        <i class="fas fa-user-check"></i>
        <span>Aanwezigheid</span>
      </nuxt-link>
    </li>

    <li class="nav-item">
      <nuxt-link
        class="nav-link"
        to="/transacties"
        @click.native="handleSidebar"
      >
        <i class="fas fa-clipboard-list"></i>
        <span>Transacties</span>
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
  name: "sidebarComponent",
  data() {
    return {};
  },
  methods: {
    toggledSideBar: function() {
      var element = document.getElementById("accordionSidebar");
      element.classList.toggle("toggled");
    },
    handleSidebar: function() {
      if (this.$store.state.mobileNavShowing) {
        var element = document.getElementById("accordionSidebar");
        element.classList.toggle("toggled");
        this.$store.commit("setMobileNavShowing", false);
      }
    }
  }
};
</script>
