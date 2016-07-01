//
//  BodyPartNode.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import SpriteKit

class BodyPartNode: SKSpriteNode {
    var bodyPartName: BodyPartName!

}

enum BodyPartName: Int {
    case Head = 0
    case UpperBody
    case LowerBody
    case LeftUpperArm
    case LeftForearm
    case LeftThigh
    case LeftShank
    case LeftFoot
    case RightUpperArm
    case RightForearm
    case RightThigh
    case RightShank
    case RightFoot
    
    static var allParts: [BodyPartName] {
        get{
            var all = [BodyPartName]()
            var m = 0
            while let part = BodyPartName(rawValue: m) {
                all.append(part)
                m += 1
            }
            return all
        }
    }
    
    var childPart: [BodyPartName] {
        switch self {
        case UpperBody:
            return [.LowerBody, .Head, .LeftUpperArm, .RightUpperArm]
        case LowerBody:
            return [.LeftThigh, .RightThigh]
        case LeftUpperArm:
            return [.LeftForearm]
        case LeftThigh:
            return [.LeftShank]
        case LeftShank:
            return [.LeftFoot]
        case RightUpperArm:
            return [.RightForearm]
        case RightThigh:
            return [.RightShank]
        case RightShank:
            return [.RightFoot]
        default:
            return []
        }
    }
    var anchorJoint: JointName {
        switch self {
        case Head:
            return .Neck
        case UpperBody:
            return .Waist
        case LowerBody:
            return .Waist
        case LeftUpperArm:
            return .LeftShoulder
        case .LeftForearm:
            return .LeftElbow
        case LeftThigh:
            return .LeftHip
        case LeftShank:
            return .LeftKnee
        case .LeftFoot:
            return .LeftAnkle
        case RightUpperArm:
            return .RightShoulder
        case .RightForearm:
            return .RightElbow
        case RightThigh:
            return .RightHip
        case RightShank:
            return .RightKnee
        case .RightFoot:
            return .RightAnkle

        }
    }
    
    var parentPart: BodyPartName? {
        switch self {
        case Head:
            return .UpperBody
        case UpperBody:
            return nil
        case LowerBody:
            return .UpperBody
        case LeftUpperArm:
            return .UpperBody
        case .LeftForearm:
            return .LeftUpperArm
        case LeftThigh:
            return .LowerBody
        case LeftShank:
            return .LeftThigh
        case .LeftFoot:
            return .LeftShank
        case RightUpperArm:
            return .UpperBody
        case .RightForearm:
            return .RightUpperArm
        case RightThigh:
            return .LowerBody
        case RightShank:
            return .RightThigh
        case RightFoot:
            return .RightShank
        
        }
    }

}