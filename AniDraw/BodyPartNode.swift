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
    var initialZRotation: CGFloat = 0.0
    convenience init(bodyPartName: BodyPartName, texture: SKTexture) {
        
        self.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        self.bodyPartName = bodyPartName
        self.zPosition = bodyPartName.zPosition
        
    }
    override var zRotation: CGFloat {
        get {
            return super.zRotation - initialZRotation
        }
        set {
            super.zRotation = newValue + initialZRotation
        }
    }

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
    
    static var count: Int {
        return BodyPartName.RightFoot.rawValue + 1
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
    
    var directionJoints: (JointName, JointName) {
        switch self {
        case Head:
            return (.Neck, .Neck)
        case UpperBody:
            return (.Neck, .Waist)
        case LowerBody:
            return (.Waist, .Waist)
        case LeftUpperArm:
            return (.LeftShoulder, .LeftElbow)
        case .LeftForearm:
            return (.LeftElbow, .LeftWrist)
        case LeftThigh:
            return (.LeftHip, .LeftKnee)
        case LeftShank:
            return (.LeftKnee, .LeftAnkle)
        case .LeftFoot:
            return (.LeftAnkle, .LeftAnkle)

        case RightUpperArm:
            return (.RightShoulder, .RightElbow)
        case .RightForearm:
            return (.RightElbow, .RightWrist)
        case RightThigh:
            return (.RightHip, .RightKnee)
        case RightShank:
            return (.RightKnee, .RightAnkle)
        case .RightFoot:
            return (.RightAnkle, .RightAnkle)
        }
    }
    
    var directionForInitializingCharacterNode: (JointName, JointName) {
        switch self {
        case Head: fallthrough
        case UpperBody: fallthrough
        case LowerBody:
            return (.Neck, .Waist)
        case LeftUpperArm:
            return (.LeftShoulder, .LeftElbow)
        case .LeftForearm:
            return (.LeftElbow, .LeftWrist)
        case LeftThigh:
            return (.LeftHip, .LeftKnee)
        case LeftShank: fallthrough
        case .LeftFoot:
            return (.LeftKnee, .LeftAnkle)
            
        case RightUpperArm:
            return (.RightShoulder, .RightElbow)
        case .RightForearm:
            return (.RightElbow, .RightWrist)
        case RightThigh:
            return (.RightHip, .RightKnee)
        case RightShank: fallthrough
        case .RightFoot:
            return (.RightKnee, .RightAnkle)
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
    
    var zPosition: CGFloat{
        switch self {
        case LeftUpperArm:
            return 9
        case .LeftForearm:
            return 10
        case RightUpperArm:
            return 9
        case .RightForearm:
            return 10
        default:
            return 0
        }
    }
    //seq: UpperBody->LowerBody->UpperArm->Thigh->Shank->Foot->Forearm->Head

//    //as joints' bound,left,right,up,down
//    var bounds: (JointName?,JointName?,JointName?,JointName?) {
//        switch self {
//        case Head:
//            return (nil,nil,nil,.Neck)
//        case UpperBody:
//            return (.LeftElbow,.RightElbow,.Neck,.Waist)
//        case LowerBody:
//            return (.LeftElbow,.RightElbow,.Waist,nil)
//        case LeftUpperArm:
//            return (nil,.Waist,nil,nil)
//        case .LeftForearm:
//            return (nil,.Waist,nil,nil)
//        case LeftThigh:
//            return (nil,.Waist,.LeftHip,.LeftKnee)
//        case LeftShank:
//            return (nil,.Waist,.LeftKnee,.LeftAnkle)
//        case .LeftFoot:
//            return (nil,.Waist,.LeftAnkle,nil)
//        case RightUpperArm:
//            return (.Waist,nil,nil,nil)
//        case .RightForearm:
//            return (.Waist,nil,nil,nil)
//        case RightThigh:
//            return (.Waist,nil,.RightHip,.RightKnee)
//        case RightShank:
//            return (.Waist,nil,.RightKnee,.RightAnkle)
//        case RightFoot:
//            return (.Waist,nil,.RightAnkle,nil)
//            
//        }
//    }
}