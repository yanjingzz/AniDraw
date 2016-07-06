//
//  AnimationScene.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import SpriteKit
import UIKit

class DanceScene: SKScene {
    
    var danceModel : DanceModel!
    var lastUpdateTime : CFTimeInterval = 0
    var dt : CFTimeInterval = 0
    var characterNode: CharacterNode? {
        willSet {
             if let c = characterNode {
                removeChildrenInArray([c])
            }
        }
        didSet {
            if let c = characterNode {
                c.position = CGPoint(x: size.width/2, y: size.height/2)
                c.zPosition = 100
                addChild(c)
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        danceModel = DanceModel(center: CGPoint(x: size.width/2, y: size.height/2))
    }

//    func shakeAngle(maximumAngleInDegrees maxAngle: CGFloat, currentTime: CFTimeInterval, cycle: CGFloat) -> CGFloat {
//        let ret =  maxAngle.degreesToRadians() * sin(CGFloat(currentTime) / cycle * 2 * CGFloat(M_PI))
//        print(ret)
//        return ret
//    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
//        if let node = characterNode {
//            var posture = node.posture
//            posture.angles[.Head] = shakeAngle(maximumAngleInDegrees: 20, currentTime: currentTime, cycle: 1.5)
//            print(posture.angles[.Head])
//            node.posture = posture
//            print(node.parts[.Head]!.zRotation)
//        }

        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        if let node = characterNode {
            node.posture = danceModel.getPostureByIntervalTime(dt)
            print("shake!")
            print(node.parts[.Head]!.zRotation)
        }

//        for part in BodyPartName.allParts {
//            print("\(part): \(characterNode?.parts[part]?.zRotation)")
//
//        }
        
//        var posture = getPostureByIntervalTime(dt)
//        characterNode?.positionNodeForPosture(posture)
    }
    

}
