import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;
import Toybox.Timer;
import Toybox.Attention;

class BPMTapperDelegate extends WatchUi.BehaviorDelegate {

    private var taps as Array<Number>;
    private var maxTaps as Number = 5;
    private var view as BPMTapperView;
    private var vibrateTimer as Timer.Timer;
    private var isVibrating as Boolean = false;
    private var currentBpm as Number = 0;

    function initialize(view as BPMTapperView) {
        BehaviorDelegate.initialize();
        self.taps = [] as Array<Number>;
        self.view = view;
        self.vibrateTimer = new Timer.Timer();
    }

    function onTap(clickEvent as ClickEvent) as Boolean {
        recordTap();
        return true;
    }

    private function recordTap() as Void {
        var now = System.getTimer();
        
        // Reset if the last tap was more than 3 seconds ago
        if (taps.size() > 0 && (now - taps[taps.size() - 1]) > 3000) {
            taps = [] as Array<Number>;
            currentBpm = 0;
            view.setBpm(currentBpm);
            stopVibrating();
        }
        
        taps.add(now);

        // Keep only the last `maxTaps` taps
        if (taps.size() > maxTaps) {
            taps = taps.slice(1, taps.size());
        }

        calculateBpm();
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        // Support using the physical 'DOWN' button to toggle vibration
        if (keyEvent.getKey() == WatchUi.KEY_DOWN) {
            isVibrating = !isVibrating;
            view.setVibrating(isVibrating);
            
            if (isVibrating && currentBpm > 0) {
                startVibrating();
            } else {
                stopVibrating();
            }
            return true;
        }
        return false;
    }

    function calculateBpm() as Void {
        if (taps.size() > 1) {
            var diff = taps[taps.size() - 1] - taps[0];
            if (diff > 0) {
                var avgDiff = diff.toFloat() / (taps.size() - 1);
                if (avgDiff > 0) {
                    currentBpm = (60000.0 / avgDiff).toNumber();
                    view.setBpm(currentBpm);
                    
                    if (isVibrating) {
                        startVibrating();
                    }
                }
            }
        }
    }

    function onSelect() as Boolean {
        // Start/Stop button as an alternative BPM tap
        recordTap();
        return true;
    }

    function startVibrating() as Void {
        stopVibrating();
        if (currentBpm > 0) {
            var interval = 60000 / currentBpm;
            if (interval < 200) { interval = 200; }
            vibrateTimer.start(method(:vibrate), interval, true);
        }
    }

    function stopVibrating() as Void {
        vibrateTimer.stop();
    }

    function vibrate() as Void {
        if (Attention has :vibrate) {
            var vibeData = [new Attention.VibeProfile(100, 100)];
            Attention.vibrate(vibeData);
        }
        view.triggerPulse();
    }
}