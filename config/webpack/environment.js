const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.append('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jquery: 'jquery',
        Popper: ['popper.js', 'default'],
        moment: 'moment/moment',
        flatpickr: 'flatpickr'
    })
)

module.exports = environment