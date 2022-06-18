import Vue from 'vue'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'
import '@mdi/font/css/materialdesignicons'

Vue.use(Vuetify)

const opts = {
    theme: {
      themes: {
        light: {
          primary: '#202225',
          secondary: '#ff6f00',
          accent: '#8c9eff',
          error: '#b71c1c',
          primaryText: '#FF00FF'
        },
      },
    },
  }

export default new Vuetify(opts)