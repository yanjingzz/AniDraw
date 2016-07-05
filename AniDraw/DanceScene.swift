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
    
    var lastUpdateTime : CFTimeInterval = 0
    var dt : CFTimeInterval = 0
    var posture:Posture!
    var characterNode: CharacterNode? {
        willSet {
             if let c = characterNode {
                removeChildrenInArray([c])
            }
        }
        didSet {
            if let c = characterNode {
                
                if let v = view {
                    c.position = v.bounds.center
                }
                addChild(c)
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        var angles = [BodyPartName:CGFloat]()
        
        for part in BodyPartName.allParts {
            angles[part] = 0
        }
        posture = Posture(position: CGPoint(x: size.width/2, y: size.height/2))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        for part in BodyPartName.allParts {
            if posture.angles[part] != nil {
                posture.angles[part] = posture.angles[part]! + CGFloat(dt * 100)
            }
        }
        characterNode?.positionNodeForPosture(posture)
        print(characterNode?.children)
//        for part in BodyPartName.allParts {
//            print("\(part): \(characterNode?.parts[part]?.zRotation)")
//
//        }
        
//        var posture = getPostureByIntervalTime(time)
//        characterNode?.positionNodeForPosture(posture)
    }
    

}
