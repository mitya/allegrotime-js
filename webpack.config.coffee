webpack = require('webpack')
path = require('path')
ExtractTextPlugin = require('extract-text-webpack-plugin')
HtmlWebpackPlugin = require('html-webpack-plugin')

nodeModulesDir = path.resolve(__dirname, './node_modules')
assetFormat = '[name].[ext]' # "[name]-[hash:4].[ext]"
cssExtractor = new ExtractTextPlugin('css', '[name].css')

isProduction = process.argv[1] == '/usr/local/bin/webpack'
if isProduction
  nodeEnv = 'production'
  assetsDir = 'assets/'
  devtool = 'source-map'
else
  nodeEnv = 'development'
  assetsDir = ''
  devtool = 'source-map' # maybe changed for eval for better performance

module.exports =
  devtool: devtool # source-map > eval-source-map > cheap-module-eval-source-map > eval
  entry:
    vendor: './src/vendor.coffee'
    application: './src/main.coffee'
  output:
    path: './www/assets'
    filename: '[name].js'
    chunkFilename: '[id].js'
    publicPath: ''
  module:
    loaders: [
      { test: /\.css$/, loader: 'style!css?sourceMap' }
      { test: /\.scss$/, loader: cssExtractor.extract("style", "css?sourceMap!sass?sourceMap&includePaths[]=#{nodeModulesDir}") }
      { test: /\.(coffee|cjsx)$/, loaders: ['babel?presets[]=es2015', 'coffee', 'cjsx'] }
      { test: /\.js$/, exclude: /node_modules/, loader: 'babel?presets[]=react,presets[]=es2015' }
      { test: /\.(png|jpe?g|gif)$/, loader: 'url?limit=4096&name=' + assetFormat }
      { test: /\.(ttf|eot|woff2?|svg?)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: 'file?name=' + assetFormat }
    ]
  plugins: [
    cssExtractor
    new HtmlWebpackPlugin(
      title: 'Custom Index'
      filename: '../index.html'
      template: 'src/index.ejs'
      inject: false
      targetDir: assetsDir
    )
    new webpack.DefinePlugin(
      'process.env':
        'NODE_ENV': JSON.stringify(nodeEnv) # react removes the dev warnings in production
    )
  ]
  resolve:
    extensions: ['', '.js', '.json', '.coffee', '.cjsx']
  ejsHtml:
    env: 'device'
