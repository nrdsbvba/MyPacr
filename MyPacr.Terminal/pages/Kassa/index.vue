<template>
  <div class="d-sm-flex justify-content-between col-12">
    <div class="col-8">
      <articleList />
    </div>
    <div class="col-4">
      <checkout />
      <hr />
      <currentCustomer />
    </div>
  </div>
</template>

<script>
import articleList from '~/components/content/articleList.vue'
import checkout from '~/components/content/checkout.vue'
import currentCustomer from '~/components/content/currentCustomer.vue'

export default {
  middleware: ['authenticated', 'terminalSet', 'checkForGlobalData'],
  components: {
    articleList,
    checkout,
    currentCustomer
  }
}
</script>

<style>
.custom-checkbox.small label {
  line-height: 1.5rem;
}

.form-control-rounded {
  font-size: 0.8rem !important;
  border-top-left-radius: 10rem !important;
  border-bottom-left-radius: 10rem !important;
  padding: 1.5rem 1rem !important;
}

.btn-rounded {
  font-size: 1rem;
  border-top-right-radius: 10rem !important;
  border-bottom-right-radius: 10rem !important;
  padding: 0.75rem 1rem !important;
}
.btn-rounded-left {
  font-size: 0.9rem !important ;
  border-top-left-radius: 10rem !important;
  border-bottom-left-radius: 10rem !important;
  padding: 0.75rem 1rem !important;
}
.btn-rounded-right {
  font-size: 0.9rem !important;
  border-top-right-radius: 10rem !important;
  border-bottom-right-radius: 10rem !important;
  padding: 0.75rem 1rem !important;
}
.btn-center-grp {
  font-size: 0.9rem !important;
  padding: 0.75rem 1rem !important;
}
</style>
