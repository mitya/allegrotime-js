AllegroTime port for the web.

## Cordova commands

    cordova create allegrotime
    cordova plugin add cordova-plugin-console
    cordova plugin add cordova-plugin-statusbar
    cordova plugin add cordova-plugin-whitelist
    cordova plugin add cordova-plugin-geolocation
    cordova platform add ios

    cordova build ios
    cordova run ios


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
