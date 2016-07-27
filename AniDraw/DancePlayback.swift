//
//  DancePlayBack.swift
//  AniDraw
//
//  Created by Mike on 7/18/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation

class DancePlayback {
    
    private var keyframes = [Keyframe]()
    var previousPosture = Posture.idle
    private var _totalTime: NSTimeInterval = 0.0
    private var currentPassTime : NSTimeInterval = 0.0
    var totalTime: NSTimeInterval {
        return _totalTime
    }
    
    var currentKeyframe: Keyframe? {
        //The play head is always at keyframes.first
        return keyframes.first
    }
    
    var isEnding: Bool {
        return keyframes.count <= 1
    }
    
    var isEmpty: Bool {
        return keyframes.isEmpty
    }
    
    var isReturningIdle: Bool {
        // return if the current move is returning to idle or already is idle
        return isEmpty || keyframes.first!.posture == Posture.idle
    }
    
    var currentPosture: Posture {
        return getPostureByIntervalTime(0) ?? previousPosture
    }
    
    private var aborting: Bool = false
    func abort() -> Bool {
        if isReturningIdle {
            return true
        }
        if keyframes[0].interruptable {
            replaceKeysAfterCurrentKeyTo([Keyframe.idle])
            return true
        }
        return false
    }

    func startDanceMove(newKeyframes: [Keyframe]) {
        if keyframes.isEmpty {
            let positionOffset = CGPoint(x: previousPosture.position.x, y: 0)
            for key in newKeyframes {
                keyframes.append(key + positionOffset)
            }
            _totalTime = newKeyframes.totalTime
            return
        } else if keyframes[0].interruptable { // if should interrupt current danceMove
            cutToKeys(newKeyframes)
        } else {
            //TODO: current move shouldn't be interrupted so do what?
        }
    }
    
    func reset() {
        keyframes.removeAll()
        currentPassTime = 0
        _totalTime = 0
    }
    
    func cutToKeys(newKeyframes: [Keyframe]) {
        print("cut to")
        previousPosture = currentPosture
        currentPassTime = 0 //reset time
        keyframes.removeAll(keepCapacity: true)
        let positionOffset = CGPoint(x: previousPosture.position.x, y: 0)
        
        
        for (i, key) in newKeyframes.enumerate() {
            if i == 0 { //strech time of first keyframe
                
            }
                _totalTime += key.time
                keyframes.append(key + positionOffset)
            
        }
        

    }
    
    func replaceKeysAfterCurrentKeyTo(newKeyframes: [Keyframe]) {
        let firstKey = keyframes.first
        keyframes.removeAll(keepCapacity: true)
        let positionOffset = CGPoint(x: CGFloat(firstKey?.posture.position.x ?? 0), y: 0)
        _totalTime = 0
        if let key = firstKey {
            keyframes.append(key)
            _totalTime = key.time
        }
        for move in newKeyframes {
            _totalTime += move.time
            keyframes.append(move + positionOffset)
        }
    }
    
    func getPostureByIntervalTime(dtime:CFTimeInterval) -> Posture? {
        if keyframes.isEmpty {
            return nil
        }
        
        //prehandle dt
        currentPassTime += dtime
        
        while currentPassTime > keyframes.first!.time { //dequeue current frame
            let keyframe = keyframes.removeFirst()
            currentPassTime -= keyframe.time
            previousPosture = keyframe.posture
            _totalTime -= keyframe.time
            if keyframes.isEmpty {
                reset()
                return nil
            }
        }
        
        //prepare parameters
        let currentKey = keyframes.first!
        let srcPosture = previousPosture
        let desPosture = currentKey.posture
        let positionCurve = currentKey.positionCurve
        let angleCurve = currentKey.angleCurve
        let ratio = CGFloat(currentPassTime / currentKey.time)
        
        //get gesture
        let newAngles = calculateAngle(srcPosture.angles,dest: desPosture.angles, curve: angleCurve,ratio: ratio)
        let newPosition = calculatePosition(srcPosture.position, dest: desPosture.position, curve: positionCurve,ratio: ratio)
        return Posture(angles: newAngles, position: newPosition)
    }
    
