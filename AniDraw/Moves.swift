//
//  Moves.swift
//  AniDraw
//
//  Created by Mike on 7/6/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation

class MovesStorage {
    private static let gentalWavePostures = [
        Posture(
            angles: [
                .LeftUpperArm: 0.14531,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .RightShank: 0.0,
                .LowerBody: 0.0532829,
                .LeftThigh: 0.0,
                .Head: -0.197396,
                .RightForearm: 2.16524,
                .LeftFoot: 0.0,
                .RightUpperArm: 0.362227,
                .UpperBody: -0.0532829,
                .RightThigh: 0.0,
                .LeftForearm: 2.40236],
            position: CGPoint(x: 0.0, y: 0.0)),
        Posture(
            angles: [
                .LeftUpperArm: -0.183985,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .RightShank: 0.0,
                .LowerBody: -0.0920469,
                .LeftThigh: 0.0,
                .Head: 0.192096,
                .RightForearm: 3.88148,
                .LeftFoot: 0.0,
                .RightUpperArm: -0.221583,
                .UpperBody: 0.0920469,
                .RightThigh: 0.0,
                .LeftForearm: 3.80092],
            position: CGPoint(x: 0.0, y: 0.0)),
        Posture(
            angles: [
                .LeftUpperArm: 1.24487,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .RightShank: 0.0,
                .LowerBody: 0.0705897,
                .LeftThigh: 0.0,
                .Head: -0.118132,
                .RightForearm: 2.25414,
                .LeftFoot: 0.0,
                .RightUpperArm: 0.783834,
                .UpperBody: -0.0705897,
                .RightThigh: 0.0,
                .LeftForearm: 1.6615],
            position: CGPoint(x: 0.0, y: 2.5)),
        Posture(
            angles: [
                .LeftUpperArm: 0.0,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .RightShank: 0.0,
                .LowerBody: 0.0,
                .LeftThigh: 0.0,
                .Head: 0.0,
                .RightForearm: 0.0,
                .LeftFoot: 0.0,
                .RightUpperArm: 0.0,
                .UpperBody: 0.0,
                .RightThigh: 0.0,
                .LeftForearm: 0.0],
            position: CGPoint(x: 0.0, y: 0.0))
        ]
    private static let gentalWaveTime:[Double] = [1,1,1,1]
    static let gentalWave = DanceMove(times: gentalWaveTime, postures: gentalWavePostures, levelOfIntensity: 1)!
    
    private static let rollPosture = [
        Posture(
            angles: [
                .LeftUpperArm: 4.824,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .LeftThigh: -0.0885419,
                .RightShank: 0.0,
                .LowerBody: 0.460051,
                .Head: 0.0,
                .RightForearm: 0.0,
                .LeftFoot: 0.0,
                .RightUpperArm: 1.98897,
                .UpperBody: -0.979197,
                .RightThigh: 0.595014,
                .LeftForearm: 0.0],
            position: CGPoint(x: 19.0, y: 13.0)),
        Posture(
            angles: [
                .LeftUpperArm: 3.95,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .LeftThigh: -0.0885419,
                .RightShank: 0.0,
                .LowerBody: 0.434172,
                .Head: 0.0,
                .RightForearm: 0.0,
                .LeftFoot: 0.0,
                .RightUpperArm: 2.6774,
                .UpperBody: -1.92183,
                .RightThigh: 1.26473,
                .LeftForearm: -6.13617],
            position: CGPoint(x: 102.5, y: -45.0)),
        Posture(
            angles: [
                .LeftUpperArm: 2.96369,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .LeftThigh: -6.99841,
                .RightShank: 6.21658,
                .LowerBody: 6.1415,
                .Head: -0.336324,
                .RightForearm: 0.0,
                .LeftFoot: 0.0,
                .RightUpperArm: 2.9452,
                .UpperBody: -2.93382,
                .RightThigh: -6.13282,
                .LeftForearm: 0.234694],
            position: CGPoint(x: 365.5, y: 44.0)),
        Posture(
            angles: [
                .LeftUpperArm: 3.92459,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .LeftThigh: -6.99841,
                .RightShank: 0.0, 
                .LowerBody: 6.09366, 
                .Head: -0.700056, 
                .RightForearm: 0.0, 
                .LeftFoot: 0.0, 
                .RightUpperArm: 7.68211, 
                .UpperBody: -4.26692, 
                .RightThigh: -6.71431, 
                .LeftForearm: 0.180584], 
            position: CGPoint(x: 521.0, y: 28.0)), 
        Posture( 
            angles: [
                .LeftUpperArm: 3.92459, 
                .LeftShank: 0.0, 
                .RightFoot: 0.0, 
                .LeftThigh: -0.0107188, 
                .RightShank: 6.16769, 
                .LowerBody: -0.000948787, 
                .Head: 0.112772, 
                .RightForearm: 0.0, 
                .LeftFoot: 0.0, 
                .RightUpperArm: 7.68211, 
                .UpperBody: -0.0542945, 
                .RightThigh: 0.115178, 
                .LeftForearm: 0.180584], 
            position: CGPoint(x: 617.5, y: 8.5)), 
        ]
    private static let rollTime:[Double] = [1,1,1,1,1]
    private static let rollEase: [Keyframe.Curve] = [.EaseIn,.Linear,.Linear,.Linear,.Linear]
    static let rollMove = DanceMove(times: rollTime, postures: rollPosture, angleCurves: rollEase, postureCurves: rollEase, levelOfIntensity: 5)!
    
    static let allMoves: [DanceMove] = [gentalWave, rollMove]
    
}