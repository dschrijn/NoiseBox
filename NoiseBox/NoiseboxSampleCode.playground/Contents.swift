
import UIKit
import AVFoundation

//////////////////////////
// Noisebox Sample Code //
//////////////////////////

// Custom Siider //

@IBDesignable
class CustomSlider: UISlider {
    
    @IBInspectable var thumbImage: UIImage? {
        didSet {
            setThumbImage(thumbImage, for: .normal)
        }
    }
    
    @IBInspectable var thumbHL: UIImage? {
        didSet {
            setThumbImage(thumbHL, for: .highlighted)
        }
    }
    
    @IBInspectable var trackHeight: CGFloat = 130
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.width = trackHeight
        return newRect
    }
}

// Functions //

var recordedAudioURL: URL!
var audioFile: AVAudioFile!
var audioEngine: AVAudioEngine!
var audioPlayerNode: AVAudioPlayerNode!
var buffer: AVAudioPCMBuffer!
var audioRecorder: AVAudioRecorder!
var isRecording: Bool = false

struct Alerts {
    static let DismissAlert = "Dismiss"
    static let RecordingDisabledTitle = "Recording Disabled"
    static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
    static let RecordingFailedTitle = "Recording Failed"
    static let RecordingFailedMessage = "Something went wrong with your recording."
    static let AudioRecorderError = "Audio Recorder Error"
    static let AudioSessionError = "Audio Session Error"
    static let AudioRecordingError = "Audio Recording Error"
    static let AudioFileError = "Audio File Error"
    static let AudioEngineError = "Audio Engine Error"
}

func recordStartStop(_sender: UIButton) {
    if isRecording == false {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        } catch {
            fatalError("Setup did not complete and ended with errors.")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        } catch {
            fatalError("Audio recorder did not complete.")
        }
        //audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        isRecording = true
    } else {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
            fatalError("Session did not pass data.")
        }
        
        isRecording = false
    }
}

func setupAudio() {

    do {
        audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
    } catch {
        showAlert(Alerts.AudioFileError, message: String(describing: error))
    }
    
    buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
    
    do {
        try audioFile.read(into: buffer)
    } catch {
        fatalError("Error: Audio file did not process.")
    }
    
}

func showAlert(_ title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
    //self.present(alert, animated: true, completion: nil)
}

func connectAudioNodes(_ nodes: AVAudioNode...) {
    for x in 0..<nodes.count-1 {
        audioEngine.connect(nodes[x], to: nodes[x+1], format: buffer.format)
    }
}



