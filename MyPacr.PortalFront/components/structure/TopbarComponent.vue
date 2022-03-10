<template>
  <nav
    class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow"
  >
    <h4></h4>
    <!-- Sidebar Toggle (Topbar) -->
    <button
      id="sidebarToggleTop"
      class="btn btn-link d-md-none rounded-circle mr-3"
      @click="toggledSideBar"
    >
      <i class="fa fa-bars"></i>
    </button>

    <!-- Topbar Navbar -->
    <ul class="navbar-nav ml-auto">
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
          <i class="fas fa-user"></i>
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
import tobackend from "~/plugins/2backend.js";

export default {
  name: "topbarComponent",
  data() {
    return {};
  },
  computed: {
    firstName() {
      if (this.$store.state.loginObject) {
        return this.$store.state.loginObject.FullAccount.first_name;
      }
      return "";
    },
    lastName() {
      if (this.$store.state.loginObject) {
        return this.$store.state.loginObject.FullAccount.last_name;
      }
      return "";
    }
  },
  beforeMount: function() {
    if (tobackend.isLoggedIn(this.$store)) {
    }
  },
  methods: {
    toggledSideBar: function() {
      var element = document.getElementById("accordionSidebar");
      element.classList.toggle("toggled");
      this.$store.commit(
        "setMobileNavShowing",
        !element.classList.contains("toggled")
      );
    }
  }
};
</script>
