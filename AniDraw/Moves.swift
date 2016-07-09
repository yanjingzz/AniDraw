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
                .LeftForearm: -1.0584],
            position: CGPoint(x: 617.5, y: 8.5)),
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
            position: CGPoint(x: -700+19.0, y: 13.0)),
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
            position: CGPoint(x: -700+102.5, y: -45.0)),
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
            position: CGPoint(x: -700+365.5, y: 44.0)),
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
            position: CGPoint(x: -700+521.0, y: 28.0)),
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
                .LeftForearm: -1.0584],
            position: CGPoint(x: -700+617.5, y: 8.5)),
        ]
    private static let rollTime:[Double] = [0.5,0.5, 0.3,0.5,0.5, 0.3, 0.5, 0.3,0.5,0.5]
    private static let rollEase: [Keyframe.Curve] = [.EaseIn,.Linear,.Linear,.Linear,.Linear, .None,.Linear,.Linear,.Linear,.Linear]
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
    
    private static let hopPostures: [Posture] = [
        Posture(
            angles: [
                .LeftUpperArm: -0.595566,
                .LeftShank: 0.724757,
                .RightFoot: -5.86159,
                .RightShank: 5.63317,
                .LeftThigh: -0.346861,
                .LowerBody: 0.0,
                .Head: 0.0,
                .RightForearm: 0.0,
                .LeftFoot: -0.478235,
                .RightUpperArm: 0.52976,
                .UpperBody: 0.0,
                .RightThigh: 0.327888,
                .LeftForearm: 0.0],
            position: CGPoint(x: 1.0, y: -20.5)),
        Posture(
            angles: [
                .LeftUpperArm: 5.39077,
                .LeftShank: 0.0,
                .RightFoot: -5.86159,
                .RightShank: 5.49945,
                .LeftThigh: -0.0491034,
                .LowerBody: -0.0867383,
                .Head: -0.121687,
                .RightForearm: 0.0,
                .LeftFoot: -0.100841,
                .RightUpperArm: 1.37902,
                .UpperBody: 0.0867383,
                .RightThigh: 1.04219,
                .LeftForearm: 4.77373],
            position: CGPoint(x: -37.5, y: 42.0)),
        Posture(
            angles: [
                .LeftUpperArm: -0.54047,
                .LeftShank: 0.0,
                .RightFoot: 0.106747,
                .RightShank: 0.0,
                .LeftThigh: -0.0491034,
                .LowerBody: -0.0867383,
                .Head: 0.123945,
                .RightForearm: 1.0427,
                .LeftFoot: -0.100841,
                .RightUpperArm: 0.674236,
                .UpperBody: 0.0867383,
                .RightThigh: 0.171532,
                .LeftForearm: 0.0],
            position: CGPoint(x: -37.5, y: -9.5)),
        Posture(
            angles: [
                .LeftUpperArm: 5.39077,
                .LeftShank: 1.25605,
                .RightFoot: -5.786,
                .RightShank: 4.98099,
                .LeftThigh: -0.502747,
                .LowerBody: 0.101689,
                .Head: 0.216681,
                .RightForearm: 1.33821,
                .LeftFoot: -0.772561,
                .RightUpperArm: 1.41095,
                .UpperBody: -0.101689,
                .RightThigh: 0.740951,
                .LeftForearm: 4.77373], 
            position: CGPoint(x: -49.0, y: -36.5)), 
        Posture( 
            angles: [
                .LeftUpperArm: 3.65396, 
                .LeftShank: 0.0, 
                .RightFoot: -0.630612, 
                .RightShank: 0.0, 
                .LeftThigh: -0.428415, 
                .LowerBody: 0.013651, 
                .Head: 0.135044, 
                .RightForearm: 5.54656, 
                .LeftFoot: -0.683273, 
                .RightUpperArm: 2.86805, 
                .UpperBody: -0.013651, 
                .RightThigh: -0.0129228, 
                .LeftForearm: 0.0], 
            position: CGPoint(x: -11.5, y: 38.5)), 
        Posture( 
            angles: [
                .LeftUpperArm: -0.627718, 
                .LeftShank: 0.0, 
                .RightFoot: 0.0, 
                .RightShank: 0.0, 
                .LeftThigh: 0.0, 
                .LowerBody: 0.0, 
                .Head: 0.117135, 
                .RightForearm: 0.0, 
                .LeftFoot: 0.0, 
                .RightUpperArm: 0.510568, 
                .UpperBody: 0.0, 
                .RightThigh: 0.0, 
                .LeftForearm: 0.0], 
            position: CGPoint(x: 0.0, y: 0.0)), 
        ]
    
    private static let hopTime: [Double] = [0.5, 0.2, 0.2, 0.5, 0.2, 0.2]
    private static let hopEase: [Keyframe.Curve] = [.EaseInOut, .EaseOut, .EaseIn, .EaseInOut, .EaseOut, .EaseIn]
    static let hopMove = DanceMove(times: hopTime, postures: hopPostures, angleCurves: hopEase, postureCurves: hopEase, levelOfIntensity: 2)!
    
    private static let cheerWavePostures : [Posture] = [
        Posture(
            angles: [
                .LeftUpperArm: 2.07887,
                .LeftShank: 0.602443,
                .RightFoot: 0.129851,
                .LeftThigh: -0.388878,
                .LowerBody: 0.0,
                .RightShank: 5.42809,
                .Head: 0.0,
                .RightForearm: 1.24402,
                .LeftFoot: -0.248976,
                .RightUpperArm: 1.54063,
                .UpperBody: 0.0,
                .RightThigh: 0.391459,
                .LeftForearm: 1.065],
            position: CGPoint(x: 0.0, y: -18.0)),
        Posture(
            angles: [
                .LeftUpperArm: 2.17019,
                .LeftShank: 0.0,
                .RightFoot: -5.94116,
                .LeftThigh: 0.00724173,
                .LowerBody: 0.0,
                .RightShank: 0.0,
                .Head: 0.0,
                .RightForearm: 0.0,
                .LeftFoot: -0.248976,
                .RightUpperArm: 1.84369,
                .UpperBody: 0.0,
                .RightThigh: -0.109601,
                .LeftForearm: 0.0],
            position: CGPoint(x: -1.5, y: -7.5)),
        Posture(
            angles: [
                .LeftUpperArm: -0.192614,
                .LeftShank: 0.0,
                .RightFoot: 0.129851,
                .LeftThigh: -0.00815463,
                .LowerBody: 0.0,
                .RightShank: 0.0,
                .Head: 0.0,
                .RightForearm: 0.0,
                .LeftFoot: -0.248976,
                .RightUpperArm: 0.20631,
                .UpperBody: 0.0,
                .RightThigh: -0.00120103,
                .LeftForearm: 0.0],
            position: CGPoint(x: 0.0, y: -18.0)),
        Posture(
            angles: [
                .LeftUpperArm: 4.75452,
                .LeftShank: 0.85329,
                .RightFoot: 0.129851,
                .LeftThigh: -0.593348,
                .LowerBody: 0.0,
                .RightShank: 5.91768,
                .Head: 0.0,
                .RightForearm: 4.22848,
                .LeftFoot: -0.248976,
                .RightUpperArm: 5.64553,
                .UpperBody: 0.0,
                .RightThigh: 0.260791,
                .LeftForearm: 4.85075],
            position: CGPoint(x: 0.0, y: -18.0)),
        Posture(
            angles: [
                .LeftUpperArm: 4.358,
                .LeftShank: 0.0, 
                .RightFoot: 0.129851, 
                .LeftThigh: -0.0818013, 
                .LowerBody: -0.00552475, 
                .RightShank: 0.0, 
                .Head: 0.0, 
                .RightForearm: 0.0, 
                .LeftFoot: -0.248976, 
                .RightUpperArm: -1.35173, 
                .UpperBody: 0.0, 
                .RightThigh: 0.0375671, 
                .LeftForearm: 0.0], 
            position: CGPoint(x: 16.5, y: -26.5)), 
        Posture( 
            angles: [
                .LeftUpperArm: 0.0, 
                .LeftShank: 0.0, 
                .RightFoot: 0.0, 
                .LeftThigh: 0.0, 
                .LowerBody: 0.0, 
                .RightShank: 0.0, 
                .Head: 0.0, 
                .RightForearm: 0.0, 
                .LeftFoot: 0.0, 
                .RightUpperArm: 0.0, 
                .UpperBody: 0.0, 
                .RightThigh: 0.0, 
                .LeftForearm: 0.0], 
            position: CGPoint(x: 0.0, y: 0.0)),
    ]
    private static let cheerWaveTime: [Double] = [0.5, 0.2, 0.5, 0.5, 0.2, 0.5]
    private static let cheerWaveEase: [Keyframe.Curve] = [.EaseInOut, .EaseOut, .EaseOut, .EaseInOut, .EaseOut, .EaseOut]
    static let cheerWaveMove = DanceMove(times: cheerWaveTime, postures: cheerWavePostures, angleCurves: cheerWaveEase, postureCurves: cheerWaveEase, levelOfIntensity: 2)!
    
    private static let stretch1Posture : [Posture] = [
        Posture(
            angles: [
                .LeftUpperArm: 3.54321,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .RightShank: 0.0,
                .LeftThigh: 0.0,
                .LowerBody: 0.0,
                .Head: -0.149733,
                .RightForearm: 0.0,
                .LeftFoot: 0.0,
                .RightUpperArm: 2.71422,
                .UpperBody: 0.0,
                .RightThigh: 0.0,
                .LeftForearm: 0.0],
            position: CGPoint(x: 0.0, y: 0.0)),
        Posture(
            angles: [
                .LeftUpperArm: -0.275524,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .RightShank: 0.0,
                .LeftThigh: 0.0,
                .LowerBody: 0.0, 
                .Head: 0.0287356, 
                .RightForearm: 0.0, 
                .LeftFoot: 0.0, 
                .RightUpperArm: 0.233239, 
                .UpperBody: 0.0, 
                .RightThigh: 0.0, 
                .LeftForearm: 0.0], 
            position: CGPoint(x: 0.0, y: 0.0)),
    ]
    private static let stretch1Time: [Double] = [1.2,0.4]
    private static let stretch1Ease: [Keyframe.Curve] = [.QuarticEaseInOut, .EaseInOut]
    static let stretch1Move = DanceMove(times: stretch1Time, postures: stretch1Posture, angleCurves: stretch1Ease, postureCurves: stretch1Ease, levelOfIntensity: 1)!

    private static let shakeHeadPosture : [Posture] = [
        Posture(
            angles: [
                .LeftUpperArm: -0.332896,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .RightShank: 0.0,
                .LeftThigh: 0.0,
                .LowerBody: 0.0,
                .Head: -0.276972,
                .RightForearm: 0.0,
                .LeftFoot: 0.0,
                .RightUpperArm: 0.316924,
                .UpperBody: 0.0,
                .RightThigh: 0.0,
                .LeftForearm: 0.0],
            position: CGPoint(x: 0.0, y: 0.0)),
        Posture(
            angles: [
                .LeftUpperArm: -0.526192,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .RightShank: 0.0,
                .LeftThigh: 0.0,
                .LowerBody: 0.0,
                .Head: 0.030341,
                .RightForearm: 0.0,
                .LeftFoot: 0.0,
                .RightUpperArm: 0.507631,
                .UpperBody: 0.0,
                .RightThigh: 0.0,
                .LeftForearm: 0.0],
            position: CGPoint(x: 0.0, y: 0.0)),
        Posture(
            angles: [
                .LeftUpperArm: -0.301585,
                .LeftShank: 0.0,
                .RightFoot: 0.0,
                .RightShank: 0.0,
                .LeftThigh: 0.0,
                .LowerBody: 0.0,
                .Head: 0.348284,
                .RightForearm: 0.0,
                .LeftFoot: 0.0,
                .RightUpperArm: 0.316924,
                .UpperBody: 0.0,
                .RightThigh: 0.0, 
                .LeftForearm: 0.0], 
            position: CGPoint(x: 0.0, y: 0.0)), 
        Posture( 
            angles: [
                .LeftUpperArm: 0.0, 
                .LeftShank: 0.0, 
                .RightFoot: 0.0, 
                .RightShank: 0.0, 
                .LeftThigh: 0.0, 
                .LowerBody: 0.0, 
                .Head: 0.0, 
                .RightForearm: 0.0, 
                .LeftFoot: 0.0, 
                .RightUpperArm: 0.0, 
                .UpperBody: 0.0, 
                .RightThigh: 0.0, 
                .LeftForearm: 0.0], 
            position: CGPoint(x: 0.0, y: 0.0)),
    ]
    
    private static let shakeHeadTime: [Double] = [0.3,0.3,0.3,0.3]
    private static let shakeHeadEase: [Keyframe.Curve] = [.EaseInOut, .EaseIn, .EaseOut, .EaseIn]
    static let shakeHeadMove = DanceMove(times: shakeHeadTime, postures: shakeHeadPosture, angleCurves: shakeHeadEase, postureCurves: shakeHeadEase, levelOfIntensity: 1)!

//    private static let XXPosture : [Posture] = [
//    ]
//    private static let XXTime: [Double] = []
//    private static let XXEase: [Keyframe.Curve] = [.EaseInOut, .EaseIn, .EaseOut, .EaseIn]
//    static let XXMove = DanceMove(times: XXTime, postures: XXPosture, angleCurves: XXEase, postureCurves: XXEase, levelOfIntensity: XX)!

    static let allMoves: [Int: [DanceMove]] = [1: [gentalWave, stretch1Move, shakeHeadMove],
                                               2: [hopMove,cheerWaveMove],
                                               3: [jumpMove],
                                               4: [stepMove],
                                               5: [rollMove]]
    
}