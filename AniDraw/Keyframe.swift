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
    init(time:NSTimeInterval, posture:Posture, angleCurve: Curve, postureCurve: Curve) {
        self.time = time
        self.posture = posture
        self.angleCurve = angleCurve
        self.positionCurve = postureCurve
    }
    init (time:NSTimeInterval, posture:Posture) {
        self.init(time:time, posture: posture, angleCurve: .EaseInOut, postureCurve: .EaseInOut)
    }
    enum Curve : Int {
        case Linear
        case EaseIn
        case EaseOut
        case EaseInOut
        case None
    }
}



