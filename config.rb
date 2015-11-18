require 'slim'
require 'handlebars_assets'
require 'sprockets/coffee-react'

Slim::Engine.disable_option_validator!

# compass_config do |config|
#   config.output_style = :compact
# end

::Sprockets.register_preprocessor 'application/javascript', ::Sprockets::CoffeeReact
::Sprockets.register_engine '.cjsx', ::Sprockets::CoffeeReactScript
::Sprockets.register_engine '.js.cjsx', ::Sprockets::CoffeeReactScript


# With no layout
page "schedule.html", :layout => false
page "status.html", :layout => false
page "about.html", :layout => false

# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout

# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

activate :react

# Reload the browser automatically whenever files change
configure :development do
  # activate :livereload
  activate :jasmine
end

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'
set :build_dir, 'www'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

after_configuration do
  sprockets.append_path File.join root, 'bower_components'
  sprockets.append_path File.dirname(::React::Source.bundled_path_for('react.js'))

  # sprockets.import_asset 'jquery'
end

ready do
  sprockets.append_path HandlebarsAssets.path
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
