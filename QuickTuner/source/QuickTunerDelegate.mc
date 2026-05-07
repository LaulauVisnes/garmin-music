import Toybox.WatchUi;
import Toybox.Lang;

class QuickTunerDelegate extends WatchUi.BehaviorDelegate {
    private var _view as QuickTunerView;

    function initialize(view as QuickTunerView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onNextPage() as Boolean { // Down button
        _view.prevNote();   // Select lower spot in array
        return true;
    }

    function onPreviousPage() as Boolean { // Up button
        _view.nextNote();       // Select higher spot in array
        return true;
    }

    function onSelect() as Boolean { // Start button (Start/Stop)
        _view.togglePlay();
        return true;
    }
}