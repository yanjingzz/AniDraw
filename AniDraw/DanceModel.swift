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
    let danceMoveList = Moves.dictOfStyle(.Generic)
    let dancePlayback = DancePlayback()
    var dataSet : [[CGFloat]] = []
    var bpm: Double?
    var currentLevel = 0
    var currentIndex = -1
    
    var lastIndex: [Int?] = Array<Int?>(count: 6, repeatedValue: nil)
    
    
//    func currentTimeFactor() -> Double {
//        guard let expectedBPM = bpm else {
//            return 1
//        }
//        let realBPM = 60 / currentDanceMove.totalTime
//        
//        var factor = realBPM / expectedBPM
//        while factor > 2 {
//            factor /= 2
//        }
//        while factor <= 0.5 {
//            factor *= 2
//        }
//
//        return factor
//        
//    }
    
    func getPostureByIntervalTime(dtime:CFTimeInterval) -> Posture {
        return dancePlayback.getPostureByIntervalTime(dtime)
    }
    
    private struct Const {
        static let MaxLevel = 5
        static let PitchHigherBound = 7.0
        static let PitchLowerBound = 4.5
        static let PitchRange = Const.PitchHigherBound - Const.PitchLowerBound
        static let DecibelHigherBound = -5.0
        static let DecibelLowerBound = -50.0
        static let DecibelRange = Const.DecibelHigherBound - Const.DecibelLowerBound
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
                if let kfs = danceMoveList[level]?[index].keyframes where !kfs.isEmpty {
                    if dancePlayback.currentPosture.position.x * kfs.last!.posture.position.x > 0 {
                        dancePlayback.replaceKeysAfterCurrentKeyTo(kfs.flipped)
                    } else {
                        dancePlayback.replaceKeysAfterCurrentKeyTo(kfs)
                    }
                }
                
            }
        }
    }
    
    func receiverDidReceiveData(data: ReceiverData!) {

        if data.onset != 0 {
            startNewDanceMove(withPitch: data.pitch, decibel: data.decibel, bpm: data.bpm)
        }
        if data.isSinging == false {
            currentLevel = 0
            currentIndex = -1
            print("abort")
            dancePlayback.abort()
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


