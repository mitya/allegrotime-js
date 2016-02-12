require 'sprockets/coffee-react'

::Sprockets.register_preprocessor 'application/javascript', ::Sprockets::CoffeeReact
::Sprockets.register_engine '.cjsx', ::Sprockets::CoffeeReactScript
::Sprockets.register_engine '.js.cjsx', ::Sprockets::CoffeeReactScript

page "index.html", :layout => false

activate :react do |config|
  config.harmony = true
end

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'
set :build_dir, 'www'

ignore "/js/components/*"
ignore "/js/models/*"
ignore "/js/lib/*"
ignore "/js/dispatcher.coffee"
ignore "/css/normalize.css"
ignore "/css/pixeden.css"

configure :development do
  # activate :jasmine
end

configure :build do
  # activate :minify_css
  # activate :minify_javascript
  # activate :asset_hash
  # activate :relative_assets
end

after_configuration do
  sprockets.append_path File.join root, 'bower_components'
end
