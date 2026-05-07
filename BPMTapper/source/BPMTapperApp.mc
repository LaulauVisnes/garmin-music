import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class BPMTapperApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new BPMTapperView();
        var delegate = new BPMTapperDelegate(view);
        return [ view, delegate ] as [Views, InputDelegates];
    }
}