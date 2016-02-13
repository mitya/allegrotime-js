var ExtractTextPlugin = require("extract-text-webpack-plugin");
var path = require('path')
var nodeModulesDir = path.resolve(__dirname, "./node_modules")
var assetFormat = "assets/[name]-[hash].[ext]"

module.exports = {
  // devtool: 'eval-source-map',
  // devtool: 'cheap-module-eval-source-map',
  entry: { all: "./source/js/main.js" },
  output: { path: './www/pack', filename: "[name].js", chunkFilename: "[id].js", publicPath: '/pack/' },

  module: {
    loaders: [
      // { test: /\.scss$/, loader: 'style!css!sass' } // inline styles
      // { test: /\.coffee$/, loader: "coffee" },
      // { test: /\.(jpe?g|png|gif|svg)$/i, exclude: /(node_modules|bower_components)/, loader: 'url?limit=1000&name=images/[hash].[ext]' } // IMAGES
      // { test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "url-loader?limit=10000&minetype=application/font-woff" },

      { test: /\.css$/,
        loader: "style!css" },
      { test: /\.scss$/,
        loader: ExtractTextPlugin.extract("style", "css!sass?includePaths[]=" + nodeModulesDir) } ,
      { test: /\.coffee$/,
        loaders: ['coffee', 'cjsx']},
      { test: /\.js$/, exclude: /node_modules/,
        loader: 'babel?presets[]=react,presets[]=es2015' },
      { test: /\.(png|jpe?g|gif)$/,
        loader: 'url?limit=4096&name=' + assetFormat },
      { test: /\.(ttf|eot|woff2?|svg?)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: "file?name=" + assetFormat }
    ]
  },

  plugins: [
    new ExtractTextPlugin("[name].css")
  ],

  resolve: {
    extensions: ['', '.js', '.json', '.coffee', '.cjsx']
  }
};