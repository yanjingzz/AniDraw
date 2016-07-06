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
    
    init(keyframes kfs:[Keyframe],previousPosture prPosture: Posture,levelOfIntensity lev:Int = 0) {
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
    convenience init(keyframes kfs:[Keyframe], levelOfIntensity lev:Int = 0) {
        self.init(keyframes: kfs,previousPosture: Posture.idle,levelOfIntensity: lev)
    }
    
    convenience init(withSeriesOfPostures postures: [Posture], ofEqualInterval dt: NSTimeInterval) {
        var kfs = [Keyframe]()
        for (i, pos) in postures.enumerate() {
            kfs.append(Keyframe(time: Double(i + 1) * dt, posture: pos))
        }
        self.init(keyframes: kfs,levelOfIntensity: 0)
    }
    
    convenience init?(times: [NSTimeInterval], postures: [Posture], angleCurves: [Keyframe.Curve], postureCurves: [Keyframe.Curve], levelOfIntensity intensity: Int) {
        guard times.length == postures.length
            && times.length == angleCurves.length
            && postureCurves.length == times.length else {
            return nil
        }
        var kfs = [Keyframe]()
        for i in 0..<times.length {
            kfs.append(Keyframe(time: times[i], posture: postures[i], angleCurve: angleCurves[i],postureCurve: postureCurves[i]))
        }
        
        self.init(keyframes: kfs,levelOfIntensity: intensity)
    }
    
    convenience init?(times: [NSTimeInterval], postures: [Posture], levelOfIntensity intensity: Int) {
        guard times.length == postures.length else {
                return nil
        }
        var kfs = [Keyframe]()
        for i in 0..<times.length {
            kfs.append(Keyframe(time: times[i], posture: postures[i], angleCurve: .EaseInOut ,postureCurve: .EaseInOut))
        }
        
        self.init(keyframes: kfs,levelOfIntensity: intensity)
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
        
        return Posture(angles: calculateAngle(srcPosture.angles,dest: desPosture.angles, curve: angleCurve,ratio: ratio),
            position: calculatePosition(srcPosture.position, dest: desPosture.position, curve: positionCurve,ratio: ratio))
    }
    
    private func calculateAngle(src:[BodyPartName: CGFloat],dest:[BodyPartName: CGFloat],curve: Keyframe.Curve,ratio:CGFloat) -> [BodyPartName: CGFloat] {
        var angles = src
        let value = getCurveRatio(curve, ratio: ratio)
        for part in BodyPartName.allParts {
            if angles[part] != nil {
                angles[part] = angles[part]! + (dest[part]! - src[part]!) * value
            }
        }
        return angles
    }
    
    private func calculatePosition(src: CGPoint, dest: CGPoint, curve : Keyframe.Curve,ratio:CGFloat) -> CGPoint {
        var position = src
        let value = getCurveRatio(curve, ratio: ratio)
        position = position + (dest - src) * value
        return position
    }
    
    private func getCurveRatio(curve: Keyframe.Curve , ratio:CGFloat) -> CGFloat {
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

