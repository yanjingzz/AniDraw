//
//  Keyframe.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation
import UIKit


struct Keyframe: CustomStringConvertible {
    var time: CFTimeInterval
    var posture: Posture
//    var nextCurve: DanceMoveAnimationCurve
    var angleCurve: Curve
    var positionCurve : Curve

    init(pos : CGPoint) {
        time = 0
        posture = Posture(position: pos)
        angleCurve = .Linear
        positionCurve = .Linear
    }
    init(time:NSTimeInterval, posture:Posture, angleCurve: Curve, positionCurve: Curve) {
        self.time = time
        self.posture = posture
        self.angleCurve = angleCurve
        self.positionCurve = positionCurve
    }
    init (time:NSTimeInterval, posture:Posture) {
        self.init(time:time, posture: posture, angleCurve: .EaseInOut, positionCurve: .EaseInOut)
    }
    var description: String {
        var string = "\nKeyframe( \n"
        string += "    time: \(time), \n"
        string += "    posture: \(posture), \n"
        string += "    angleCurve: .\(angleCurve), \n"
        string += "    positionCurve: .\(positionCurve))"
        return string
    }
    enum Curve : Int {
        case Linear = 0
        case EaseIn
        case EaseOut
        case EaseInOut
        case None
        case CubicEaseIn
        case CubicEaseOut
        case CubicEaseInOut
        case QuarticEaseIn
        case QuarticEaseOut
        case QuarticEaseInOut
        case QuinticEaseIn
        case QuinticEaseOut
        case QuinticEaseInOut
        case SineEaseIn
        case SineEaseOut
        case SineEaseInOut
        case CircularEaseIn
        case CircularEaseOut
        case CircularEaseInOut
        case ExponentialEaseIn
        case ExponentialEaseOut
        case ExponentialEaseInOut
        case ElasticEaseIn
        case ElasticEaseOut
        case ElasticEaseInOut
        case BackEaseIn
        case BackEaseOut
        case BackEaseInOut
        case BounceEaseIn
        case BounceEaseOut
        case BounceEaseInOut
        
        static var count: Int { return BounceEaseInOut.rawValue + 1 }
        
        var description: String {
            switch self {
            case Linear: return "Linear"
            case EaseIn: return "Ease In"
            case EaseOut: return "Ease Out"
            case EaseInOut: return "Ease In Ease Out"
            case None: return "None"
            case CubicEaseIn: return "Cubic Ease In"
            case CubicEaseOut: return "Cubic Ease Out"
            case CubicEaseInOut: return "Cubic Ease In Out"
            case QuarticEaseIn: return "Quartic Ease In"
            case QuarticEaseOut: return "Quartic Ease Out"
            case QuarticEaseInOut: return "Quartic Ease In Ease Out"
            case QuinticEaseIn: return "Quintic Ease In"
            case QuinticEaseOut: return "Quintic Ease Out"
            case QuinticEaseInOut: return "Quintic Ease In Ease Out"
            case SineEaseIn: return "Sine Ease In"
            case SineEaseOut: return "Sine Ease Out"
            case SineEaseInOut: return "Sine Ease In Ease Out"
            case CircularEaseIn: return "Circular Ease In"
            case CircularEaseOut: return "Circular Ease Out"
            case CircularEaseInOut: return "Circular Ease In Ease Out"
            case ExponentialEaseIn: return "Exponential Ease In"
            case ExponentialEaseOut: return "Exponential Ease Out"
            case ExponentialEaseInOut: return "Exponential Ease In Ease Out"
            case ElasticEaseIn: return "Elastic Ease In"
            case ElasticEaseOut: return "Elastic Ease Out"
            case ElasticEaseInOut: return "Elastic Ease In Ease Out"
            case BackEaseIn: return "Back Ease In"
            case BackEaseOut: return "Back Ease Out"
            case BackEaseInOut: return "Back Ease In Ease Out"
            case BounceEaseIn: return "Bounce Ease In"
            case BounceEaseOut: return "Bounce Ease Out"
            case BounceEaseInOut: return "Bounce Ease In Out"
            }
        }
    }
}



