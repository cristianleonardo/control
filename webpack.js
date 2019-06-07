const fs = require('fs');
const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const Clean = require('clean-webpack-plugin');
const StatusPlugin = require('./node_lib/webpack-status-plugin');

const prod = process.argv.indexOf('-p') !== -1;
const css_output_template = prod ? "stylesheets/[name]-[hash].css" : "stylesheets/[name].css";
const js_output_template = prod ? "javascripts/[name]-[hash].js" : "javascripts/[name].js";

const paths = {
  src: path.join(__dirname, 'app/assets'),
  dest: path.join(__dirname, 'public', 'assets')
};

module.exports = {
  context: paths.src,
  entry: {
    application: ["./javascripts/application.js", "./stylesheets/application.scss"]
  },
  output: {
    path: paths.dest,
    filename: js_output_template,
    sourceMapFilename: js_output_template + '.map'
  },
  module: {
    rules: [
      {
        test: /\.json$/,
        enforce: 'pre',
        loader: 'json'
      },
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        loader: 'babel'
      },
    ],
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          presets: ['es2015']
        }
      },
      { test: /\.woff2?$|\.ttf$|\.eot$|\.svg$/, loader: 'file?name=/fonts/[name]_[hash].[ext]' },
      { test: /\.(css|scss)?$/, loader: ExtractTextPlugin.extract("css!sass") }
    ]
  },
  resolve: {
    extensions: ['', '.js', '.jsx', '.json'],
    modules: [paths.src, 'node_modules'],
    alias: {
      'vue$': 'vue/dist/vue.common.js'
    }
  },
  stats: {
    warnings: false
  },
  devtool: 'source-map',
  cache: true,
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '\'' + (prod ? 'production' : 'development') + '\''
      }
    }),

    new Clean(paths.dest, {
      exclude: 'images'
    }),

    StatusPlugin,

    new ExtractTextPlugin(css_output_template),

    function() {
      if(prod) {
        // output the fingerprint
        this.plugin("done", function(stats) {
          let output = "ASSET_FINGERPRINT = \"" + stats.hash + "\"";
          fs.writeFileSync("config/initializers/fingerprint.rb", output, "utf8");
        });
      }
    }
  ]
};
