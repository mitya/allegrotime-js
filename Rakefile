require 'pathname'
require 'csv'
require 'json'

$icons_dir = Pathname.new("source/images/icons")
$app_name = "AllegroTime"
$apk_path = "platforms/android/build/outputs/apk/android-release-unsigned.apk"
$store_apk_path = "/Users/Dima/Desktop/AllegroTime.apk"

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
  sh "cordova build"
end

task :ios do
  sh "cordova run ios"
end

task :device do
  sh "cordova run ios --device"
end

task :android do
  sh "cordova run android"
end

task :log do
  sh "tail -f platforms/ios/cordova/console.log" if File.exist? 'platforms/ios/cordova/console.log'
end

task :publish do
  current_version_string = `grep widget.*version= config.xml`
  current_version = current_version_string.scan(/version=".*?"/).first
  new_version_number = Time.now.strftime('0.%m%d.%H%M')
  new_version = %|version="#{new_version_number}"|

  sh "sed -i '' 's/#{current_version}/#{new_version}/' config.xml"
  sh "cordova build --device ios"
  sh %{/usr/bin/xcrun -sdk iphoneos PackageApplication "$(pwd)/platforms/ios/build/device/#{$app_name}.app" -o "/users/dima/desktop/#{$app_name}-#{new_version_number}.ipa"}
end

task :release do
  current_version_string = `grep widget.*version= config.xml`
  current_version = current_version_string.scan(/version=".*?"/).first
  new_version_number = "3.0.0"
  new_version = %|version="#{new_version_number}"|

  sh "sed -i '' 's/#{current_version}/#{new_version}/' config.xml"
  sh "cordova build --device --release ios"
  sh %{/usr/bin/xcrun -sdk iphoneos PackageApplication "$(pwd)/platforms/ios/build/device/#{$app_name}.app" -o "/users/dima/desktop/#{$app_name}-#{new_version_number}.ipa"}
end

namespace :playstore do
  # keytool -genkey -v -keystore my-release-key.keystore -alias name.sokurenko -keyalg RSA -keysize 2048 -validity 10000

  # rake playstore:release
  # rake playstore:sign
  # rake playstore:zipalign

  task :release do
    sh "cordova build --release android"
  end

  task :sign do
    key_path = "/users/dima/code/_etc/my-release-key.keystore"
    sh "jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore #{key_path} -storepass $PS_KEYSTORE_PWD #{$apk_path} name.sokurenko"
  end

  task :zipalign do
    rm_rf $store_apk_path
    sh "~/Library/Android/sdk/build-tools/23.0.1/zipalign -v 4 #{$apk_path} #{$store_apk_path}"
  end
end


task bc: [:build, :cordova]
task bcd: [:build, :cordova, :device]
task bci: [:build, :cordova, :ios]
task bca: [:build, :cordova, :android]
task bcp: [:build, :cordova, :publish]
task bd: [:build, :device]
task bi: [:build, :ios]
task ba: [:build, :android]
task bp: [:build, :publish]
task cr: [:cordova, :run]
task b: :build
task c: :cordova
task s: :server
task d: :device
task p: :publish
task a: :android

namespace :data do
  task :import do
    csv_file  = "data/schedule_20151110.csv"
    json_file = csv_file.sub(/csv$/, 'json')

    data = CSV.read(csv_file, col_sep: ';')
    headers = data.shift

    dataset = {}
    dataset['alert'] = nil
    dataset['updated_at'] = '2015-11-10'
    dataset['trains'] = headers[4, 18].map(&:to_i)
    dataset['rows'] = data
    dataset['rows'].map! { |row| row[0..-4] }
    dataset['rows'].each { |row| row[1] = row[1].to_i }
    dataset['rows'].each { |row| row[2] = row[2].to_f }
    dataset['rows'].each { |row| row[3] = row[3].to_f }

    File.write json_file, JSON.pretty_generate(dataset)
    File.write "source/data/schedule.json", JSON.pretty_generate(dataset)
    File.write "source/js/schedule_data.js", "var AllegroTime_Data = #{JSON.pretty_generate(dataset)}"
  end
end

namespace :res do
  namespace :ios do
    task :icons do
      input = "originals/resources/app_icon_updated.png"
      sizes = [ [60, 2], [60, 3], [76, 1], [76, 2], [40, 1], [40, 2], [29, 1], [29, 2], [29, 3] ]
      sizes.each do |size, scale|
        pixel_size = size * scale
        suffix = "@#{scale}x" unless scale == 1
        filename = "IconApple-#{size}#{suffix}"
        sh "convert '#{input}' -resize #{pixel_size}x#{pixel_size} originals/res/#{filename}.png"
      end
    end
  end

  namespace :android do
    task :icons do
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

    task :app_icon do
      size = 1024
      corners = 128
      sh "convert -size #{size}x#{size} xc:none -fill white -draw 'roundRectangle 0,0 #{size},#{size} #{corners},#{corners}' originals/resources/app_icon.png -compose SrcIn -composite originals/resources/app_icon_android.png"
    end

    task :store do
      src = "originals/resources"
      dst = "originals/res"
      sh "convert #{src}/app_icon_android.png -resize 512x512 #{dst}/PlayStore-Icon.png"
      sh "convert #{src}/app_icon.png -resize 1024x1024 -gravity center -crop 1024x500+0+0 #{dst}/PlayStore-Feature.jpg"
      sh "convert #{src}/app_icon.png -resize 180x180 -gravity center -crop 180x120+0+0 #{dst}/PlayStore-Promo.jpg"
      sh "convert #{src}/app_icon.png -resize 320x320 -gravity center -crop 320x180+0+0 #{dst}/PlayStore-TV.jpg"
    end
  end
end

namespace :screenshots do
  task :take do
    sh "snapshot"
    sh "frameit"
  end

  # and don't forget to uncomment the screenshoting code in app.js
  task :setup do
    src = Pathname("other").expand_path
    screenshots_dir = Pathname("platforms/ios/screenshots").expand_path
    ios_dir = Pathname("platforms/ios").expand_path

    mkdir_p  screenshots_dir / "ru-RU"

    sh "cd #{ios_dir} && snapshot init"

    ln_sf "#{src}/Framefile.json", screenshots_dir
    ln_sf "#{src}/title.strings", screenshots_dir / "ru-RU"
    ln_sf "#{src}/Snapfile", ios_dir
    ln_sf "#{src}/snapshot-iPad.js", ios_dir
    ln_sf "#{src}/snapshot.js", ios_dir
  end

  task :copy do
    src = Pathname("platforms/ios/screenshots").expand_path
    dst = Pathname("screenshots").expand_path
    rm_rf dst / 'ru/*'
    cp Dir.glob(src / 'ru-RU/*_framed.png'), dst / 'ru'
    cp Dir.glob(src / 'ru-RU/*_framed.png'), dst / 'en-US'
  end

  # http://mockuphone.com/
  # https://placeit.net/
  task :for_site do
    screenshots_dir = "screenshots/site"
    Dir.chdir screenshots_dir
    sh "frameit silver"
    Dir.glob("*_framed.png") do |path|
      basename = File.basename(path, '_framed.png')
      new_basename = "v3-#{basename}"
      sh "convert #{path} -background white -alpha remove -quality 60 #{new_basename}@2x.jpg"
      sh "convert #{path} -background white -alpha remove -resize 306x -quality 60 #{new_basename}.jpg"
    end
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

# platforms/android/cordova/lib/list-started-emulators
# adb install -rs platforms/android/build/outputs/apk/android-debug.apk
