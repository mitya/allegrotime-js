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
    dst = Pathname("assets/screenshots").expand_path
    rm_rf dst / 'ru/*'
    cp Dir.glob(src / 'ru-RU/*_framed.png'), dst / 'ru'
    cp Dir.glob(src / 'ru-RU/*_framed.png'), dst / 'en-US'
  end

  # http://mockuphone.com/
  # https://placeit.net/
  task :for_site do
    screenshots_dir = "assets/screenshots/site"
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
