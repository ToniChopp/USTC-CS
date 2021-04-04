import Vue from 'vue'
import vcharts from 'v-charts'
import App from './App.vue'
import vuetify from './plugins/vuetify';
import router from './router.js'
import axios from 'axios'

Vue.use(vcharts)

Vue.config.productionTip = false
axios.defaults.timeout = 5000;
axios.defaults.withCredentials = false;
axios.defaults.baseURL = '/api';
axios.defaults.headers.post['Content-Type'] = 'application/json';

Vue.prototype.$axios = axios



new Vue({
  vuetify,
  render: h => h(App),
  router,
}).$mount('#app')
