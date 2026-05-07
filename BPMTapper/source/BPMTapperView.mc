import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Timer;

class BPMTapperView extends WatchUi.View {
    
    private var bpm as Number = 0;
    private var isVibrating as Boolean = false;
    private var showPulse as Boolean = false;
    private var pulseTimer as Timer.Timer;

    function initialize() {
        View.initialize();
        pulseTimer = new Timer.Timer();
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
    }

    function onHide() as Void {
        pulseTimer.stop();
    }

    function onUpdate(dc as Dc) as Void {
        if (showPulse) {
            dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_DK_GREEN);
        } else {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        }
        dc.clear();
        
        var text = bpm.toString() + " BPM\n\n" + (isVibrating ? "Vibration: ON" : "Vibration: OFF");

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function setBpm(newBpm as Number) as Void {
        bpm = newBpm;
        WatchUi.requestUpdate();
    }

    function setVibrating(vibrating as Boolean) as Void {
        isVibrating = vibrating;
        WatchUi.requestUpdate();
    }

    function triggerPulse() as Void {
        showPulse = true;
        WatchUi.requestUpdate();
        pulseTimer.start(method(:clearPulse), 100, false);
    }

    function clearPulse() as Void {
        showPulse = false;
        WatchUi.requestUpdate();
    }
}