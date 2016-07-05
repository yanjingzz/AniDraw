//
//  DanceMove.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation
import UIKit

public class DanceMove {
    
    var keyframes: [Keyframe]
    
    var totalTime: CFTimeInterval
    var currentPassTime : CFTimeInterval
    var currentFrameEndTime : CFTimeInterval
    var previousPosture: Posture

    var currentFrameINdex : Int
    init(kfs:[Keyframe], pos:CGPoint, prPosture: Posture) {
        keyframes = kfs
        currentFrameINdex = 0
        currentFrameEndTime = 0
        currentPassTime = 0
        totalTime = 0
        for kf in kfs  {
            totalTime += kf.time
        }
        currentFrameEndTime = kfs[0].time
        previousPosture = prPosture
    }
    
    
    func getPostureByIntervalTime(dtime:CFTimeInterval, nextDanceMove: DanceMove) -> Posture? {
        //prehandle dt
        var dt = dtime
        if currentPassTime + dt > totalTime {
            return nil
        }
        if currentPassTime + dt > currentFrameEndTime {
            currentFrameINdex += 1
            dt = currentPassTime + dt - currentFrameEndTime
            currentFrameEndTime += keyframes[currentFrameINdex].time
        }
        //prepare parameters
        var srcPosture : Posture
        var desPosture : Posture
        let positionCurve = keyframes[currentFrameINdex].positionCurve
        let angleCurve = keyframes[currentFrameINdex].angleCurve
        
        if currentFrameINdex == 0 {
            srcPosture = previousPosture
        } else {
            srcPosture = keyframes[currentFrameINdex-1].posture
        }
        desPosture = keyframes[currentFrameINdex].posture
        
        //get gesture
        
        return Posture(angles: calAngle(srcPosture.angles,dest: desPosture.angles, curve: angleCurve),
            position: calPosition(srcPosture.position, dest: desPosture.position, curve: positionCurve))
    }
    
    func calAngle(src:[BodyPartName: CGFloat],dest:[BodyPartName: CGFloat],curve:AngleCurve) -> [BodyPartName: CGFloat] {
        var angles = src
        //TODO
        switch curve {
        case .EaseInOut:
            angles = src
        case .EaseIn:
            angles = src
        case .EaseOut:
            angles = src
        case .Linear:
            angles = src
        default:
            angles = dest
        }
        return angles
    }
    
    func calPosition(src: CGPoint, dest: CGPoint, curve :PositionCurve) -> CGPoint {
        var position = src
        //TODO
        switch curve {
        case .EaseInOut:
            position = src
        case .EaseIn:
            position = src
        case .EaseOut:
            position = src
        case .Linear:
            position = src
        default:
            position = dest
        }
        return position
    }
}

