import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Attention;
import Toybox.Lang;

class QuickTunerView extends WatchUi.View {
    private var _frequencies as Array<Dictionary>;
    private var _currentIndex as Number;
    private var _isPlaying as Boolean;
    private var _timer as Timer.Timer;

    function initialize() {
        View.initialize();
        
        // Standard middle octave notes and their frequencies
        _frequencies = [
            {:note => "C", :freq => 261.63},
            {:note => "D", :freq => 293.66},
            {:note => "E", :freq => 329.63},
            {:note => "F", :freq => 349.23},
            {:note => "G", :freq => 392.0},
            {:note => "A", :freq => 440.0},
            {:note => "B", :freq => 493.88},
            {:note => "C", :freq => 523.25}
        ];
        
        _currentIndex = 5; // Default to A (440Hz)
        _isPlaying = false;
        _timer = new Timer.Timer();
    }

    function onLayout(dc as Graphics.Dc) as Void {
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var currentNote = _frequencies[_currentIndex] as Dictionary;

        dc.drawText(width / 2, height / 2 - 40, Graphics.FONT_LARGE, currentNote[:note] as String, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(width / 2, height / 2, Graphics.FONT_MEDIUM, (currentNote[:freq] as Float).format("%.0f") + " Hz", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        if (_isPlaying) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width / 2, height / 2 + 50, Graphics.FONT_SMALL, "PLAYING", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        } else {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width / 2, height / 2 + 50, Graphics.FONT_SMALL, "STOPPED", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        
        // Draw control hints
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 10, Graphics.FONT_XTINY, "UP/DOWN: Change", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, height - 30, Graphics.FONT_XTINY, "START: Play/Stop", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onHide() as Void {
        stopNote();
    }

    function nextNote() as Void {
        if (_currentIndex < _frequencies.size() - 1) {
            _currentIndex++;
            updatePlayback();
            WatchUi.requestUpdate();
        }
    }

    function prevNote() as Void {
        if (_currentIndex > 0) {
            _currentIndex--;
            updatePlayback();
            WatchUi.requestUpdate();
        }
    }

    function togglePlay() as Void {
        if (_isPlaying) {
            stopNote();
        } else {
            startNote();
        }
        WatchUi.requestUpdate();
    }

    function updatePlayback() as Void {
        if (_isPlaying) {
            _timer.stop();
            playCurrentTone(); // Push the newly selected note into playback instantly
            _timer.start(method(:playCurrentTone), 2000, true);
        }
    }

    function startNote() as Void {
        if (!_isPlaying) {
            _isPlaying = true;
            playCurrentTone();
            _timer.start(method(:playCurrentTone), 2000, true); 
        }
    }

    function stopNote() as Void {
        if (_isPlaying) {
            _isPlaying = false;
            _timer.stop();
        }
    }

    function playCurrentTone() as Void {
        if (Attention has :ToneProfile) {
            var currentNote = _frequencies[_currentIndex] as Dictionary;
            var freq = currentNote[:freq] as Float;
            // ToneProfile requires an integer, so we cast the float to a Number
            var toneProfile = [new Attention.ToneProfile(freq.toNumber(), 2000)] as Array<Attention.ToneProfile>;
            Attention.playTone({:toneProfile => toneProfile});
        }
    }
}