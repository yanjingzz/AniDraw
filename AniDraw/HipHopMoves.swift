//
//  HipHopMoves.swift
//  AniDraw
//
//  Created by Mike on 7/25/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation
struct HipHopMoves {
    static func createAll() {
        _ = DanceMove(
            keyframes:
            [
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: -1.41006,
                            .LeftShank: 2.02635,
                            .RightFoot: -5.38221,
                            .LeftThigh: -1.11423,
                            .LowerBody: 0.0,
                            .RightShank: 4.1474,
                            .Head: 0.0,
                            .RightForearm: 5.08396,
                            .LeftFoot: -0.629924,
                            .RightUpperArm: 1.40723,
                            .UpperBody: 0.0,
                            .RightThigh: 1.11453,
                            .LeftForearm: 1.29855],
                        position: CGPoint(x: 14.0, y: -90.5)),
                    angleCurve: .EaseInOut,
                    positionCurve: .EaseInOut),
                Keyframe(
                    time: 0.5,
                    posture: Posture(
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
                    angleCurve: .EaseInOut,
                    positionCurve: .EaseInOut),
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: -1.6771,
                            .LeftShank: 1.98619,
                            .RightFoot: -5.20064,
                            .LeftThigh: -1.13152,
                            .LowerBody: -0.0275811,
                            .RightShank: 4.20669,
                            .Head: 0.0,
                            .RightForearm: 4.65678,
                            .LeftFoot: -0.896164,
                            .RightUpperArm: 1.63935,
                            .UpperBody: 0.0275792,
                            .RightThigh: 1.18162,
                            .LeftForearm: 1.72869],
                        position: CGPoint(x: 1.5, y: -85.5)),
                    angleCurve: .EaseInOut,
                    positionCurve: .EaseInOut),
                Keyframe(
                    time: 0.5,
                    posture: Posture(
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
                    angleCurve: .EaseInOut,
                    positionCurve: .EaseInOut)],
            levelOfIntensity: 1,
            style: .HipHop,
            name: "Up & Down")
        
        
        _ = DanceMove(
            keyframes:
            [
                Keyframe(
                    time: 0.25,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 5.6741,
                            .LeftShank: 0.0,
                            .RightFoot: 0.0,
                            .LeftThigh: 0.0,
                            .LowerBody: 0.005988,
                            .RightShank: 0.0,
                            .Head: 0.0,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.0,
                            .RightUpperArm: 0.15999,
                            .UpperBody: 0.0,
                            .RightThigh: 0.0,
                            .LeftForearm: 4.8227],
                        position: CGPoint(x: 0.0, y: 0.0)),
                    angleCurve: .Linear,
                    positionCurve: .Linear),
                Keyframe(
                    time: 0.25,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 4.02839,
                            .LeftShank: 0.0,
                            .RightFoot: 0.0,
                            .LeftThigh: 0.0,
                            .LowerBody: 0.0289774,
                            .RightShank: 0.0,
                            .Head: -0.0380788,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.0,
                            .RightUpperArm: 0.189832,
                            .UpperBody: -0.0289774,
                            .RightThigh: 0.0, 
                            .LeftForearm: 1.1325], 
                        position: CGPoint(x: 0.0, y: 0.0)), 
                    angleCurve: .Linear, 
                    positionCurve: .Linear), 
                Keyframe( 
                    time: 0.25, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: -1.21815, 
                            .LeftShank: 0.0, 
                            .RightFoot: 0.0, 
                            .LeftThigh: 0.0, 
                            .LowerBody: 0.327098, 
                            .RightShank: 0.0, 
                            .Head: 0.328706, 
                            .RightForearm: 0.0, 
                            .LeftFoot: 0.0, 
                            .RightUpperArm: 0.384985, 
                            .UpperBody: -0.327098, 
                            .RightThigh: 0.0, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 0.0, y: 0.0)), 
                    angleCurve: .Linear, 
                    positionCurve: .Linear), 
                Keyframe( 
                    time: 0.25, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: -0.148428, 
                            .LeftShank: 0.0, 
                            .RightFoot: 0.0, 
                            .LeftThigh: 0.0, 
                            .LowerBody: -0.238609, 
                            .RightShank: 0.0, 
                            .Head: -0.369636, 
                            .RightForearm: 5.74951, 
                            .LeftFoot: 0.0, 
                            .RightUpperArm: 0.536392, 
                            .UpperBody: 0.238609, 
                            .RightThigh: 0.0, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 0.0, y: 0.0)), 
                    angleCurve: .EaseIn, 
                    positionCurve: .Linear), 
                Keyframe( 
                    time: 0.25, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 0.0, 
                            .LeftShank: 0.0, 
                            .RightFoot: 0.0, 
                            .LeftThigh: 0.0, 
                            .LowerBody: 0.0, 
                            .RightShank: 0.0, 
                            .Head: 0.0, 
                            .RightForearm: 5.11695, 
                            .LeftFoot: 0.0, 
                            .RightUpperArm: 1.29939, 
                            .UpperBody: 0.0, 
                            .RightThigh: 0.0, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 0.0, y: 0.0)), 
                    angleCurve: .Linear, 
                    positionCurve: .Linear), 
                Keyframe( 
                    time: 0.25, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 0.0, 
                            .LeftShank: 0.0, 
                            .RightFoot: 0.0, 
                            .LeftThigh: 0.0, 
                            .LowerBody: 0.0, 
                            .RightShank: 0.0, 
                            .Head: 0.0, 
                            .RightForearm: 1.06974, 
                            .LeftFoot: 0.0, 
                            .RightUpperArm: 0.928701, 
                            .UpperBody: 0.0, 
                            .RightThigh: 0.0, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 0.0, y: 0.0)), 
                    angleCurve: .Linear, 
                    positionCurve: .Linear), 
                Keyframe( 
                    time: 0.25, 
                    posture: Posture( 
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
                            .RightUpperArm: 1.67712, 
                            .UpperBody: 0.0, 
                            .RightThigh: 0.0, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 0.0, y: 0.0)), 
                    angleCurve: .Linear, 
                    positionCurve: .EaseIn)], 
            levelOfIntensity: 1,
            style: .HipHop,
            name: "Arms Wave")
    }
    
}
