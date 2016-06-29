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

enum BodyPartName {
    case Head
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
    
}