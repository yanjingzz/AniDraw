//
//  DanceModel.swift
//  AniDraw
//
//  Created by younn on 16/7/5.
//  Copyright © 2016年 yanjingzz. All rights reserved.
//

import Foundation
import Darwin
import Beethoven
import Pitchy
import AVFoundation

public class DanceModel :  AudioInputChangedDelegate {
//    PitchEngineDelegate,
    let danceMoveList = MovesStorage.allMoves
    
    var currentDanceMove : DanceMove
    var idleDanceMove : DanceMove
    var currentAbsolutePosition : CGPoint
    var dataSet : [[CGFloat]] = []

//    var timerPitch : CGFloat = 0
    var pitch : CGFloat = 0
    var amplitude : CGFloat = 0
//    var averageAmplitude : CGFloat = 0
//    var startSingingTime: CFTimeInterval?
//    var duration : CFTimeInterval = 0
//    var tempo : CFTimeInterval = 0
    
//    var needIdle : Boolean = false
    var isSinging : Boolean = false
    
    func audioInputChanged(audioInput: AudioInput) {
        isSinging = audioInput.isSinging
        if !isSinging {
            abortDanceMove()
        } else {
            amplitude = CGFloat(audioInput.tracker.amplitude)
            pitch = CGFloat(audioInput.tracker.frequency)
        }
    }
    
//    lazy var pitchEngine: PitchEngine = { [unowned self] in
//        let pitchEngine = PitchEngine(delegate: self)
//        return pitchEngine
//        }()
//    
//    var recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
//        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
//        AVNumberOfChannelsKey : NSNumber(int: 1),
//        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
//    
//    
//    var audioRecorder:AVAudioRecorder!

    private struct Constants {
        static let peakAmplitudeThreshold : CGFloat = -25
        static let averageAmplitudeThreshold : CGFloat = -30
        static let durationThreshold : CFTimeInterval = 0.8
        static let pitchScope : CGFloat = 5
    }
    
    //TODO
//    var DanceMoveData1 : [CGFloat] =
//    [1,3,
//    0.4,0,0,0,0,
//        0.2,0,0,0,0,0,0,0,0,0,0,0,0,
//    0.8,0,0,0,0,
//        -0.2,0,0,0,0,0,0,0,0,0,0,0,0,
//    0.4,0,0,0,0,
//        0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    init(center: CGPoint) {
        //init idleDanceMove
        var kfs : [Keyframe] = []
        let idleKeyFrame = Keyframe(time: 0.5, posture: Posture.idle, angleCurve: .Linear, positionCurve: .Linear)

        kfs.append(idleKeyFrame)
        idleDanceMove = DanceMove(keyframes: kfs, previousPosture: Posture.idle)
        
        currentDanceMove = idleDanceMove
        currentAbsolutePosition = center
        
        //for naive test
//        dataSet.append(DanceMoveData1)
//        dataSet.append(DanceMoveData2)
//        dataSet.append(DanceMoveData3)
//        dataSet.append(DanceMoveData4)
//        dataSet.append(DanceMoveData5)
        
//        loadDanceMove(dataSet)
//        print("idleDanceMove")
//        print(idleDanceMove.currentFrameIndex)
//        print(idleDanceMove.currentPassTime)
//        print(idleDanceMove.currentFrameEndTime)
//        print(idleDanceMove.totalTime)
//        
//        pitchEngine.start()
//        
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,
//                settings: recordSettings)
//            audioRecorder.prepareToRecord()
//        } catch {
//        }
//        
//        if !audioRecorder.recording {
//            let audioSession = AVAudioSession.sharedInstance()
//            do {
//                try audioSession.setActive(true)
//                audioRecorder.meteringEnabled = true
//                audioRecorder.record()
//            } catch {
//            }
//        }
    }
    
