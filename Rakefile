require 'pathname'
require 'csv'
require 'json'

$icons_dir = Pathname.new("source/images/icons")

namespace :icons do
  task :make do
    color = '#999'
    color = '#0076ff'

    convert = -> (src, dst, color) do
      sh "convert #{src} -channel RGB -fuzz 99% -fill '#{color}' -opaque '#000' #{dst}"
    end

    Pathname.glob("originals/icons/*.png") do |path|
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
end

task :server do
  sh "bundle exec middleman server -p 3000"
end

task :build do
  sh "bundle exec middleman build"
end

task :cordova do
  sh "cd cordova && cordova build"
end

task :run do
  sh "cd cordova && cordova run ios"
end

task :android do
  sh "cd cordova && cordova run android"
end

task :log do
  sh "tail -f platforms/ios/cordova/console.log" if File.exist? 'platforms/ios/cordova/console.log'
end

task :publish do
  current_version_string = `grep widget.*version= cordova/config.xml`
  current_version = current_version_string.scan(/0\.\d\d\d\d\.\d\d\d\d/).first
  new_version = Time.now.strftime('0.%m%d.%H%M')
  app_name = 'AllegroTime3'

  sh "sed -i '' 's/#{current_version}/#{new_version}/' cordova/config.xml"
  sh "cd cordova && cordova build --device ios"
  sh %{cd cordova && /usr/bin/xcrun -sdk iphoneos PackageApplication "$(pwd)/platforms/ios/build/device/#{app_name}.app" -o "/users/dima/desktop/#{app_name}-#{new_version}.ipa"}
end

task bc: [:build, :cordova]
task bcr: [:build, :cordova, :run]
task bca: [:build, :cordova, :android]
task bcp: [:build, :cordova, :publish]
task cr: [:cordova, :run]
task b: :build
task s: :server
task p: :publish
task a: :android

namespace :data do
  task :import do
    csv_file  = "data/schedule_20151020.csv"
    json_file = csv_file.sub(/csv$/, 'json')
    js_file   = "source/js/schedule_data.js"
    # CSV.foreach(csv_file) { |row| crossing_name, distance, lat, lng, *closing_times = row }

    data = CSV.read(csv_file, col_sep: ';')
    headers = data.shift

    dataset = {}
    dataset['trains'] = headers[4, 16].map(&:to_i)
    dataset['rows'] = data
    dataset['rows'].map! { |row| row[0..-3] }
    dataset['rows'].each { |row| row[1] = row[1].to_i }
    dataset['rows'].each { |row| row[2] = row[2].to_f }
    dataset['rows'].each { |row| row[3] = row[3].to_f }
    File.write json_file, JSON.pretty_generate(dataset)
    File.write js_file, "var AllegroTime_Data = #{JSON.pretty_generate(dataset)}"
  end
end

namespace :res do
  task :resize do
    src = "originals/resources/app_icon_android.png"
    sizes = %w(36 48 72 96 144 192)
    sizes.each do |size|
      dst = "originals/res/Icon-#{size}.png"
      sh "convert #{src} -resize #{size}x#{size} #{dst}"
    end

    src = "originals/resources/app_launch_screen.png"
    sizes = %w(1920 1600 1280 800 480 320)
    sizes.each do |size1|
      size2 = size1.to_i * 9 / 16
      sh "convert #{src} -resize #{size1}x#{size1} -gravity center -crop #{size2}x#{size1}+0+0 originals/res/Default-Portrait-#{size1}.png"
      sh "convert #{src} -resize #{size1}x#{size1} -gravity center -crop #{size1}x#{size2}+0+0 originals/res/Default-Landscape-#{size1}.png"
    end
  end

  task :make_android_app_icon do
    size = 1024
    corners = 102
    sh "convert -size #{size}x#{size} xc:none -fill white -draw 'roundRectangle 0,0 #{size},#{size} #{corners},#{corners}' originals/resources/app_icon.png -compose SrcIn -composite originals/resources/app_icon_android.png"
  end
end

namespace :screenshots do
  task :take do
    sh "snapshot"
    sh "frameit"
  end

  task :setup do
    src = Pathname("other").expand_path
    screenshots_dir = Pathname("cordova/platforms/ios/screenshots").expand_path
    ios_dir = Pathname("cordova/platforms/ios").expand_path

    mkdir_p  screenshots_dir / "ru-RU"

    ln_sf "#{src}/Framefile.json", screenshots_dir
    ln_sf "#{src}/title.strings", screenshots_dir / "ru-RU"
    ln_sf "#{src}/Snapfile", ios_dir
    ln_sf "#{src}/snapshot-iPad.js", ios_dir
    ln_sf "#{src}/snapshot.js", ios_dir
  end

  task :copy do
    src = Pathname("cordova/platforms/ios/screenshots").expand_path
    dst = Pathname("screenshots").expand_path
    rm_rf dst / 'ru/*'
    cp Dir.glob(src / 'ru-RU/*_framed.png'), dst / 'ru'
    cp Dir.glob(src / 'ru-RU/*_framed.png'), dst / 'en-US'
  end
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
