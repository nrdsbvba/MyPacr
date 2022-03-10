<template>
  <div>
    <!-- Page Wrapper -->
    <div id="wrapper">
      <!-- Sidebar -->
      <sidebarComponent></sidebarComponent>
      <!-- End of Sidebar -->

      <!-- Content Wrapper -->
      <div id="content-wrapper" class="d-flex flex-column">
        <!-- Main Content -->
        <div id="content">
          <!-- Topbar -->
          <topbarComponent></topbarComponent>
          <!-- End of Topbar -->

          <!-- Begin Page Content -->
          <div class="container-fluid">
            <nuxt />
          </div>
          <!-- /.container-fluid -->
        </div>
        <!-- End of Main Content -->
        <footerComponent />
      </div>
      <!-- End of Content Wrapper -->
    </div>
    <!-- End of Page Wrapper -->
    <mainModals></mainModals>
  </div>
</template>

<script>
import footerComponent from '~/components/structure/FooterComponent.vue'
import mainModals from '~/components/structure/MainModals.vue'
import sidebarComponent from '~/components/structure/SidebarComponent.vue'
import topbarComponent from '~/components/structure/TopbarComponent.vue'

export default {
  components: {
    footerComponent,
    mainModals,
    sidebarComponent,
    topbarComponent
  }
}
</script>
