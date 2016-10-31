namespace :icons do
  task :make do
    color = '#999'
    color = '#0076ff'

    convert = -> (src, dst, color) do
      sh "convert #{src} -channel RGB -fuzz 99% -fill '#{color}' -opaque '#000' #{dst}"
    end

    $icons_dir.mkpath
    Pathname.glob("assets/originals/icons/*.png") do |path|
      file = path.basename('.png')
      target = $icons_dir / "#{file}.png"
      convert.call(path, target, color) if !target.exist? or ENV['force']

      if %w[forward flag_2 clock map_marker traffic_light compass].include? file.to_s
        target = $icons_dir / "#{file}_gray.png"
        convert.call(path, target, '#999') if !target.exist? or ENV['force']
      end
    end
  end

  task :extent do
    icons = {
      forward_gray: '150',
      checkmark_filled: '150',
    }
    icons.each do |name, width|
      src = $icons_dir / "#{name}.png"
      dst = $icons_dir / "#{name}_ext.png"
      next if dst.exist? && !ENV['force']
      sh "convert #{src} -background transparent -gravity west -extent #{width}x100 #{dst}"
    end
  end

  task all: [:make, :extent]
end

namespace :res do
  namespace :ios do
    task :icons do
      input = "assets/originals/resources/app_icon_updated.png"
      sizes = [ [60, 2], [60, 3], [76, 1], [76, 2], [40, 1], [40, 2], [29, 1], [29, 2], [29, 3], [83.5, 2] ]
      sizes.each do |size, scale|
        pixel_size = size * scale
        suffix = "@#{scale}x" unless scale == 1
        filename = "IconApple-#{size}#{suffix}"
        sh "convert '#{input}' -resize #{pixel_size}x#{pixel_size} assets/originals/res/#{filename}.png"
      end
    end
  end

  namespace :android do
    task :icons do
      src = "assets/originals/resources/app_icon_android.png"
      sizes = %w(36 48 72 96 144 192)
      sizes.each do |size|
        dst = "assets/originals/res/Icon-#{size}.png"
        sh "convert #{src} -resize #{size}x#{size} #{dst}"
      end

      src = "assets/originals/resources/app_launch_screen.png"
      sizes = %w(1920 1600 1280 800 480 320)
      sizes.each do |size1|
        size2 = size1.to_i * 9 / 16
        sh "convert #{src} -resize #{size1}x#{size1} -gravity center -crop #{size2}x#{size1}+0+0 assets/originals/res/Default-Portrait-#{size1}.png"
        sh "convert #{src} -resize #{size1}x#{size1} -gravity center -crop #{size1}x#{size2}+0+0 assets/originals/res/Default-Landscape-#{size1}.png"
      end
    end

    task :app_icon do
      size = 1024
      corners = 128
      sh "convert -size #{size}x#{size} xc:none -fill white -draw 'roundRectangle 0,0 #{size},#{size} #{corners},#{corners}' originals/resources/app_icon.png -compose SrcIn -composite originals/resources/app_icon_android.png"
    end

    task :store do
      src = "assets/originals/resources"
      dst = "assets/originals/res"
      sh "convert #{src}/app_icon_android.png -resize 512x512 #{dst}/PlayStore-Icon.png"
      sh "convert #{src}/app_icon.png -resize 1024x1024 -gravity center -crop 1024x500+0+0 #{dst}/PlayStore-Feature.jpg"
      sh "convert #{src}/app_icon.png -resize 180x180 -gravity center -crop 180x120+0+0 #{dst}/PlayStore-Promo.jpg"
      sh "convert #{src}/app_icon.png -resize 320x320 -gravity center -crop 320x180+0+0 #{dst}/PlayStore-TV.jpg"
    end
  end
end
