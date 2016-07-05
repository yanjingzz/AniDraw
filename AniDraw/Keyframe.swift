//
//  Keyframe.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation
import UIKit


struct Keyframe {
    var time: CFTimeInterval
    var posture: Posture
//    var nextCurve: DanceMoveAnimationCurve
    var angleCurve: AngleCurve
    var positionCurve : PositionCurve
    init(pos : CGPoint) {
        time = 0
        posture = Posture(position: pos)
        angleCurve = .Linear
        positionCurve = .Linear
    }
    init(time:NSTimeInterval, pos:Posture, angleCurveIndex:Int, posCurveIndex:Int) {
        self.time = time
        self.posture = pos
        self.angleCurve = AngleCurve(rawValue: angleCurveIndex)!
        self.positionCurve = PositionCurve(rawValue: posCurveIndex)!
    }
}


enum AngleCurve : Int {
    case EaseInOut
    case EaseIn
    case EaseOut
    case Linear
}

enum PositionCurve : Int {
    case EaseInOut
    case EaseIn
    case EaseOut
    case Linear
}
