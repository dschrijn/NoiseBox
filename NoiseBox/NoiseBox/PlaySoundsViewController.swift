//
//  PlaySoundsViewController.swift
//  NoiseBox
//
//  Created by David A. Schrijn on 9/8/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // Mark: Variables
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    // Mark: Enums
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb, robot, alien, you
    }
    
    // Mark: IBOutlets
    
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton:UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var robotButton: UIButton!
    
    @IBOutlet weak var alienButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    //Mark: IBActions
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -650)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        case .robot:
            playSound(robot: true)
        case .alien:
            playSound(alien: true)
        case .you:
            playSound(you: true)
        }
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopAudio()
    }
    
    // Mark: App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notPlaying)
    }
    
    
}
