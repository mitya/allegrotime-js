$icons_dir = Pathname.new("source/images/icons")
$app_name = "AllegroTime"
$app_name_dev = "AllegroTimeNx"
$build_dir = 'www'
$ios_next_version = "3.0.2"
$android_next_version = "1.0.2"
$android_key_path = "#{Dir.home}/code/_etc/my-release-key.keystore"

task(:serve) { sh "webpack-dev-server --content-base #{$build_dir} --port 3000" }
task(:pack) { sh "webpack" }
task(:watch) { sh "webpack --watch" }
task(:cordova) { sh "cordova build" }
task(:ios) { sh "cordova run ios" }
task(:iosdevice) { sh "cordova run ios --device" }
task(:android) { sh "cordova run android" }
task build: [:copy, :pack]
task bc: [:build, :cordova]
task bci: [:build, :cordova, :ios]
task bca: [:build, :cordova, :android]
task bcid: [:build, :cordova, :iosdevice]
task bd: [:build, :device]
task bi: [:build, :ios]
task ba: [:build, :android]
task bp: [:build, :publish]
task cr: [:cordova, :run]
task b: :build
task c: :cordova
task s: :serve
task i: :ios
task a: :android

# task(:serve) { sh "bundle exec middleman server -p 3000" }
# task(:serve) { sh "ruby -run -e httpd #{$build_dir} -p 3000" }
# task(:build) { sh "bundle exec middleman build" }

task :copy do
  dest = $build_dir
  target ||= ENV['target'] || 'browser'

  sh "rm -rf #{dest}/*" if ENV['clean']
  sh "mkdir -p #{dest}/images"
  sh "cp -R source/images #{dest}/"
  sh "touch #{dest}/cordova.js"
  # sh "erb target=#{target} source/index.html.erb > #{dest}/index.html"
end

def render_erb(template, target, variables)
  File.write target,ERB.new(File.read(template)).result(OpenStruct.new(variables).instance_eval 'binding')
end

def update_config_xml(version)
  build_number = Time.now.strftime('%m%d%H%M')
  is_release = ENV['release'] == 'yes'
  file_version = "#{version}.#{build_number}"
  build_app_name = is_release ? $app_name : $app_name_dev
  options = {version: version, build: build_number, name: build_app_name}
  render_erb "config.xml.erb", "config.xml", options
  [is_release, build_app_name, file_version]
end

namespace :appstore do
  task :pack do
    is_release, build_app_name, file_version = update_config_xml $ios_next_version

    puts "Building a RELEASE version!" if is_release
    source_path = "#{Dir.pwd}/platforms/ios/build/device/#{$app_name}.app"
    target_path = "#{Dir.home}/desktop/#{$app_name}-#{file_version}.ipa"
    sh "cordova build --device #{'--release' if is_release} ios"
    sh %{/usr/bin/xcrun -sdk iphoneos PackageApplication "#{source_path}" -o "#{target_path}"}
  end
end

namespace :playstore do
  # keytool -genkey -v -keystore my-release-key.keystore -alias name.sokurenko -keyalg RSA -keysize 2048 -validity 10000

  apk_path = "platforms/android/build/outputs/apk/android-release-unsigned.apk"

  task :pack do
    is_release, build_app_name, file_version = update_config_xml $android_next_version

    sh "cordova build --release android"
    sh "jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore #{$android_key_path} -storepass $PS_KEYSTORE_PWD #{apk_path} name.sokurenko"

    target_path = "#{Dir.home}/desktop/#{build_app_name}-#{file_version}.apk"
    rm_rf target_path
    sh "~/Library/Android/sdk/build-tools/23.0.1/zipalign -v 4 #{apk_path} #{target_path}"
  end
end
