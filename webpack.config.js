var ExtractTextPlugin = require("extract-text-webpack-plugin");
var HtmlWebpackPlugin = require('html-webpack-plugin');
var path = require('path')
var nodeModulesDir = path.resolve(__dirname, "./node_modules")
var assetFormat = "[name]-[hash:4].[ext]"
var cssExtractor = new ExtractTextPlugin('css', "[name]-[hash:4].css")
// var indexHtmlExtractor = new ExtractTextPlugin('html', "root.html")

module.exports = {
  // devtool: 'cheap-module-eval-source-map',
  // devtool: 'eval-source-map',
  devtool: 'source-map',
  entry: { all: "./src/js/main.coffee" },
  output: { path: './www/assets', filename: "[name]-[hash:4].js", chunkFilename: "[id].js", publicPath: '' },

  module: {
    loaders: [
  // { test: /\.scss$/, loader: 'style!css!sass' } // inline styles
  // { test: /\.(jpe?g|png|gif|svg)$/i, exclude: /(node_modules|bower_components)/, loader: 'url?limit=1000&name=images/[hash].[ext]' } // IMAGES
  // { test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "url-loader?limit=10000&minetype=application/font-woff" },
  // { test: /index.html.ejs$/, loader: indexHtmlExtractor.extract("html!ejs-html") },

      { test: /\.css$/,
        loader: "style!css?sourceMap" },
      { test: /\.scss$/,
        loader: cssExtractor.extract("style", `css?sourceMap!sass?sourceMap&includePaths[]=${nodeModulesDir}`) },
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
    cssExtractor,
    new HtmlWebpackPlugin({
      title: 'Custom Index',
      filename: '../index.html',
      template: 'src/index.html.ejs',
      inject: false
    })
  ],

  resolve: {
    extensions: ['', '.js', '.json', '.coffee', '.cjsx']
  },

  ejsHtml: {
    env: 'device',
  }
};
