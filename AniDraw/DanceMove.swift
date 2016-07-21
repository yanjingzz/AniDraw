//
//  DanceMove.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation
import UIKit

class DanceMove {
    var style: DanceStyle
    var isEmpty: Bool {
        return keyframes.isEmpty
    }
    var keyframes: [Keyframe] {
        didSet {
            totalTime = 0
            for kf in keyframes  {
                totalTime += kf.time
            }
//            if !keyframes.isEmpty {
//                currentFrameEndTime = keyframes[0].time
//            } else {
//                currentFrameEndTime = 0
//            }
//            reset()
        }
    }
    
    var totalTime: CFTimeInterval
//    var currentPassTime : CFTimeInterval
//    var currentFrameEndTime : CFTimeInterval
    var count:Int {
        return keyframes.count
    }
    var level : Int
    
//    var currentFrameIndex : Int
    
//    func reset() {
//        currentPassTime = 0
//        if !keyframes.isEmpty {
//            currentFrameEndTime = keyframes[0].time
//        } else {
//            currentFrameEndTime = 0
//        }
//        currentFrameIndex = 0
//    }

    
    init(keyframes kfs:[Keyframe],levelOfIntensity lev:Int = 0, style: DanceStyle = .Generic) {
        keyframes = kfs
//        currentFrameIndex = 0
//        currentFrameEndTime = 0
//        currentPassTime = 0
        totalTime = 0
        for kf in kfs  {
            totalTime += kf.time
        }
//        if !keyframes.isEmpty {
//            currentFrameEndTime = keyframes[0].time
//        } else {
//            currentFrameEndTime = 0
//        }
        
        level = lev
        self.style = style
        
    }
    
    init() {
        keyframes = [Keyframe]()
//        currentFrameIndex = 0
//        currentFrameEndTime = 0
//        currentPassTime = 0
        totalTime = 0
//        currentFrameEndTime = 0
        level = 0
        style = .Generic;
    }
    
    convenience init?(times: [NSTimeInterval], postures: [Posture], angleCurves: [Keyframe.Curve], postureCurves: [Keyframe.Curve], levelOfIntensity intensity: Int) {
        guard times.length == postures.length
            && times.length == angleCurves.length
            && postureCurves.length == times.length else {
            return nil
        }
        var kfs = [Keyframe]()
        for i in 0..<times.length {
            kfs.append(Keyframe(time: times[i], posture: postures[i], angleCurve: angleCurves[i],positionCurve: postureCurves[i]))
        }
        
        self.init(keyframes: kfs,levelOfIntensity: intensity)
    }
    
