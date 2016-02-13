require 'pathname'
require 'csv'
require 'json'
load 'tasks/images.rake'
load 'tasks/screenshots.rake'
load 'tasks/data.rake'

$icons_dir = Pathname.new("source/images/icons")
$app_name = "AllegroTime"
$apk_path = "platforms/android/build/outputs/apk/android-release-unsigned.apk"
$store_apk_path = "/Users/Dima/Desktop/AllegroTime.apk"
$build_dir = 'www'

task(:serve) { sh "webpack-dev-server --content-base #{$build_dir} --port 3000" }
task(:pack) { sh "webpack" }
task(:watch) { sh "webpack --watch" }
task(:cordova) { sh "cordova build" }
task(:ios) { sh "cordova run ios" }
task(:iosdevice) { sh "cordova run ios --device" }
task(:android) { sh "cordova run android" }
task build: [:copy, :pack]
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
task s: :serve
task is: :ios
task id: :iosdevice
task a: :android

# task(:serve) { sh "bundle exec middleman server -p 3000" }
# task(:serve) { sh "ruby -run -e httpd #{$build_dir} -p 3000" }
# task(:build) { sh "bundle exec middleman build" }

task :copy do
  dest = $build_dir
  target ||= ENV['target'] || 'browser'

  sh "rm -rf #{dest}/*"
  sh "mkdir -p #{dest}/fonts #{dest}/images #{dest}/js"
  sh "cp -R source/images #{dest}/"
  sh "cp source/js/data.js #{dest}/js/"
  sh "erb target=#{target} source/index.html.erb > #{dest}/index.html"
end

namespace :appstore do
  task :package do
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
end

namespace :playstore do
  # keytool -genkey -v -keystore my-release-key.keystore -alias name.sokurenko -keyalg RSA -keysize 2048 -validity 10000

  task :build_release do
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

  task release: [:build_release, :sign, :zipalign]
end

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
