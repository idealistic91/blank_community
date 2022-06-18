import Vue from 'vue'
import axios from 'axios'
import App from '../app.vue'

import Vuex from 'vuex'

import vuetify from '../plugins/vuetify'

import VueRouter from 'vue-router'

import '../src/vue_app.sass'

import Routes from '../src/config/routes'

Vue.use(VueRouter)
Vue.use(Vuex)

import store from '../src/store'

const vuexStore = new Vuex.Store(store)

const router = new VueRouter(Routes)

document.addEventListener('DOMContentLoaded', () => {
  const csrfToken = document.querySelector("meta[name=csrf-token]").content
  axios.defaults.headers.common['X-CSRF-Token'] = csrfToken

  Vue.prototype.$http = axios

  const app = new Vue({
    store: vuexStore,
    router,
    vuetify,
    render: h => h(App),
    mounted: function () { this.$store.commit('setCsrfToken', csrfToken) }
  }).$mount('#vue-app')
  
})