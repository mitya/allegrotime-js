require 'pathname'
require 'csv'
require 'json'

load 'tasks/running.rake'
load 'tasks/images.rake'
load 'tasks/screenshots.rake'
load 'tasks/data.rake'

task :log do
  sh "tail -f platforms/ios/cordova/console.log" if File.exist? 'platforms/ios/cordova/console.log'
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
