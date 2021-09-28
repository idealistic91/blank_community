import Vue from 'vue'
import App from '../app.vue'

import vuetify from '../plugins/vuetify'

import VueRouter from 'vue-router'

import Events from '../src/views/Events'

import '../src/vue_app.sass'

import Routes from '../src/config/routes'

Vue.use(VueRouter)

const router = new VueRouter(Routes)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    vuetify,
    render: h => h(App)
  }).$mount('#vue-app')
  
})