const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const { VuetifyLoaderPlugin } = require('vuetify-loader')

const vue = require('./loaders/vue')
const pug = require('./loaders/pug')

const webpack = require('webpack')

environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        Popper: ["popper.js", "default"],
        moment: 'moment/moment'
    })
)

environment.plugins.prepend('VuetifyLoaderPlugin', new VuetifyLoaderPlugin())
environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.loaders.prepend('pug', pug)

module.exports = environment