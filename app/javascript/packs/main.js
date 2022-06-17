import Vue from 'vue'
import axios from 'axios'
import App from '../app.vue'

import Vuex from 'vuex'

import vuetify from '../plugins/vuetify'

import VueRouter from 'vue-router'

import '../src/vue_app.sass'

import Routes from '../src/config/routes'

Vue.use(VueRouter)

const router = new VueRouter(Routes)

document.addEventListener('DOMContentLoaded', () => {
  const csrfToken = document.querySelector("meta[name=csrf-token]").content
  axios.defaults.headers.common['X-CSRF-Token'] = csrfToken

  Vue.prototype.$http = axios

  const app = new Vue({
    router,
    vuetify,
    render: h => h(App)
  }).$mount('#vue-app')
  
})