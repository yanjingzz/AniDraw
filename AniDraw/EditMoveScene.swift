//
//  CharactersScene.swift
//  AniDraw
//
//  Created by Mike on 7/1/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import SpriteKit

class EditMoveScene: SKScene {
    var characterNode: CharacterNode? {
        willSet {
            if let character = characterNode {
                scene?.removeChildrenInArray([character])
            }
           
        }
        didSet {
            if let character = characterNode {
                character.position = CGPoint(x: size.width / 2, y: size.height / 2)
                character.zPosition = 100
                scene?.addChild(character)
            }
        }
    }
    override func didMoveToView(view: SKView) {
        
        characterNode?.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }

    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        if let node = touchedSprite, let angle = angleToRotate {
            node.zRotation = angle - node.parent!.zRotation
            
            

        }
        
    }
    
    var lastUpdateTime: NSTimeInterval = 0
    var lastTouchLocation: CGPoint?
    var dt: NSTimeInterval = 0
    var touchedSprite: BodyPartNode?
    var angleToRotate: CGFloat?

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        lastTouchLocation = touchLocation
        touchedSprite = nodeAtPoint(touchLocation) as? BodyPartNode
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        lastTouchLocation = touchLocation
        if let node = touchedSprite {
            let p1 = self.convertPoint(node.position, fromNode: node.parent!)
            let p2 = touchLocation
            angleToRotate = (p2 - p1).angle + CGFloat(M_PI_2)
        }

    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchedSprite = nil
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touchedSprite = nil
    }
    
    func moveCharacter(translationInView: CGPoint) {
        let translation = CGPoint(x: translationInView.x, y: -translationInView.y)

        characterNode?.position += translation
    }

        
}