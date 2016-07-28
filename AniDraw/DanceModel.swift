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
    let maleMoveList = Moves.dictOfStyle(.HipHop)
    let femaleMoveList = Moves.dictOfStyle(.Ballet)
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
    var currentStyle: DanceStyle {
        return (pitchAverage ?? currentPitch) > Const.pitchLogThreshold ? .Ballet : .HipHop
    }
    var currentMove: [Keyframe]?
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
            if let keyframes = currentMove where !keyframes.isEmpty {
                startWithFlipped(keyframes)
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
        
        static let DecibelHigherBound = -5.0
        static let DecibelLowerBound = -50.0
        static let DecibelRange = Const.DecibelHigherBound - Const.DecibelLowerBound
        static let BeatTrackerTotal = 20
        static let DurationThreshold = 0.1
        static let OriginalTempo = 0.5
        static let pitchLogThreshold = log(261.6) //C4
        static let pitchLogMax = log(1046.50) //C6
        static let pitchLogFemaleMin = log(220.00) //A3
        static let maxPitchNum = 20
    
    }
    
    
    // all log(pitch)
    var pitchHigherBound: Double? { return  lastPitches.maxElement() }
    var pitchLowerBound: Double? { return  lastPitches.minElement() }
    var pitchRange: Double? {
        guard let min = pitchLowerBound, let max = pitchHigherBound else {
            return nil
        }
        return max - min
    }
    var lastPitches = [Double]()
    var pitchAverage: Double? {
        if lastPitches.isEmpty {
            return nil
        }
        return lastPitches.reduce(0.0, combine: +) / Double(lastPitches.count)
    }
    
    private func pickLevel(withPitch pitch: Double, decibel: Double) -> Int{
        let pitchIndex = updatePitch(pitch)
        
        let decibel_index = (decibel - Const.DecibelLowerBound) * Double(Const.MaxLevel) / Const.DecibelRange
        
        let level = pitchIndex
        print("pick level: pitch \(pitchIndex) decibel \(decibel_index): \(level)")
        return level
        
    }
    
    func updatePitch(pitch: Double) -> Int {
        var pitch_index: Double = log(pitch)
        if lastPitches.isEmpty {
            if pitch_index < Const.pitchLogThreshold {
                lastPitches.append(0.0)
                lastPitches.append(Const.pitchLogThreshold)
            } else {
                lastPitches.append(Const.pitchLogFemaleMin)
                lastPitches.append(Const.pitchLogMax)
            }
        }
        if let ave = pitchAverage where pitch_index > ave + Const.pitchLogThreshold {
            return 1
        }
        lastPitches.append(pitch_index)
        while lastPitches.count > Const.maxPitchNum {
            lastPitches.removeFirst()
        }
        
        if let range = pitchRange where range != 0 {
            pitch_index = (pitch_index-pitchLowerBound!) * Double(Const.MaxLevel) / range
            return Int(round(pitch_index)).clamped(1,Const.MaxLevel)
        } else {
            return 1
        }
        
    }
    
    func pickMove(level: Int) -> [Keyframe]? {
        let array = Moves.ofStyle(currentStyle, withLevel: level)
        guard let moves = array where !moves.isEmpty else {
            return nil
        }
        let max = moves.count
        if max == 1 {
            return moves.first!.keyframes
        }
        
        var index = Int.random(max - 1)
        if index >= lastIndex[level] {
            index += 1
        }
        currentIndex = index
        lastIndex[level] = index
        currentMove = moves[index].keyframes
        print("pick index: max \(max): \(index)")
        
        return currentMove
    
    }
    
    
    
    func startNewDanceMove(withPitch pitch: Float, decibel: Float, bpm: Float) {
        let level = pickLevel(withPitch: Double(pitch), decibel: Double(decibel))
        if dancePlayback.isEnding {
            currentLevel = level
            if let keyframes = pickMove(level) where !keyframes.isEmpty {
                startWithFlipped(keyframes)
            }
        }
    }
    
    private func startWithFlipped (keyframes: [Keyframe]) {
        // flip the keyframes if moving off stage
        let nextX = keyframes.last!.posture.position.x
        let currentX = dancePlayback.currentPosture.position.x
        if  nextX * currentX > 0 {
            dancePlayback.startDanceMove(keyframes.flipped)
        } else {
            dancePlayback.startDanceMove(keyframes)
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
//                currentLevel = 0
//                currentIndex = -1
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


