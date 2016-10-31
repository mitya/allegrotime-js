$app_name = "AllegroTime"
$app_name_dev = "AllegroTimeNx"
$build_dir = 'www'
$icons_dir = Pathname("src/images/icons")
$ios_next_version = "3.0.2"
$android_next_version = "1.0.2"
$android_key_path = "#{Dir.home}/code/_etc/my-release-key.keystore"
$ios_emulator_target = "iPhone-6"

task('devserver') { sh "webpack-dev-server --content-base #$build_dir --port 3000" }
task('webserver') { sh "ruby -run -e httpd #$build_dir -p 3000" }
task('ios') { sh "cordova run ios --target='#$ios_emulator_target' | xcpretty" }
task('ios:device') { sh "cordova run ios --device" }
task('ios:build') { sh "cordova build ios" }
task('ios:clean') { sh "cordova clean ios" }
task('android') { sh "cordova run android" }
task('xcode') { sh "open platforms/ios/#$app_name.xcodeproj" }

task 'pack' do
  sh "webpack --progress -p"
end

task 'pack:watch' do
  sh "webpack --watch"
end

task 'pack:clean' do
  sh "rm -rf #{$build_dir}/*"
  sh "rake copy"
end

task 'pack:static' do
  sh "mkdir -p #{$build_dir}/images"
  sh "cp -R src/images #{$build_dir}/"
  sh "touch #{$build_dir}/cordova.js"
end

task 'config' do
  version = $ios_next_version
  build_number = Time.now.strftime('%y%j%H%M')
  build_app_name = false ? $app_name : $app_name_dev
  options = {version: version, build: build_number, name: build_app_name}.
    map { |k,v| "#{k}='#{v}'" }.join(' ')

  sh "erb #{options} config.xml.erb > config.xml"
end

task 'publish:appstore' do
  release = ENV['RELEASE']
  build_time = Time.now.strftime('%Y%m%d-%H%M')
  source_path = "#{Dir.pwd}/platforms/ios/build/device/#{$app_name}.app"
  target_path = "#{Dir.home}/desktop/#{$app_name}-#{build_time}.ipa"

  sh "cordova build --device #{'--release' if release} ios"
  sh %{/usr/bin/xcrun -sdk iphoneos PackageApplication "#{source_path}" -o "#{target_path}"}
end

task 'publish:playstore' do
  # run this at first:
  # keytool -genkey -v -keystore my-release-key.keystore -alias name.sokurenko -keyalg RSA -keysize 2048 -validity 10000

  apk_path = "platforms/android/build/outputs/apk/android-release-unsigned.apk"
  build_time = Time.now.strftime('%Y%m%d-%H%M')

  sh "cordova build --release android"
  sh "jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore #{$android_key_path} -storepass $PS_KEYSTORE_PWD #{apk_path} name.sokurenko"

  target_path = "#{Dir.home}/desktop/#{build_app_name}-#{build_time}.apk"
  rm_rf target_path
  sh "~/Library/Android/sdk/build-tools/23.0.1/zipalign -v 4 #{apk_path} #{target_path}"
end
