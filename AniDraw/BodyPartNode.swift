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



}