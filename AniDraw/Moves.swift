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
    private static let gentalWaveTime = [0.5,0.3,0.3,0.5]
    static let gentalWave = DanceMove(times: gentalWaveTime, postures: gentalWavePostures, levelOfIntensity: 1)!
    
    static let allMoves: [DanceMove] = [gentalWave]
    
}