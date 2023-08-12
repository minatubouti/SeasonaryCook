const { environment } = require('@rails/webpacker')
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

module.exports = environment