    convenience init?(times: [NSTimeInterval], postures: [Posture], levelOfIntensity intensity: Int) {
        guard times.length == postures.length else {
                return nil
        }
        var kfs = [Keyframe]()
        for i in 0..<times.length {
            kfs.append(Keyframe(time: times[i], posture: postures[i], angleCurve: .EaseInOut ,positionCurve: .EaseInOut))
        }
        
        self.init(keyframes: kfs,levelOfIntensity: intensity)
    }
    
    
    
//    func getPostureByIntervalTime(dtime:CFTimeInterval, previousPosture: Posture) -> Posture? {
//        //prehandle dt
//        var dt = dtime
//        if currentPassTime + dt > totalTime {
//            return nil
//        }
//        if currentPassTime + dt > currentFrameEndTime {
//            currentFrameIndex += 1
//            dt = currentPassTime + dt - currentFrameEndTime
//            currentFrameEndTime += keyframes[currentFrameIndex].time
//        }
//        currentPassTime += dt
//        
//        //prepare parameters
//        var srcPosture : Posture
//        var desPosture : Posture
//        let positionCurve = keyframes[currentFrameIndex].positionCurve
//        let angleCurve = keyframes[currentFrameIndex].angleCurve
//        let ratio = CGFloat((keyframes[currentFrameIndex].time + currentPassTime - currentFrameEndTime)
//            / keyframes[currentFrameIndex].time)
//        if currentFrameIndex == 0 {
//            srcPosture = previousPosture
//        } else {
//            srcPosture = keyframes[currentFrameIndex-1].posture
//        }
//        desPosture = keyframes[currentFrameIndex].posture
//        
//        //get gesture
//        
//        return Posture(angles: calculateAngle(srcPosture.angles,dest: desPosture.angles, curve: angleCurve,ratio: ratio),
//            position: calculatePosition(srcPosture.position, dest: desPosture.position, curve: positionCurve,ratio: ratio))
//    }
//    
//    private func calculateAngle(src:[BodyPartName: CGFloat],dest:[BodyPartName: CGFloat],curve: Keyframe.Curve,ratio:CGFloat) -> [BodyPartName: CGFloat] {
//        var angles = src
//        let value = getCurveRatio(curve, ratio: ratio)
//        for part in BodyPartName.allParts {
//            if angles[part] != nil {
//                var delta = dest[part]! - src[part]!
//                delta = delta % (2 * CGFloat.pi)
//                delta = delta > CGFloat.pi ? delta - 2 * CGFloat.pi : delta
//                delta = delta < -CGFloat.pi ? delta + 2 * CGFloat.pi : delta
//                angles[part] = angles[part]! + delta * value
//            }
//        }
//        return angles
//    }
//    
//    private func calculatePosition(src: CGPoint, dest: CGPoint, curve : Keyframe.Curve,ratio:CGFloat) -> CGPoint {
//        var position = src
//        let value = getCurveRatio(curve, ratio: ratio)
//        position = position + (dest - src) * value
//        return position
//    }
//    
//    private func getCurveRatio(curve: Keyframe.Curve , ratio:CGFloat) -> CGFloat {
//        //need expanding?
//        var value : CGFloat = 0
//        switch curve {
//        case .EaseInOut:
//            value = (ratio < 0.5 ? 2 * ratio * ratio : (-2 * ratio * ratio) + (4 * ratio) - 1)
//        case .EaseIn:
//            value = ratio * ratio
//        case .EaseOut:
//            value = -(ratio * (ratio - 2))
//        case .Linear:
//            value = ratio   // y = x, x in [0,1] , y in [0,1]
//        case .None:
//            value = 0
//        case .CubicEaseIn:
//            value = ratio * ratio * ratio
//        case .CubicEaseOut:
//            let tmp = ratio - 1
//            value = tmp * tmp * tmp + 1
//        case .CubicEaseInOut:
//            if ratio < 0.5 {
//                value = 4 * ratio * ratio * ratio
//            } else {
//                let tmp = ((2 * ratio) - 2)
//                value = 0.5 * tmp * tmp * tmp + 1
//            }
//        case .QuarticEaseIn:
//            value = ratio * ratio * ratio * ratio
//        case .QuarticEaseOut:
//            let tmp = ratio - 1
//            return tmp * tmp * tmp * (1 - ratio) + 1
//        case .QuarticEaseInOut:
//            if ratio < 0.5 {
//                value = 8 * ratio * ratio * ratio * ratio
//            } else {
//                let tmp = ratio - 1
//                value = -8 * tmp * tmp * tmp * tmp + 1
//            }
//        case .QuinticEaseIn:
//            value = ratio * ratio * ratio * ratio * ratio
//        case .QuinticEaseOut:
//            let tmp = ratio - 1
//            value = tmp * tmp * tmp * tmp * tmp + 1
//        case .QuinticEaseInOut:
//            if ratio < 0.5 {
//                value = 16 * ratio * ratio * ratio * ratio * ratio
//            } else {
//                let tmp = ((2 * ratio) - 2)
//                value = 0.5 * tmp * tmp * tmp * tmp * tmp + 1
//            }
//        case .SineEaseIn:
//            value = CGFloat(sinFloat(Float(ratio - 1.0) * M_PI_2_f)) + 1.0
//        case .SineEaseOut:
//            value = CGFloat(sinFloat(Float(ratio) * M_PI_2_f))
//        case .SineEaseInOut:
//            value = CGFloat(0.5 * (1.0 - cos(Float(ratio) * M_PI_f)))
//        case .CircularEaseIn:
//            value = 1 - sqrt(1 - ratio * ratio)
//        case .CircularEaseOut:
//            value = sqrt((2 - ratio) * ratio)
//        case .CircularEaseInOut:
//            if ratio < 0.5 {
//                value = 0.5 * (1 - sqrt(1 - 4 * ratio * ratio))
//            } else {
//                value = 0.5 * (sqrt(-(2 * ratio - 3) * (2 * ratio - 1)) + 1)
//            }
//        case .ExponentialEaseIn:
//            value = ratio == CGFloat(0.0) ? ratio : pow(2, -10 * (ratio - 1.0))
//        case .ExponentialEaseOut:
//            value = ratio == CGFloat(1.0) ? ratio : 1 - pow(2, -10 * ratio)
//        case .ExponentialEaseInOut:
//            if ratio == CGFloat(0.0) || ratio == CGFloat(0.0) {
//                value = ratio
//            } else {
//                if ratio < 0.5 {
//                    value = 0.5 * pow(2,20 * ratio - 10)
//                } else {
//                    value = -0.5 * pow(2, -20 * ratio + 10) + 1
//                }
//            }
//        case .ElasticEaseIn:
//            value = CGFloat(sinFloat(13 * Float(ratio) * M_PI_2_f)) * pow(2, -10 * (ratio - 1))
//        case .ElasticEaseOut:
//            value = CGFloat(sinFloat(-13 * Float(ratio + 1) * M_PI_2_f)) * pow(2, -10 * ratio) + 1.0
//        case .ElasticEaseInOut:
//            if ratio < 0.5 {
//                value = 0.5 * CGFloat(sinFloat(13 * Float(2 * ratio) * M_PI_2_f)) * pow(2, -10 * (2 * ratio - 1))
//            } else {
//                value = 0.5 * (CGFloat(sinFloat(-13 * Float(2 * ratio) * M_PI_2_f)) * pow(2, -10 * (2 * ratio - 1)) + 2)
//            }
//        case .BackEaseIn:
//            value = ratio * ratio * ratio - ratio * CGFloat(sinFloat(Float(ratio) * M_PI_f))
//        case .BackEaseOut:
//            let tmp = 1 - ratio
//            value = 1 - (tmp * tmp * tmp - tmp * CGFloat(sinFloat(Float(tmp) * M_PI_f)))
//        case .BackEaseInOut:
//            if ratio < 0.5 {
//                let tmp = 2 * ratio
//                value = 0.5 * (tmp * tmp * tmp - tmp * CGFloat(sinFloat(Float(tmp) * M_PI_f)))
//            } else {
//                let tmp = 1 - (2 * ratio - 1)
//                value = 0.5 * (1 - (tmp * tmp * tmp - tmp * CGFloat(sinFloat(Float(tmp) * M_PI_f)))) + 0.5
//            }
//        case .BounceEaseIn:
//            value = 1 - Bounce(1 - ratio)
//        case .BounceEaseOut:
//            value = Bounce(ratio)
//        case .BounceEaseInOut:
//            if ratio < 0.5 {
//                value = 0.5 * Bounce(ratio * 2)
//            } else {
//                value = 0.5 * Bounce(ratio * 2 - 1) + 0.5
//            }
////        default:
////            break
//        }
//        return value
//    }
//    private func Bounce(p:CGFloat) -> CGFloat {
//        if p < 4 / 11.0 {
//            return (121 * p * p) / 16.0
//        } else if p < 8 / 11.0 {
//            return (363 / 40.0 * p * p) - (99 / 10.0 * p) + 17/5.0
//        } else if p < 9 / 11.0 {
//            return (4356/361.0 * p * p) - (35442/1805.0 * p) + 16061/1805.0
//        } else {
//            return (54/4.0 * p * p) - (513/25.0 * p) + 268/25.0
//        }
//    }
    
     static let idle = DanceMove(keyframes: [Keyframe.idle], levelOfIntensity: 0, style: .Generic)
}

enum DanceStyle: Int {
    case Generic = 0;
    case Ethnic;
    case Ballet;
    case Jazz;
}

