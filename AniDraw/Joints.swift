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
    
    var DriveBodyPart: BodyPartName {
        switch self {
        case .Neck:
            return .Head
        case .Waist:
            return .LowerBody
        case .LeftShoulder:
            return .LeftUpperArm
        case .LeftElbow:
            return .LeftForearm
        case .LeftWrist:
            return .LeftForearm
        case .LeftHip:
            return .LeftThigh
        case .LeftKnee:
            return .LeftShank
        case .LeftAnkle:
            return .LeftFoot
        case .RightShoulder:
            return .RightUpperArm
        case .RightElbow:
            return .RightForearm
        case .RightWrist:
            return .RightForearm
        case .RightHip:
            return .RightThigh
        case .RightKnee:
            return .RightShank
        case .RightAnkle:
            return .RightFoot
        }
    }
    
    //left,right,up,down:
    //nil:
    //left->leftBounds=0
    //right->rightBounds=matrixWidth-1
    //up->upBounds=0
    //down->downBounds=matrixHeight-1
    
    var bounds:(JointName?,JointName?,JointName?,JointName?) {
        switch self {
        case .Neck:
            return (.LeftShoulder,.RightShoulder,nil,.Waist)
        case .Waist:
            return (.LeftElbow,.RightElbow,.Neck,.LeftHip)
        case .LeftShoulder:
            return (nil,.Neck,nil,nil)
        case .LeftElbow:
            return (nil,.Waist,nil,nil)
        case .LeftWrist:
            return (nil,.Waist,nil,nil)
        case .LeftHip:
            return (nil,.Waist,.Waist,.LeftKnee)
        case .LeftKnee:
            return (nil,.Waist,.LeftHip,.LeftAnkle)
        case .LeftAnkle:
            return (nil,.Waist,.LeftKnee,nil)
        case .RightShoulder:
            return (.Waist,nil,nil,nil)
        case .RightElbow:
            return (.Waist,nil,nil,nil)
        case .RightWrist:
            return (.Waist,nil,nil,nil)
        case .RightHip:
            return (.Waist,nil,.Waist,.RightKnee)
        case .RightKnee:
            return (.Waist,nil,.RightHip,.RightAnkle)
        case .RightAnkle:
            return (.Waist,nil,.RightKnee,nil)
        }
    }
    
    var addPart:(BodyPartName?,BodyPartName?) {
        switch self {
        case .Neck:
            return (.Head,nil)
        case .Waist:
            return (.LowerBody,.UpperBody)
        case .LeftShoulder:
            return (.LeftUpperArm,.UpperBody)
        case .LeftElbow:
            return (.LeftUpperArm,.LeftForearm)
        case .LeftHip:
            return (.LeftThigh,.LowerBody)
        case .LeftKnee:
            return (.LeftThigh,.LeftShank)
        case .LeftAnkle:
            return (.LeftShank,.LeftFoot)
        case .RightShoulder:
            return (.RightUpperArm,.UpperBody)
        case .RightElbow:
            return (.RightUpperArm,.RightForearm)
        case .RightHip:
            return (.RightThigh,.LowerBody)
        case .RightKnee:
            return (.RightThigh,.RightShank)
        case .RightAnkle:
            return (.RightShank,.RightFoot)
        default:
            return (nil,nil)
        }
    }
    
}

