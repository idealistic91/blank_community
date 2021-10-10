import Vue from 'vue'
import axios from 'axios'
import App from '../app.vue'

import vuetify from '../plugins/vuetify'

import VueRouter from 'vue-router'

import '../src/vue_app.sass'

import Routes from '../src/config/routes'

Vue.use(VueRouter)

Vue.prototype.$http = axios

const router = new VueRouter(Routes)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    vuetify,
    render: h => h(App)
  }).$mount('#vue-app')
  
})