//    func directoryURL() -> NSURL? {
//        let fileManager = NSFileManager.defaultManager()
//        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let documentDirectory = urls[0] as NSURL
//        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
//        return soundURL
//    }

    
    func getPostureByIntervalTime(dtime:CFTimeInterval) -> Posture {
        var nextposture = currentDanceMove.getPostureByIntervalTime(dtime)
        if nextposture == nil {
            pickNextDanceMove()
            nextposture = currentDanceMove.getPostureByIntervalTime(dtime)
        }
        nextposture?.position = (nextposture?.position)! + currentAbsolutePosition
        return nextposture!
    }
    
    func pickNextDanceMove() {
        //reset currentDanceMove
        currentDanceMove.reset()
        
        let changePosture = currentDanceMove.keyframes[currentDanceMove.keyframes.count-1].posture

//        print("pitch:\(pitch)")
//        print("amplitude:\(amplitude)")
        
        let (level,index) = chooseMethod()
        print("\(amplitude) \(pitch) \(level)")
        if level == 0 {
            currentDanceMove = idleDanceMove
        } else {
            currentDanceMove = danceMoveList[level]![index]
        }
        currentDanceMove.previousPosture = changePosture
        
    }
    
    func abortDanceMove() {
        let currentPosture = currentDanceMove.getPostureByIntervalTime(0)
        currentDanceMove.reset()
        currentDanceMove = idleDanceMove
        currentDanceMove.previousPosture = currentPosture!
//        print("Abortion!")
    }
    
    func convertDataToDanceMove(data : [CGFloat]) -> DanceMove {
        var kfs : [Keyframe] = []
        let kfNumber = Int(data[1])
        
        for index in 0..<kfNumber {
            let base = 2 + index * 18
            var angles = [BodyPartName : CGFloat]()
            var subIndex = 5
            for part in BodyPartName.allParts {
                angles[part] = data[base + subIndex]
                subIndex += 1
            }
            let posture = Posture(angles: angles, position:CGPoint(x: data[base+3], y: data[base+4]))
            
            let kf = Keyframe(time: CFTimeInterval(data[base]), posture: posture, angleCurve: Keyframe.Curve(rawValue: Int(data[base+1]))!, positionCurve: Keyframe.Curve(rawValue: Int(data[base+2]))!)
            kfs.append(kf)
        }
        
        return DanceMove(keyframes: kfs, previousPosture: Posture.idle, levelOfIntensity: Int(data[0]))
    }
    
//    func loadDanceMove(dataSet : [[CGFloat]]){
//        danceMoveList = MovesStorage.allMoves
//        print("danceMoveList:\(danceMoveList.count)")
//
//    }
//    
//    public func pitchEngineDidRecievePitch(pitchEngine: PitchEngine, pitch: Pitch) {
//        self.timerPitch = CGFloat(pitch.frequency)
//    }
//    
//    public func pitchEngineDidRecieveError(pitchEngine: PitchEngine, error: ErrorType) {
//        print(error)
//    }
//    
//    //update Amplitude(Peak,Average), pitch , tempo , needIdle, isSing
//    func updateStatic(dt: CFTimeInterval) {
//        
////        audioRecorder.updateMeters()
////        peakAmplitude = CGFloat(audioRecorder.peakPowerForChannel(0))
////        averageAmplitude = CGFloat(audioRecorder.averagePowerForChannel(0))
//        
//        if peakAmplitude < Constants.peakAmplitudeThreshold && averageAmplitude < Constants.averageAmplitudeThreshold {
//            if currentDanceMove.level != 0 {
//                needIdle = true
//            }
//            tempo = 0
//            duration = 0
//        } else {
//            duration = duration + dt
//            if abs(pitch - timerPitch) < Constants.pitchScope {
//                tempo = tempo + dt
//            } else {
//                tempo = 0
//            }
//        }
//        if duration < Constants.durationThreshold {
//            isSing = false
//        } else {
//            isSing = true
//        }
//        pitch = timerPitch
//    }
//    
    func chooseMethod() -> (Int,Int) {
        //TODO set module
//        let value = UInt32(DanceMoveList.count + 1)
//        let result = Int(arc4random_uniform(value)) - 1
//        //        print("choose result: \(result)")
//        return result
        if isSinging == false {
            return (0,0)
        } else {
            
//            if duration > 0 {
//                //TODO
//            }
            
            let level = Int(round((log(amplitude)) + 5) * 1.2).clamped(1, 5)
            let suitDanceMoveArray = danceMoveList[level]
            let value = UInt32(suitDanceMoveArray!.count)
            let index = Int(arc4random_uniform(value))

//            print("method result: level:\(level) index:\(index)")
            return (level,index)
        }
    }
}

//Data structure:
//property part:
//1:dancemovelevel(default:1~5)
//data part:
//2:Keyframes' number
//(3~20)*N:each Keyframe {
//    time
//    angleCurveIndex
//    posCurveIndex
//    position.x
//    position.y
//    angles.Head
//    angles.UpperBody
//    angles.LowerBody
//    angles.LeftUpperArm
//    angles.LeftForearm
//    angles.LeftThigh
//    angles.LeftShank
//    angles.LeftFoot
//    angles.RightUpperArm
//    angles.RightForearm
//    angles.RightThigh
//    angles.RightShank
//    angles.RightFoot
//}


