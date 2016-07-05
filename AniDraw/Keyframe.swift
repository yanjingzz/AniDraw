//
//  Keyframe.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation
struct Keyframe {
    var time: NSDate
    var posture: Posture
//    var nextCurve: DanceMoveAnimationCurve
    var angleCurve: CurveType
    var angleEase: EaseType
    var positionCurve : CurveType
    var positionEase: EaseType
    
}

//enum DanceMoveAnimationCurve : Int {
//    case EaseInOut
//    case EaseIn
//    case EaseOut
//    case Linear
//}

