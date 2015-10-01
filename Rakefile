require 'pathname'
require 'csv'
require 'json'

$icons_dir = Pathname.new("source/images/icons_colored")

namespace :icons do
  task :colorize do
    color = '#999'
    Pathname.glob("originals/icons/*.png") do |path|
      file = path.basename
      unless ($icons_dir / file).exist? or ENV['force']
        sh "convert #{path} -channel RGB -fuzz 99% -fill '#{color}' -opaque '#000' #{$icons_dir / file}"
      end
    end
  end

  task :extent do
    icons = {
      forward: '150',
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

task :convert_csv_dataset_to_json do
  csv_file  = "data/schedule_20150412.csv"
  json_file = csv_file.sub(/csv$/, 'json')
  js_file   = "source/js/schedule_data.js"
  # CSV.foreach(csv_file) { |row| crossing_name, distance, lat, lng, *closing_times = row }

  dataset = {}
  dataset['rows'] = CSV.read(csv_file)
  File.write json_file, JSON.pretty_generate(dataset)
  File.write js_file, "var AllegroTime_Data = #{JSON.pretty_generate(dataset)}"
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