    private func calculateAngle(src:[BodyPartName: CGFloat],dest:[BodyPartName: CGFloat],curve: Keyframe.Curve,ratio:CGFloat) -> [BodyPartName: CGFloat] {
        var angles = src
        let value = getCurveRatio(curve, ratio: ratio)
        for part in BodyPartName.allParts {
            if angles[part] != nil {
                var delta = dest[part]! - src[part]!
                delta = delta % (2 * CGFloat.pi)
                delta = delta > CGFloat.pi ? delta - 2 * CGFloat.pi : delta
                delta = delta < -CGFloat.pi ? delta + 2 * CGFloat.pi : delta
                angles[part] = angles[part]! + delta * value
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
        case .None:
            value = 0
        case .CubicEaseIn:
            value = ratio * ratio * ratio
        case .CubicEaseOut:
            let tmp = ratio - 1
            value = tmp * tmp * tmp + 1
        case .CubicEaseInOut:
            if ratio < 0.5 {
                value = 4 * ratio * ratio * ratio
            } else {
                let tmp = ((2 * ratio) - 2)
                value = 0.5 * tmp * tmp * tmp + 1
            }
        case .QuarticEaseIn:
            value = ratio * ratio * ratio * ratio
        case .QuarticEaseOut:
            let tmp = ratio - 1
            return tmp * tmp * tmp * (1 - ratio) + 1
        case .QuarticEaseInOut:
            if ratio < 0.5 {
                value = 8 * ratio * ratio * ratio * ratio
            } else {
                let tmp = ratio - 1
                value = -8 * tmp * tmp * tmp * tmp + 1
            }
        case .QuinticEaseIn:
            value = ratio * ratio * ratio * ratio * ratio
        case .QuinticEaseOut:
            let tmp = ratio - 1
            value = tmp * tmp * tmp * tmp * tmp + 1
        case .QuinticEaseInOut:
            if ratio < 0.5 {
                value = 16 * ratio * ratio * ratio * ratio * ratio
            } else {
                let tmp = ((2 * ratio) - 2)
                value = 0.5 * tmp * tmp * tmp * tmp * tmp + 1
            }
        case .SineEaseIn:
            value = CGFloat(sinFloat(Float(ratio - 1.0) * M_PI_2_f)) + 1.0
        case .SineEaseOut:
            value = CGFloat(sinFloat(Float(ratio) * M_PI_2_f))
        case .SineEaseInOut:
            value = CGFloat(0.5 * (1.0 - cos(Float(ratio) * M_PI_f)))
        case .CircularEaseIn:
            value = 1 - sqrt(1 - ratio * ratio)
        case .CircularEaseOut:
            value = sqrt((2 - ratio) * ratio)
        case .CircularEaseInOut:
            if ratio < 0.5 {
                value = 0.5 * (1 - sqrt(1 - 4 * ratio * ratio))
            } else {
                value = 0.5 * (sqrt(-(2 * ratio - 3) * (2 * ratio - 1)) + 1)
            }
        case .ExponentialEaseIn:
            value = ratio == CGFloat(0.0) ? ratio : pow(2, -10 * (ratio - 1.0))
        case .ExponentialEaseOut:
            value = ratio == CGFloat(1.0) ? ratio : 1 - pow(2, -10 * ratio)
        case .ExponentialEaseInOut:
            if ratio == CGFloat(0.0) || ratio == CGFloat(0.0) {
                value = ratio
            } else {
                if ratio < 0.5 {
                    value = 0.5 * pow(2,20 * ratio - 10)
                } else {
                    value = -0.5 * pow(2, -20 * ratio + 10) + 1
                }
            }
        case .ElasticEaseIn:
            value = CGFloat(sinFloat(13 * Float(ratio) * M_PI_2_f)) * pow(2, -10 * (ratio - 1))
        case .ElasticEaseOut:
            value = CGFloat(sinFloat(-13 * Float(ratio + 1) * M_PI_2_f)) * pow(2, -10 * ratio) + 1.0
        case .ElasticEaseInOut:
            if ratio < 0.5 {
                value = 0.5 * CGFloat(sinFloat(13 * Float(2 * ratio) * M_PI_2_f)) * pow(2, -10 * (2 * ratio - 1))
            } else {
                value = 0.5 * (CGFloat(sinFloat(-13 * Float(2 * ratio) * M_PI_2_f)) * pow(2, -10 * (2 * ratio - 1)) + 2)
            }
        case .BackEaseIn:
            value = ratio * ratio * ratio - ratio * CGFloat(sinFloat(Float(ratio) * M_PI_f))
        case .BackEaseOut:
            let tmp = 1 - ratio
            value = 1 - (tmp * tmp * tmp - tmp * CGFloat(sinFloat(Float(tmp) * M_PI_f)))
        case .BackEaseInOut:
            if ratio < 0.5 {
                let tmp = 2 * ratio
                value = 0.5 * (tmp * tmp * tmp - tmp * CGFloat(sinFloat(Float(tmp) * M_PI_f)))
            } else {
                let tmp = 1 - (2 * ratio - 1)
                value = 0.5 * (1 - (tmp * tmp * tmp - tmp * CGFloat(sinFloat(Float(tmp) * M_PI_f)))) + 0.5
            }
        case .BounceEaseIn:
            value = 1 - Bounce(1 - ratio)
        case .BounceEaseOut:
            value = Bounce(ratio)
        case .BounceEaseInOut:
            if ratio < 0.5 {
                value = 0.5 * Bounce(ratio * 2)
            } else {
                value = 0.5 * Bounce(ratio * 2 - 1) + 0.5
            }
            //        default:
            //            break
        }
        return value
    }
    private func Bounce(p:CGFloat) -> CGFloat {
        if p < 4 / 11.0 {
            return (121 * p * p) / 16.0
        } else if p < 8 / 11.0 {
            return (363 / 40.0 * p * p) - (99 / 10.0 * p) + 17/5.0
        } else if p < 9 / 11.0 {
            return (4356/361.0 * p * p) - (35442/1805.0 * p) + 16061/1805.0
        } else {
            return (54/4.0 * p * p) - (513/25.0 * p) + 268/25.0
        }
    }

}