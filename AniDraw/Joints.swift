//
//  Joints.swift
//  AniDraw
//
//  Created by Mike on 6/30/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation
enum JointName: String {
    case Neck = "Neck"
    case Waist = "Waist"
    case LeftShoulder = "Left Shoulder"
    case LeftElbow = "Left Elbow"
    case LeftWrist = "Left Wrist"
    case LeftHip = "Left Hip"
    case LeftKnee = "Left Knee"
    case LeftAnkle = "Left Ankle"
    case RightShoulder = "Right Shoulder"
    case RightElbow = "Right Elbow"
    case RightWrist = "Right Wrist"
    case RightHip = "Right Hip"
    case RightKnee = "Right Knee"
    case RightAnkle = "Right Ankle"
    
    static var allJoints: [JointName] {
        return [
            .Neck,
            .Waist,
            .LeftShoulder,
            .LeftElbow,
            .LeftWrist,
            .LeftHip,
            .LeftKnee,
            .LeftAnkle,
            .RightShoulder,
            .RightElbow,
            .RightWrist,
            .RightHip,
            .RightKnee,
            .RightAnkle
        ]
    }
}