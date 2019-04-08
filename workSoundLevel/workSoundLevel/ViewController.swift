//
//  ViewController.swift
//  workSoundLevel
//
//  Created by Eva Philips on 4/7/19.
//  Copyright © 2019 evaphilips. All rights reserved.
//

import UIKit
//import Foundation
import AVFoundation
//import CoreAudio
//import AudioToolbox

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
//    // define recorder
//    var recorder = AVAudioRecorder()
//    // define timer
//    var timer = Timer()
//    // define work sound threshold
//    var threshold: Float = -10.0
    
    var timer: Timer?
    var recorder: AVAudioRecorder!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // requestion permission
        self.requestAuthorization()
        
        if self.recorder != nil {
            return
        }
        
        let url: NSURL = NSURL(fileURLWithPath: "/dev/null")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.recorder = try AVAudioRecorder(url: url as URL, settings: settings )
            self.recorder.delegate = self
            self.recorder.isMeteringEnabled = true
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.record)))
            
            self.recorder.record()
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshAudioView(_:)), userInfo: nil, repeats: true)
        } catch {
            print("Fail to record.")
        }
    }
    
    
    func requestAuthorization(){
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSessionRecordPermission.granted:
            print("Permission granted")
        case AVAudioSessionRecordPermission.denied:
            print("Pemission denied")
        case AVAudioSessionRecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
            // Handle granted
                print("The sound level:")
            })
        }
    }
    
    @objc internal func refreshAudioView(_: Timer) {
        recorder.updateMeters()
        
        let level = recorder.averagePower(forChannel: 0)
        print("Level Number: ", level)
        if(level < -30){
            levelLabel.text = "Low"
            self.view.backgroundColor = .green
            descriptionLabel.text = "Looks like you are in a good spot, time to get to work!"
        }else if(level < -20){
            levelLabel.text = "Medium"
             self.view.backgroundColor = .yellow
            descriptionLabel.text = "Looks like it is getting a little noisy. If you are getting distracted think about moving locations."
        }else{
            levelLabel.text = "High"
            self.view.backgroundColor = .red
            descriptionLabel.text = "Looks like it is very loud around you, time to find a new spot"
            
        }
    }

    
       


}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}


















