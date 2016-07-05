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
    var angleCurve: Curve
    var positionCurve : Curve
    init(pos : CGPoint) {
        time = 0
        posture = Posture(position: pos)
        angleCurve = .Linear
        positionCurve = .Linear
    }
    init(time:NSTimeInterval, pos:Posture, angleCurveIndex:Int, posCurveIndex:Int) {
        self.time = time
        self.posture = pos
        self.angleCurve = Curve(rawValue: angleCurveIndex)!
        self.positionCurve = Curve(rawValue: posCurveIndex)!
    }
}


enum Curve : Int {
    case EaseInOut
    case EaseIn
    case EaseOut
    case Linear
}
