<template>
  <div>
    <!-- Page Wrapper -->
    <div id="wrapper">
      <!-- Content Wrapper -->
      <div id="content-wrapper" class="d-flex flex-column">
        <!-- Main Content -->
        <div id="content">
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
  </div>
</template>
<script>
import footerComponent from '~/components/structure/FooterComponent'

export default {
  components: {
    footerComponent
  }
}
</script>
