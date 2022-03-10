export default {
  mode: 'spa',
  router: { mode: 'hash' },
  /*
   ** Headers of the page
   */
  head: {
    title: 'MyPacr.Portal',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      {
        hid: 'description',
        name: 'description',
        content: process.env.npm_package_description || ''
      }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      { rel: 'stylesheet', type: 'text/css', href: '' },
      {
        rel: 'stylesheet',
        type: 'text/css',
        href:
          'https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i'
      }
      // { rel: 'stylesheet', type: 'text/css', href: 'css/sb-admin-2.css' }
    ],
    script: [
      {
        src: 'vendor/fontawesome/js/all.min.js',
        body: true,
        type: 'text/javascript'
      },
      {
        src: 'vendor/jquery/jquery.min.js',
        body: true,
        type: 'text/javascript'
      },
      {
        src: 'vendor/bootstrap/js/bootstrap.bundle.min.js',
        body: true,
        type: 'text/javascript'
      },
      {
        src: 'vendor/jquery-easing/jquery.easing.min.js',
        body: true,
        type: 'text/javascript'
      },
      { src: 'js/sb-admin-2.js', body: true, type: 'text/javascript' },
      {
        src: 'vendor/chart.js/Chart.min.js',
        body: true,
        type: 'text/javascript'
      },
      {
        src: 'vendor/poly/number-polyfill.min.js',
        body: true,
        type: 'text/javascript'
      }
    ]
  },
  /*
   ** Customize the progress-bar color
   */
  loading: { color: '#fff' },
  /*
   ** Global CSS
   */
  css: [
    '@/assets/vendor/fontawesome/css/all.min.css',
    '@/assets/css/sb-admin-2.css',
    '@/assets/css/custom.css'
  ],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [
    '@/plugins/bootstrap-vue',
    '@/plugins/2backend.js',
    '@/plugins/vuelidate.js',
    //'@plugins/vue-cookie.js',
    { ssr: false, src: '~plugins/momentSetup' }

  ],
  /*
   ** Nuxt.js dev-modules
   */
  buildModules: [],
  /*
   ** Nuxt.js modules
   */
  modules: [
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios'
  ],
  /*
   ** Axios module configuration
   ** See https://axios.nuxtjs.org/options
   */
  axios: {},
  /*
   ** Build configuration
   */
  build: {
    /*
     ** You can extend webpack config here
     */
    extend(config, ctx) {
      if (ctx.isDev && ctx.isClient) {
        config.module.rules.push({
          enforce: 'pre',
          test: /\.(js|vue)$/
        })
      }

      if (ctx.isDev) {
        config.devtool = ctx.isClient ? 'source-map' : 'inline-source-map'
      }
    }
  },
  env: {
    smartschoolUrl: process.env.SMARTSCHOOL_URL || "",
    smartSchoolClientId: process.env.SMARTSCHOOL_CLIENTID || "",
    apiUrl: process.env.API_URL || "http://localhost:80/api",
    portalFrontUrl: process.env.API_PORTALFRONT || "http://localhost:3000"
  } 
}
