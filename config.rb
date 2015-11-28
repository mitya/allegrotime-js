require 'slim'
require 'handlebars_assets'
require 'sprockets/coffee-react'

::Slim::Engine.disable_option_validator!


::Sprockets.register_preprocessor 'application/javascript', ::Sprockets::CoffeeReact
::Sprockets.register_engine '.cjsx', ::Sprockets::CoffeeReactScript
::Sprockets.register_engine '.js.cjsx', ::Sprockets::CoffeeReactScript


page "schedule.html", :layout => false
page "status.html", :layout => false
page "about.html", :layout => false


activate :react do |config|
  config.harmony = true
end

configure :development do
  activate :jasmine
end

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'
set :build_dir, 'www'

configure :build do
  # activate :minify_css
  # activate :minify_javascript
  # activate :asset_hash
  # activate :relative_assets
  # set :http_prefix, "/Content/images/"
end

after_configuration do
  sprockets.append_path File.join root, 'bower_components'
  sprockets.append_path HandlebarsAssets.path
end

ready do
end

helpers do
  def js_page(page_id, options = {}, &block)
    @classes = options[:classes]
    @page_id = page_id
    partial :page, locals: { pid: page_id }, &block
  end

  def navbar(&block)
    content_tag :ul, class: "navbar for-#{@page_id}", &block
  end
end
