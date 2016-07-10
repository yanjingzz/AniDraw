//
//  AudioInput.swift
//  AniDraw
//
//  Created by Mike on 7/8/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation
import AudioKit

class AudioInput {
    private let mic =  AKMicrophone()
    
    private let silence: AKBooster
    let level: Int = 0
    let tracker: AKFrequencyTracker
    var delegate: AudioInputChangedDelegate?
    
    init() {
        AKSettings.audioInputEnabled = true
        tracker = AKFrequencyTracker(mic, minimumFrequency: 200, maximumFrequency: 2000)
        silence = AKBooster(tracker, gain: 0)
        
        
    }
    var lastFrequency: Double?
    var amplitude: Double {
        if tracker.amplitude > amplitudeThreshold {
            return tracker.amplitude
        } else {
            return 0
        }
    }
    var isSinging = false
    private var startSingingTime: NSDate?
    var singingDuration: NSTimeInterval? {
        if isSinging {
            let date = NSDate()
            return date.timeIntervalSinceDate(startSingingTime!)
        } else {
                return nil
        }
    }
    let amplitudeThreshold = 0.005
    func start() {
        AudioKit.output = silence
        AudioKit.start()
    }
    func stop() {
        AudioKit.stop()
    }
    func update() {
        tracker.frequency
        print (tracker.amplitude)
        if isSinging == false && tracker.amplitude > amplitudeThreshold {
            isSinging = true
            startSingingTime = NSDate()
            
        }
        if isSinging == true {
            if tracker.amplitude < amplitudeThreshold &&  tracker.frequency != lastFrequency {
                isSinging = false
            }
        }
        lastFrequency = tracker.frequency
        delegate?.audioInputChanged(self)
    }
}
protocol AudioInputChangedDelegate {
    func audioInputChanged(audioInput: AudioInput)
}