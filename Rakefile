require 'pathname'
require 'csv'
require 'json'

$icons_dir = Pathname.new("source/images/icons")

namespace :icons do
  task :colorize do
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
  sh "cd cordova && cordova build ios"
end

task :run do
  sh "cd cordova && cordova run ios"
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
task bcp: [:build, :cordova, :publish]
task cr: [:cordova, :run]
task b: :build
task s: :server
task p: :publish

namespace :data do
  task :csv_to_json do
    csv_file  = "data/schedule_20151020.csv"
    json_file = csv_file.sub(/csv$/, 'json')
    js_file   = "source/js/schedule_data.js"
    # CSV.foreach(csv_file) { |row| crossing_name, distance, lat, lng, *closing_times = row }

    dataset = {}
    dataset['rows'] = CSV.read(csv_file, col_sep: ';')
    dataset['rows'].map! { |row| row[0..-3] }
    dataset['rows'].each { |row| row[1] = row[1].to_i }
    dataset['rows'].each { |row| row[2] = row[2].to_f }
    dataset['rows'].each { |row| row[3] = row[3].to_f }
    File.write json_file, JSON.pretty_generate(dataset)
    File.write js_file, "var AllegroTime_Data = #{JSON.pretty_generate(dataset)}"
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
