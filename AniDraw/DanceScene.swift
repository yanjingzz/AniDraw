//
//  AnimationScene.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import SpriteKit

class DanceScene: SKScene {
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

    }
    func shakeAngle(maximumAngleInDegrees maxAngle: CGFloat, currentTime: CFTimeInterval, cycle: CGFloat) -> CGFloat {
        let ret =  maxAngle.degreesToRadians() * sin(CGFloat(currentTime) / cycle * 2 * CGFloat(M_PI))
        return ret
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if let node = characterNode {
            var posture = node.posture
            posture.angles[.Head] = shakeAngle(maximumAngleInDegrees: 20, currentTime: currentTime, cycle: 1.5)
            node.posture = posture
        }
    }
    

}
