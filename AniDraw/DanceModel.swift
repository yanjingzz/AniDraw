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

public class DanceModel : PitchEngineDelegate{
    var DanceMoveList = [Int:[DanceMove]]()
    
    var currentDanceMove : DanceMove
    var idleDanceMove : DanceMove
    var currentAbsolutePosition : CGPoint
    var dataSet : [[CGFloat]] = []

    var pitch : CGFloat = 0
    var amplitude : CGFloat = 0
    lazy var pitchEngine: PitchEngine = { [unowned self] in
        let pitchEngine = PitchEngine(delegate: self)
        return pitchEngine
        }()
    
    var recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
        AVNumberOfChannelsKey : NSNumber(int: 1),
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
    
    
    var audioRecorder:AVAudioRecorder!

    
    //TODO
    var DanceMoveData1 : [CGFloat] =
    [1,3,
    0.4,0,0,0,0,
        0.4,0,0,0,0,0,0,0,0,0,0,0,0,
    0.8,0,0,0,0,
        -0.4,0,0,0,0,0,0,0,0,0,0,0,0,
    0.4,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    var DanceMoveData2 : [CGFloat] = []
    var DanceMoveData3 : [CGFloat] = []
    var DanceMoveData4 : [CGFloat] = []
    var DanceMoveData5 : [CGFloat] = []

    
    init(center: CGPoint) {
        //init idleDanceMove
        var kfs : [Keyframe] = []
        let idleKeyFrame = Keyframe(time: 0.5, posture: Posture.idle, angleCurve: .Linear, postureCurve: .Linear)
        kfs.append(idleKeyFrame)
        idleDanceMove = DanceMove(keyframes: kfs, previousPosture: Posture.idle)
        currentDanceMove = idleDanceMove
        currentAbsolutePosition = center
        
        //for naive test
        dataSet.append(DanceMoveData1)
//        dataSet.append(DanceMoveData2)
//        dataSet.append(DanceMoveData3)
//        dataSet.append(DanceMoveData4)
//        dataSet.append(DanceMoveData5)
        
        loadDanceMove(dataSet)
//        print("idleDanceMove")
//        print(idleDanceMove.currentFrameIndex)
//        print(idleDanceMove.currentPassTime)
//        print(idleDanceMove.currentFrameEndTime)
//        print(idleDanceMove.totalTime)
        
        pitchEngine.start()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,
                settings: recordSettings)
            audioRecorder.prepareToRecord()
        } catch {
        }
        
        if !audioRecorder.recording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.meteringEnabled = true
                audioRecorder.record()
            } catch {
            }
        }
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
        return soundURL
    }

    
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
        
        let level = chooseMethod()
        if level == 0 {
            currentDanceMove = idleDanceMove
        } else {
            let suitDanceMoveArray = DanceMoveList[level]
            let value = UInt32(suitDanceMoveArray!.count)
            let result = Int(arc4random_uniform(value))
            currentDanceMove = suitDanceMoveArray![result]
            print("change to \(level):\(result)")
        }
        currentDanceMove.previousPosture = changePosture
        
        
    }
    
    func loadDanceMove(dataSet : [[CGFloat]]){
//[for 2D array]
//        var count = 0
//        for data in dataSet{
//            var kfs : [Keyframe] = []
//            let kfNumber = Int(data[1])
//
//            for index in 0..<kfNumber {
//                let base = 2 + index * 18
//                var angles = [BodyPartName : CGFloat]()
//                var subIndex = 5
//                for part in BodyPartName.allParts {
//                    angles[part] = data[base + subIndex]
//                    subIndex += 1
//                }
//                let posture = Posture(angles: angles, position:CGPoint(x: data[base+3], y: data[base+4]))
//                
//                let kf = Keyframe(time: CFTimeInterval(data[base]), posture: posture, angleCurve: Keyframe.Curve(rawValue: Int(data[base+1]))!, postureCurve: Keyframe.Curve(rawValue: Int(data[base+2]))!)
//                kfs.append(kf)
//            }
//            
//            let danceMove : DanceMove
//            if count == 0 {
//                danceMove = DanceMove(keyframes: kfs, previousPosture: Posture.idle,levelOfIntensity:Int(data[0]))
//            } else {
//                danceMove = DanceMove(keyframes: kfs, previousPosture: DanceMoveList[count-1].keyframes[0].posture, levelOfIntensity:Int(data[0]))
//            }
//            count += 1
//            DanceMoveList.append(danceMove)
//        }
        DanceMoveList = MovesStorage.allMoves

    }
    
    public func pitchEngineDidRecievePitch(pitchEngine: PitchEngine, pitch: Pitch) {
        self.pitch = CGFloat(pitch.frequency)
    }
    
    public func pitchEngineDidRecieveError(pitchEngine: PitchEngine, error: ErrorType) {
        print(error)
    }
    
    func chooseMethod() -> Int {
        //TODO set module
//        let value = UInt32(DanceMoveList.count + 1)
//        let result = Int(arc4random_uniform(value)) - 1
//        //        print("choose result: \(result)")
//        return result
        
        if(amplitude < -10) {
            return 0
        } else {
            
            let level = 5 - Int(amplitude / 2)
            return level
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


