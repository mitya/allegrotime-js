AllegroTime port for the web.

## Running

    bundle
    rake build
    rake server # runs middleman

    rake cordova
    rake ios
    rake android # runs android device or similator
    rake device # runs ios device

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


## Performance

Rendering the Schedule graph (Mac/iPad mini 2/ASUS Zenfone 2)

 * using Handlebars: 1.6 / 8.0 / 15
 * using jQuery: 6 / 15 / 30

Rendering the Status screen

* using Handlebars: 1 / 2 / 6
* using jQuery: 2 / 3 / 7

Rendering the crossings list

* using Handlebars: 2.5 / 6 / 11 (re-render everything)
* using jQuery: 0.05 / 0.5 / 0.5 (just update the colors)
* using jQuery: 7.5 / 40 / 65 (initialization)

React is 2-4 times slower than Handlebars


## Dependencies

### ReactRouter

bower install -S rackt/react-router
cd bower_components/react-router
npm install && npm run build-umd
# link bower_components/react-router/umd/ReactRouter.js

### History

bower install -S rackt/history
cd bower_components/history
npm install
npm run build-umd
npm run build-min


## State

* time
* closest crossing (location) ?
* selected crosing ?
***
* current tab
* navigation path
* current page
***
* current crossing: selected | closest
* current tab: current page
