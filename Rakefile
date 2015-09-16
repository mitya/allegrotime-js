require 'pathname'

task :recolor_icons do
  color = '#999'
  Dir.chdir("source/images/icons")
  Pathname.glob("*.png") do |path|
    file = path.basename('.png')
    sh "convert #{file}.png -channel RGB -fuzz 99% -fill '#{color}' -opaque '#000' colored/#{file}.png"
  end
end