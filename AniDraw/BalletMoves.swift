//
//  BalletMoves.swift
//  AniDraw
//
//  Created by Mike on 7/15/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation

struct BalletMoves {
    static func createAll() {
        _ = DanceMove(
            keyframes:
            [
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: -1.19612,
                            .LeftShank: 0.0,
                            .RightFoot: -0.966667,
                            .RightShank: 0.0,
                            .LowerBody: -0.198646,
                            .LeftThigh: -1.2238,
                            .Head: 0.157226,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.686549,
                            .RightUpperArm: 2.65058,
                            .UpperBody: -0.350728,
                            .RightThigh: 0.504737,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: 0.0, y: 0.0)),
                    angleCurve: .EaseIn,
                    positionCurve: .EaseIn),
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: -0.161829,
                            .LeftShank: 0.0,
                            .RightFoot: -0.966667,
                            .RightShank: 0.0,
                            .LowerBody: -0.833759,
                            .LeftThigh: -1.2238,
                            .Head: 0.157226,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.0311953,
                            .RightUpperArm: 2.65058,
                            .UpperBody: 0.284385,
                            .RightThigh: 0.504737,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: 0.0, y: 0.0)),
                    angleCurve: .EaseOut,
                    positionCurve: .EaseOut),
                Keyframe(
                    time: 0.25,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 3.40025,
                            .LeftShank: 0.0,
                            .RightFoot: -0.892595,
                            .RightShank: 0.0,
                            .LowerBody: -0.0134835,
                            .LeftThigh: -0.396031,
                            .Head: -0.0912468,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.662741,
                            .RightUpperArm: 2.87134,
                            .UpperBody: 0.303571,
                            .RightThigh: 0.0527271,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: -37.0, y: 159.5)),
                    angleCurve: .EaseOut,
                    positionCurve: .EaseOut),
                Keyframe(
                    time: 0.25,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 3.40025,
                            .LeftShank: 0.0,
                            .RightFoot: -0.542102,
                            .RightShank: 0.0,
                            .LowerBody: 0.00570226,
                            .LeftThigh: -0.80569,
                            .Head: -0.0912468,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.586285,
                            .RightUpperArm: 2.0986,
                            .UpperBody: 0.284385,
                            .RightThigh: 1.63151,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: 1.5, y: 50.5)),
                    angleCurve: .EaseIn,
                    positionCurve: .EaseIn),
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 3.69373,
                            .LeftShank: 0.0,
                            .RightFoot: -0.247026,
                            .RightShank: 4.39137,
                            .LowerBody: -0.00608504,
                            .LeftThigh: -0.273211,
                            .Head: -0.0912468,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.824496,
                            .RightUpperArm: 1.31525,
                            .UpperBody: 0.284385,
                            .RightThigh: 0.733764,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: -47.5, y: 75.0)),
                    angleCurve: .EaseInOut,
                    positionCurve: .EaseInOut),
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 3.27326,
                            .LeftShank: 0.0,
                            .RightFoot: -0.630671,
                            .RightShank: 0.0,
                            .LowerBody: 0.00570226,
                            .LeftThigh: -0.807824,
                            .Head: -0.0912468,
                            .RightForearm: 0.0,
                            .LeftFoot: 1.1904,
                            .RightUpperArm: 1.31525,
                            .UpperBody: 0.284385,
                            .RightThigh: -0.345202,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: -55.0, y: 54.5)),
                    angleCurve: .EaseInOut,
                    positionCurve: .EaseInOut),
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 5.81391,
                            .LeftShank: 0.0,
                            .RightFoot: -0.630671,
                            .RightShank: 0.0,
                            .LowerBody: -0.0205477,
                            .LeftThigh: -0.0388211,
                            .Head: -0.00862047,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.566645,
                            .RightUpperArm: 0.268806,
                            .UpperBody: 0.0788321,
                            .RightThigh: -0.0628608,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: -55.0, y: 54.5)),
                    angleCurve: .EaseInOut,
                    positionCurve: .EaseInOut)],
            levelOfIntensity: 2,
            style: .Ballet,
            name: "Jump"
        )
        
        
        _ = DanceMove(
            keyframes:
            [
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 3.46564,
                            .LeftShank: 0.0,
                            .RightFoot: -1.04853,
                            .RightShank: 0.0,
                            .LowerBody: 0.131968,
                            .LeftThigh: 0.357753,
                            .Head: -0.0675434,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.383981,
                            .RightUpperArm: 2.18775,
                            .UpperBody: -0.0779667,
                            .RightThigh: -0.18047,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: 0.0, y: 0.0)),
                    angleCurve: .EaseInOut,
                    positionCurve: .EaseInOut),
                Keyframe(
                    time: 0.25,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: -1.52955,
                            .LeftShank: 0.0,
                            .RightFoot: -1.04853,
                            .RightShank: 0.0,
                            .LowerBody: -0.0340058,
                            .LeftThigh: 0.0958173,
                            .Head: -0.0675434,
                            .RightForearm: 1.36451,
                            .LeftFoot: 1.07728,
                            .RightUpperArm: 1.23077,
                            .UpperBody: 0.0880073,
                            .RightThigh: -0.18047,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: 0.0, y: 0.0)),
                    angleCurve: .Linear,
                    positionCurve: .Linear),
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 4.75077,
                            .LeftShank: 0.0,
                            .RightFoot: -1.04853,
                            .RightShank: 0.0,
                            .LowerBody: 0.0119394,
                            .LeftThigh: -0.31074,
                            .Head: -0.0675434,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.717573,
                            .RightUpperArm: 2.02797,
                            .UpperBody: 0.302059,
                            .RightThigh: 1.98101,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: 33.0, y: 10.5)),
                    angleCurve: .EaseInOut,
                    positionCurve: .EaseInOut),
                Keyframe(
                    time: 0.25,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 3.5973,
                            .LeftShank: 0.0,
                            .RightFoot: -0.612152,
                            .RightShank: 0.0,
                            .LowerBody: 0.0419922,
                            .LeftThigh: -0.0650642,
                            .Head: -0.0365098,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.717573,
                            .RightUpperArm: 2.46326,
                            .UpperBody: 0.110657,
                            .RightThigh: 2.52416,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: 0.0, y: 0.0)),
                    angleCurve: .Linear,
                    positionCurve: .Linear),
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: -1.48754,
                            .LeftShank: 0.0,
                            .RightFoot: -0.977011,
                            .RightShank: 0.0,
                            .LowerBody: 0.0419922,
                            .LeftThigh: -0.0650642,
                            .Head: 0.0424993,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.717573,
                            .RightUpperArm: 2.2369,
                            .UpperBody: 0.110657,
                            .RightThigh: 1.42952,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: 0.0, y: 0.0)),
                    angleCurve: .EaseInOut,
                    positionCurve: .EaseInOut),
                Keyframe(
                    time: 0.25,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: -1.48754,
                            .LeftShank: 0.0,
                            .RightFoot: -0.977011,
                            .RightShank: 0.0,
                            .LowerBody: 0.400103,
                            .LeftThigh: -0.379437,
                            .Head: 0.0424993,
                            .RightForearm: 0.0,
                            .LeftFoot: 0.717573,
                            .RightUpperArm: 0.744297,
                            .UpperBody: -0.247454,
                            .RightThigh: -0.0825132,
                            .LeftForearm: 0.0],
                        position: CGPoint(x: 70.5, y: -1.5)),
                    angleCurve: .EaseIn,
                    positionCurve: .EaseIn),
                Keyframe(
                    time: 0.5,
                    posture: Posture(
                        angles: [
                            .LeftUpperArm: 5.30193,
                            .LeftShank: 0.0,
                            .RightFoot: -0.842332,
                            .RightShank: 0.0,
                            .LowerBody: 6.24902,
                            .LeftThigh: -1.37788,
                            .Head: 0.0424993,
                            .RightForearm: 0.0,
                            .LeftFoot: -0.0297143,
                            .RightUpperArm: 2.68168,
                            .UpperBody: -1.87592,
                            .RightThigh: -4.33473,
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 175.5, y: -53.0)), 
                    angleCurve: .EaseOut, 
                    positionCurve: .EaseOut), 
                Keyframe( 
                    time: 0.5, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 5.30193, 
                            .LeftShank: 1.54982, 
                            .RightFoot: -0.820717, 
                            .RightShank: 0.0, 
                            .LowerBody: -0.108704, 
                            .LeftThigh: -0.389659, 
                            .Head: 0.0117745, 
                            .RightForearm: 0.0, 
                            .LeftFoot: 0.966278, 
                            .RightUpperArm: 0.662649, 
                            .UpperBody: -0.71465, 
                            .RightThigh: 0.786815, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 138.0, y: 9.5)), 
                    angleCurve: .CubicEaseOut, 
                    positionCurve: .EaseInOut), 
                Keyframe( 
                    time: 0.5, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 5.69831, 
                            .LeftShank: 0.00267446, 
                            .RightFoot: -0.906331, 
                            .RightShank: 0.0, 
                            .LowerBody: -0.0339541, 
                            .LeftThigh: -0.113877, 
                            .Head: -0.00190135, 
                            .RightForearm: -0.583607, 
                            .LeftFoot: 0.966278, 
                            .RightUpperArm: 0.403364, 
                            .UpperBody: 0.0699511, 
                            .RightThigh: 0.00145823, 
                            .LeftForearm: 0.57673], 
                        position: CGPoint(x: 66.5621, y: 3.50381)), 
                    angleCurve: .EaseInOut, 
                    positionCurve: .EaseInOut)], 
            levelOfIntensity: 4,
            style: .Ballet,
            name: "Kick"
        )
        
        
        _ = DanceMove(
            keyframes:
            [
                Keyframe( 
                    time: 0.25, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 0.97423, 
                            .LeftShank: 0.0, 
                            .RightFoot: -0.945122, 
                            .RightShank: 0.0, 
                            .LowerBody: -0.021294, 
                            .LeftThigh: -0.308376, 
                            .Head: 0.0974797, 
                            .RightForearm: 0.0, 
                            .LeftFoot: 0.656701, 
                            .RightUpperArm: -1.24446, 
                            .UpperBody: 0.15595, 
                            .RightThigh: 0.0436575, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: -32.8857, y: 31.8723)), 
                    angleCurve: .EaseIn, 
                    positionCurve: .EaseIn), 
                Keyframe( 
                    time: 0.5, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 1.73968, 
                            .LeftShank: 1.98903, 
                            .RightFoot: -0.841142, 
                            .RightShank: 0.0, 
                            .LowerBody: 0.166036, 
                            .LeftThigh: -0.863789, 
                            .Head: -0.00667751, 
                            .RightForearm: 0.0, 
                            .LeftFoot: 0.79729, 
                            .RightUpperArm: 1.43212, 
                            .UpperBody: -0.871604, 
                            .RightThigh: 0.709391, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 50.0, y: 38.5)), 
                    angleCurve: .EaseOut, 
                    positionCurve: .EaseOut), 
                Keyframe( 
                    time: 0.5, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 5.17036, 
                            .LeftShank: 0.0, 
                            .RightFoot: -0.842378, 
                            .RightShank: 0.0, 
                            .LowerBody: -0.336514, 
                            .LeftThigh: -1.40965, 
                            .Head: -0.00834692, 
                            .RightForearm: 0.0, 
                            .LeftFoot: 0.772243, 
                            .RightUpperArm: 2.53879, 
                            .UpperBody: 0.0144103, 
                            .RightThigh: 0.314909, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 41.1143, y: 42.3723)), 
                    angleCurve: .EaseInOut, 
                    positionCurve: .EaseInOut), 
                Keyframe( 
                    time: 0.375, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 4.52589, 
                            .LeftShank: 0.0, 
                            .RightFoot: -0.842378, 
                            .RightShank: 0.0, 
                            .LowerBody: -0.0173122, 
                            .LeftThigh: -0.117622, 
                            .Head: -0.00834692, 
                            .RightForearm: 0.0, 
                            .LeftFoot: 0.779644, 
                            .RightUpperArm: 0.720923, 
                            .UpperBody: 0.0144103, 
                            .RightThigh: -0.0581945, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 21.1143, y: 45.3723)), 
                    angleCurve: .Linear, 
                    positionCurve: .Linear), 
                Keyframe( 
                    time: 0.375, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 3.82741, 
                            .LeftShank: 0.0, 
                            .RightFoot: -0.842378, 
                            .RightShank: 0.0, 
                            .LowerBody: -0.0499746, 
                            .LeftThigh: 0.154491, 
                            .Head: -0.00834692, 
                            .RightForearm: 0.0, 
                            .LeftFoot: -0.055426, 
                            .RightUpperArm: 4.5426, 
                            .UpperBody: 0.0144103, 
                            .RightThigh: 1.85545, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: 15.6143, y: 17.3723)), 
                    angleCurve: .EaseOut, 
                    positionCurve: .EaseOut), 
                Keyframe( 
                    time: 0.25, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 4.02946, 
                            .LeftShank: 0.0, 
                            .RightFoot: 0.314096, 
                            .RightShank: 0.0, 
                            .LowerBody: -0.185515, 
                            .LeftThigh: 0.252443, 
                            .Head: 0.346802, 
                            .RightForearm: 0.0, 
                            .LeftFoot: 0.94479, 
                            .RightUpperArm: 3.14238, 
                            .UpperBody: 0.0693445, 
                            .RightThigh: 1.75809, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: -59.8857, y: 89.8723)), 
                    angleCurve: .EaseInOut, 
                    positionCurve: .EaseInOut), 
                Keyframe( 
                    time: 0.25, 
                    posture: Posture( 
                        angles: [
                            .LeftUpperArm: 0.572973, 
                            .LeftShank: 0.0, 
                            .RightFoot: 0.0314241, 
                            .RightShank: 0.0, 
                            .LowerBody: -0.0185601, 
                            .LeftThigh: 0.0252559, 
                            .Head: 0.0346962, 
                            .RightForearm: 0.0, 
                            .LeftFoot: 0.0945225, 
                            .RightUpperArm: 5.52748, 
                            .UpperBody: 0.00693765, 
                            .RightThigh: 0.17589, 
                            .LeftForearm: 0.0], 
                        position: CGPoint(x: -5.99133, y: 8.99136)), 
                    angleCurve: .EaseIn, 
                    positionCurve: .EaseIn)], 
            levelOfIntensity: 3,
            style: .Ballet,
            name: "Hop"
        )
    }

}