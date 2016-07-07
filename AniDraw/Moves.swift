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
    
    private static let stepPostures: [Posture] = [
        Posture(
            angles: [
                .LeftUpperArm: 0.159893,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .LeftThigh: -0.247413,
                .LowerBody: 0.0,
                .RightShank: 5.27179,
                .Head: 0.0,
                .RightForearm: 0.0,
                .LeftFoot: 0.223056,
                .RightUpperArm: 0.487334,
                .UpperBody: 0.0,
                .RightThigh: 1.15019,
                .LeftForearm: 1.09974],
            position: CGPoint(x: 64.5, y: 44.5)),
        Posture(
            angles: [
                .LeftUpperArm: -0.821626,
                .LeftShank: 0.0,
                .RightFoot: -6.20475,
                .LeftThigh: -0.709471,
                .LowerBody: -0.0543398,
                .RightShank: 5.27124,
                .Head: 0.257887,
                .RightForearm: 1.07511,
                .LeftFoot: 0.707529,
                .RightUpperArm: 1.52512,
                .UpperBody: 0.0543398,
                .RightThigh: 1.03743,
                .LeftForearm: 0.0],
            position: CGPoint(x: 145.5, y: -11.5)),
        Posture(
            angles: [
                .LeftUpperArm: 3.84823,
                .LeftShank: 1.07186,
                .RightFoot: 0.0,
                .LeftThigh: 0.00764573,
                .LowerBody: -0.215889,
                .RightShank: 0.0,
                .Head: 0.0,
                .RightForearm: 0.695262,
                .LeftFoot: 0.707529,
                .RightUpperArm: 3.0869,
                .UpperBody: -0.317266,
                .RightThigh: 0.52848,
                .LeftForearm: 0.0],
            position: CGPoint(x: 251.5, y: 32.0)),
        Posture(
            angles: [
                .LeftUpperArm: 3.21749,
                .LeftShank: 0.0,
                .RightFoot: -6.28317,
                .LeftThigh: -0.614475,
                .LowerBody: -0.19725,
                .RightShank: 0.0,
                .Head: 0.311127,
                .RightForearm: 5.46418,
                .LeftFoot: 0.707529,
                .RightUpperArm: 2.67374,
                .UpperBody: 0.378873,
                .RightThigh: -0.0552249,
                .LeftForearm: 5.59136],
            position: CGPoint(x: 182.474, y: 27.9892)),
        Posture(
            angles: [
                .LeftUpperArm: -0.814574,
                .LeftShank: 0.0,
                .RightFoot: -6.78469,
                .LeftThigh: -0.0606298,
                .LowerBody: -0.115106,
                .RightShank: 5.86847,
                .Head: -0.148324,
                .RightForearm: 1.04499,
                .LeftFoot: -0.105343,
                .RightUpperArm: 0.514461,
                .UpperBody: 0.1528,
                .RightThigh: 0.850902,
                .LeftForearm: 5.56573],
            position: CGPoint(x: 99.4737, y: 28.9892)),
        Posture(
            angles: [
                .LeftUpperArm: 4.68435,
                .LeftShank: 1.04733,
                .RightFoot: 0.162408,
                .LeftThigh: -0.651196,
                .LowerBody: -0.115106,
                .RightShank: 4.92839,
                .Head: 0.141926,
                .RightForearm: 5.37417,
                .LeftFoot: -0.507144,
                .RightUpperArm: -0.573485, 
                .UpperBody: 0.1528, 
                .RightThigh: 0.971049, 
                .LeftForearm: 5.599], 
            position: CGPoint(x: 94.4737, y: -4.5108)), 
        Posture( 
            angles: [
                .LeftUpperArm: -1.06498, 
                .LeftShank: 0.0, 
                .RightFoot: -0.0244217, 
                .LeftThigh: -0.0555463, 
                .LowerBody: 0.00510895, 
                .RightShank: 0.0, 
                .Head: -0.0167136, 
                .RightForearm: 5.73828, 
                .LeftFoot: -0.00256252, 
                .RightUpperArm: 0.705852, 
                .UpperBody: 0.0465863, 
                .RightThigh: 0.015506, 
                .LeftForearm: 0.830341], 
            position: CGPoint(x: 32.9737, y: 34.4892)), 
        Posture( 
            angles: [
                .LeftUpperArm: 3.86979, 
                .LeftShank: 0.0, 
                .RightFoot: -0.0244217, 
                .LeftThigh: -0.0555463, 
                .LowerBody: 0.00510895, 
                .RightShank: 0.0, 
                .Head: -0.0167136, 
                .RightForearm: 0.0, 
                .LeftFoot: -0.00256252, 
                .RightUpperArm: 2.63458, 
                .UpperBody: 0.0465863, 
                .RightThigh: 0.015506, 
                .LeftForearm: 0.0], 
            position: CGPoint(x: 32.9737, y: 34.4892)), 
        ]
    private static let stepTime:[Double] = [0.8,0.8,0.5,0.5,0.5, 0.5, 0.5, 0.8]
    static let stepMove = DanceMove(times: stepTime, postures: stepPostures, levelOfIntensity: 5)!
    
    private static let jumpPostures:[Posture] = [
        Posture(
            angles: [
                .LeftUpperArm: -0.44121,
                .LeftShank: 1.27341,
                .RightFoot: -5.45366,
                .LeftThigh: -0.614924,
                .LowerBody: 0.0,
                .RightShank: 4.9342,
                .Head: 0.0,
                .RightForearm: 0.0,
                .LeftFoot: -0.78914,
                .RightUpperArm: 0.647539,
                .UpperBody: 0.0,
                .RightThigh: 0.638949,
                .LeftForearm: 0.0],
            position: CGPoint(x: 1.0, y: -35.5)),
        Posture(
            angles: [
                .LeftUpperArm: 5.21029,
                .LeftShank: 0.247713,
                .RightFoot: -0.0704483,
                .LeftThigh: -0.377037,
                .LowerBody: 0.301619,
                .RightShank: 0.0,
                .Head: 0.0,
                .RightForearm: 1.4832,
                .LeftFoot: 0.590179,
                .RightUpperArm: 1.16535,
                .UpperBody: -0.301619,
                .RightThigh: 0.18931,
                .LeftForearm: 4.88965],
            position: CGPoint(x: 61.0, y: 114.0)),
        Posture(
            angles: [
                .LeftUpperArm: 3.64142,
                .LeftShank: 0.935463,
                .RightFoot: -0.0704483,
                .LeftThigh: -0.556727,
                .LowerBody: 0.0,
                .RightShank: 0.0,
                .Head: 0.0, 
                .RightForearm: 0.904644, 
                .LeftFoot: 0.590179, 
                .RightUpperArm: 1.94635, 
                .UpperBody: 0.0, 
                .RightThigh: 0.0677598, 
                .LeftForearm: 0.0], 
            position: CGPoint(x: 111.0, y: 8.5)), 
        Posture( 
            angles: [
                .LeftUpperArm: -0.247445, 
                .LeftShank: 0.0, 
                .RightFoot: -0.0704483, 
                .LeftThigh: -0.00744522, 
                .LowerBody: 0.0, 
                .RightShank: 0.0, 
                .Head: 0.0, 
                .RightForearm: 0.0, 
                .LeftFoot: 0.0611274, 
                .RightUpperArm: 0.203137, 
                .UpperBody: 0.0, 
                .RightThigh: 0.0677598, 
                .LeftForearm: 0.0], 
            position: CGPoint(x: 111.0, y: 8.5)), 
        ]
    private static let jumpTime: [Double] = [0.5, 0.4, 0.4, 0.3]
    private static let jumpEase: [Keyframe.Curve] = [.EaseInOut, .EaseOut, .EaseIn, .Linear]
    static let jumpMove: DanceMove = DanceMove(times: jumpTime, postures: jumpPostures, angleCurves: jumpEase, postureCurves: jumpEase, levelOfIntensity: 2)!
    static let allMoves: [Int: [DanceMove]] = [1: [gentalWave],
                                               
                                               3: [stepMove],
                                               3: [jumpMove],
                                               5: [rollMove]]
    
}