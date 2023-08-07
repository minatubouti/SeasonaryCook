const { environment } = require('@rails/webpacker')

module.exports = environment

// jQueryとPopper.jsをWebpackerに認識させます。
const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: 'popper.js'
  })
)