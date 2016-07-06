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

    var level : Int
    
    var currentFrameIndex : Int
    init(kfs:[Keyframe], prPosture: Posture,lev:Int = 0) {
        keyframes = kfs
        currentFrameIndex = 0
        currentFrameEndTime = 0
        currentPassTime = 0
        totalTime = 0
        for kf in kfs  {
            totalTime += kf.time
        }
        currentFrameEndTime = kfs[0].time
        previousPosture = prPosture
        level = lev
    }
    
    
    func getPostureByIntervalTime(dtime:CFTimeInterval) -> Posture? {
        //prehandle dt
        var dt = dtime
        if currentPassTime + dt > totalTime {
            return nil
        }
        if currentPassTime + dt > currentFrameEndTime {
            currentFrameIndex += 1
            dt = currentPassTime + dt - currentFrameEndTime
            currentFrameEndTime += keyframes[currentFrameIndex].time
        }
        currentPassTime += dt
        
        //prepare parameters
        var srcPosture : Posture
        var desPosture : Posture
        let positionCurve = keyframes[currentFrameIndex].positionCurve
        let angleCurve = keyframes[currentFrameIndex].angleCurve
        let ratio = CGFloat((keyframes[currentFrameIndex].time + currentPassTime - currentFrameEndTime)
            / keyframes[currentFrameIndex].time)
        if currentFrameIndex == 0 {
            srcPosture = previousPosture
        } else {
            srcPosture = keyframes[currentFrameIndex-1].posture
        }
        desPosture = keyframes[currentFrameIndex].posture
        
        //get gesture
        
        return Posture(angles: calAngle(srcPosture.angles,dest: desPosture.angles, curve: angleCurve,ratio: ratio),
            position: calPosition(srcPosture.position, dest: desPosture.position, curve: positionCurve,ratio: ratio))
    }
    
    func calAngle(src:[BodyPartName: CGFloat],dest:[BodyPartName: CGFloat],curve:Curve,ratio:CGFloat) -> [BodyPartName: CGFloat] {
        var angles = src
        let value = getCurveRatio(curve, ratio: ratio)
        for part in BodyPartName.allParts {
            if angles[part] != nil {
                angles[part] = angles[part]! + (dest[part]! - src[part]!) * value
            }
        }
        return angles
    }
    
    func calPosition(src: CGPoint, dest: CGPoint, curve :Curve,ratio:CGFloat) -> CGPoint {
        var position = src
        let value = getCurveRatio(curve, ratio: ratio)
        position = position + (dest - src) * value
        return position
    }
    
    func getCurveRatio(curve: Curve , ratio:CGFloat) -> CGFloat {
        //need expanding?
        var value : CGFloat = 0
        switch curve {
        case .EaseInOut:
            value = (ratio < 0.5 ? 2 * ratio * ratio : (-2 * ratio * ratio) + (4 * ratio) - 1)
        case .EaseIn:
            value = ratio * ratio
        case .EaseOut:
            value = -(ratio * (ratio - 2))
        case .Linear:
            value = ratio   // y = x, x in [0,1] , y in [0,1]
//        default:
//            break
        }
        return value
    }
}

