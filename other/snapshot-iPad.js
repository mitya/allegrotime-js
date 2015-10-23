#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

target.setDeviceOrientation(UIA_DEVICE_ORIENTATION_PORTRAIT);

function change() {
  target.frontMostApp().mainWindow().scrollViews()[1].webViews()[0].tapWithOptions({tapOffset:{x:0.96, y:0.02}});
  target.delay(0.5);
}

captureLocalizedScreenshot("0-Status")
change()
captureLocalizedScreenshot("1-Schedule")
change()
change()
captureLocalizedScreenshot("2-List")
