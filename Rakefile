require 'pathname'

task :recolor_icons do
  color = '#999'
  Pathname.glob("originals/icons/*.png") do |path|
    file = path.basename
    sh "convert #{path} -channel RGB -fuzz 99% -fill '#{color}' -opaque '#000' source/images/icons-colored/#{file}"
  end
end
