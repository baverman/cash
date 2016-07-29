'use strict';

var webpack = require('webpack'),
    HtmlWebpackPlugin = require('html-webpack-plugin');

var isProd = process.env['NODE_ENV'] === 'production';

var entries = ['./src/app.ls']
var lsLoaders = ['livescript']

module.exports = {
  entry: entries,
  output: {
    path: './www',
    filename: 'js/app.js',
    publicPath: '/',
  },
  module: {
    loaders: [
      {test: /\.ls$/, loaders: lsLoaders},
      {test: /\.css$/, loader: "style-loader!css-loader?modules&localIdentName=[local]-[hash:base64:5]"},
    ]
  },
  plugins: [
    // new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/),
    new webpack.NoErrorsPlugin()
  ],
  debug: true,
  devtool: '#source-map',
  devServer: {
    contentBase: './www',
    historyApiFallback: true
  }
};

if (isProd) {
    module.exports.plugins.unshift(new webpack.optimize.UglifyJsPlugin({minimize: true}));
}
