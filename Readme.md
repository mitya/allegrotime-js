AllegroTime port for the web.

## Cordova commands

    cordova create allegrotime
    cordova plugin add cordova-plugin-console
    cordova plugin add cordova-plugin-statusbar
    cordova plugin add cordova-plugin-whitelist
    cordova plugin add cordova-plugin-geolocation
    cordova plugin add cordova-plugin-splashscreen
    cordova plugin add cordova-plugin-device
    cordova plugin add cordova-plugin-app-version
    cordova platform add ios
    cordova platform add android

    cordova build ios
    cordova run ios
    cordova emulate ios --target='iPhone-6-Plus, 9.1'

    platforms/ios/cordova/lib/list-emulator-images


## Making snapshots

    gem install snapshot frameit deliver
    cd cordova/platforms/ios
    snapshot init
    cp other/snapshot.js cordova/platforms/ios
    cp other/snapshot.js cordova/platforms/ios/snapshot-iPad.js
    cp other/Snapfile cordova/platforms/ios
    uncomment the stuff in the app.js
    snapshot
    cd cordova/platforms/ios/screenshots
    frameit silver


## Fixes

  * After adding the iOS platform. Edit `platforms/ios/cordova/default.xml`

        replace `BackupWebStorage` to `none` in platforms/ios/cordova/default.xml

  * After adding cordova-plugin-geolocation plugin. Edit `plugins/cordova-plugin-geolocation/plugin.xml`

        set NSLocationWhenInUseUsageDescription to "Требуется для определения ближайшего ж/д переезда."


