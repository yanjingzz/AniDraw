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

class DanceModel: NSObject, MyAudioReceiverDelegate {
//    let danceMoveList = MovesStorage.AllMoves
    let danceMoveList = Moves.dictOfStyle(.Ballet)
    let dancePlayback = DancePlayback()
    let beatTracker = BeatTracker(total: Const.BeatTrackerTotal)
    var dataSet : [[CGFloat]] = []
    var currentTempo = Const.OriginalTempo
    var lastOnset: NSTimeInterval?
    var lastEnd: NSTimeInterval?
    var isSinging = false
    var currentPitch = 0.0
    var currentDecibel = 0.0
    var currentLevel = 0
    var currentIndex = -1
    
    var lastIndex: [Int?] = Array<Int?>(count: 6, repeatedValue: nil)
    
    
    var currentTimeFactor: Double {
        
//        var factor = currentTempo / Const.OriginalTempo
//        while factor > sqrt(2.0) {
//            factor /= 2
//        }
//        while factor <= sqrt(0.5) {
//            factor *= 2
//        }
//
//        return factor
        return 1
        
    }
    
    func getPostureByIntervalTime(dtime:CFTimeInterval) -> Posture {
        if let posture = dancePlayback.getPostureByIntervalTime(dtime * currentTimeFactor) {
            return posture
        }
        if isSinging {
            if let keyframes = danceMoveList[currentLevel]?[currentIndex].keyframes where !keyframes.isEmpty {
                dancePlayback.startDanceMove(keyframes)
                return dancePlayback.getPostureByIntervalTime(dtime * currentTimeFactor)!
            }
            
        } else {
            dancePlayback.startDanceMove([Keyframe.idle])
            if let posture = dancePlayback.getPostureByIntervalTime(dtime * currentTimeFactor) {
                return posture
            }
        }
        return dancePlayback.currentPosture
    }
    
    private struct Const {
        static let MaxLevel = 5
        static let PitchHigherBound = 7.0
        static let PitchLowerBound = 4.5
        static let PitchRange = Const.PitchHigherBound - Const.PitchLowerBound
        static let DecibelHigherBound = -5.0
        static let DecibelLowerBound = -50.0
        static let DecibelRange = Const.DecibelHigherBound - Const.DecibelLowerBound
        static let BeatTrackerTotal = 20
        static let DurationThreshold = 0.1
        static let OriginalTempo = 0.5
    
    }
    
    private func pickLevel(withPitch pitch: Double, decibel: Double) -> Int{
        var pitch_index: Double = log(pitch)
        pitch_index = (pitch_index-Const.PitchLowerBound) * Double(Const.MaxLevel) / Const.PitchRange
        pitch_index > Double(Const.MaxLevel) + 1 ? 0 : pitch_index
        
        let decibel_index = (decibel - Const.DecibelLowerBound) * Double(Const.MaxLevel) / Const.DecibelRange
        
        let level = Int(max(pitch_index, decibel_index)).clamped(1, 5)
        print("pick level: pitch \(pitch_index) decibel \(decibel_index): \(level)")
        return level
        
    }
    
    func pickIndex(level: Int) -> Int? {
        
        let array = danceMoveList[level]
        let max = array?.count ?? 0
        if max == 1 {
            return 0
        } else if max == 0 {
            return nil
        }
        var index = Int.random(max - 1)
        if index >= lastIndex[level] {
            index += 1
        }
        print("pick index: max \(max): \(index)")
        
        return index
    
    }
    
    
    
    func startNewDanceMove(withPitch pitch: Float, decibel: Float, bpm: Float) {
        
        let level = pickLevel(withPitch: Double(pitch), decibel: Double(decibel))
        if dancePlayback.isEnding {
            currentLevel = level
            if let index = pickIndex(level) {
                currentIndex = index
                lastIndex[level] = index
                if var kfs = danceMoveList[level]?[index].keyframes where !kfs.isEmpty {
                    // flip the keyframes if moving off stage
                    let nextX = kfs.last!.posture.position.x
                    let currentX = dancePlayback.currentPosture.position.x
                    if  nextX * currentX > 0 {
                        kfs = kfs.flipped
                    }
                    
                    dancePlayback.startDanceMove(kfs)
                    
                }
            }
        }
    }
    
    
    func receiverDidReceiveData(data: ReceiverData!) {
        
        if isSinging == false && data.isSinging == true { // onset
            print("onset")
            startNewDanceMove(withPitch: data.pitch, decibel: data.decibel, bpm: data.bpm)
            
            if lastOnset != nil {
                if lastEnd == nil || lastEnd! <= lastOnset! {
                    lastEnd = data.time
                }
                let lastDuration = lastEnd! - lastOnset!
                let newInterval = data.time - lastOnset!
                print("\(data.time), \(data.time - lastOnset!), \(lastDuration)")
                if lastDuration > Const.DurationThreshold {
                    currentTempo = beatTracker.updateByAppend(newInterval)
                    lastOnset = data.time
                } else {
                    currentTempo = beatTracker.updateByAddToLast(newInterval)
                }
                
            }
            
            lastOnset = data.time
            
        }
        
        if data.isSinging == false {
            if isSinging == true {
                currentLevel = 0
                currentIndex = -1
                lastEnd = data.time
                isSinging = false
            }
            currentPitch = 0.0
            currentDecibel = 0.0
        } else {
            currentPitch = Double(data.pitch)
            currentDecibel = Double(data.decibel)
        }
        
        isSinging = data.isSinging
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


