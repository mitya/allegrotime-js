require 'pathname'

$icons_dir = Pathname.new("source/images/icons_colored")

task :colorize_icons do
  color = '#999'
  Pathname.glob("originals/icons/*.png") do |path|
    file = path.basename
    sh "convert #{path} -channel RGB -fuzz 99% -fill '#{color}' -opaque '#000' #{$icons_dir / file}"
  end
end

task :extent_icon do
  name = "forward"
  src = $icons_dir / "#{name}.png"
  dst = $icons_dir / "#{name}_ext.png"
  sh "convert #{src} -background transparent -gravity west -extent 150x100 #{dst}"
end
