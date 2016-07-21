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
    let danceMoveList = GenericMoves.dict
    let dancePlayback = DancePlayback()
    var dataSet : [[CGFloat]] = []
    var bpm: Double?
    var level = 0
    
    private struct Constants {
        static let peakAmplitudeThreshold : CGFloat = -25
        static let averageAmplitudeThreshold : CGFloat = -30
        static let durationThreshold : CFTimeInterval = 0.8
        static let pitchScope : CGFloat = 5
    }
    
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
    
    func chooseMethod() -> (Int,Int) {
        //TODO: set model
        
        let array = danceMoveList[level]
        let max = array?.count ?? 0
        let index = Int.random(max)
        return (level,index)
    
    }
    
    
    func startNewDanceMove(withPitch pitch: Float, decibel: Float, bpm: Float) {
        var pitch_index = log(pitch)
        pitch_index = pitch_index < 0 ? 0 : pitch_index
        let decibel_index = (decibel+70) / 14
        let level = Int(pitch_index * decibel_index / 8).clamped(1, 5)
        print("start new dance move \(pitch_index) \(decibel_index) \(bpm): \(level)")
        
        if self.level != level || dancePlayback.isReturningIdle {
            self.level = level
            let (_, index) = chooseMethod()
            dancePlayback.startDanceMove(danceMoveList[level]?[index])
        }
    }
    
    func receiverDidReceiveData(data: ReceiverData!) {

        if data.onset != 0 {
            startNewDanceMove(withPitch: data.pitch, decibel: data.decibel, bpm: data.bpm)
        }
        if data.isSinging == false {
            level = 0
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


