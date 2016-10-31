require 'pathname'
require 'csv'
require 'json'
require 'erb'

load 'tasks/running.rake'
load 'tasks/images.rake'
load 'tasks/screenshots.rake'
load 'tasks/data.rake'

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
