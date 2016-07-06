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
        if playing {
            if let posture = danceMove?.getPostureByIntervalTime(dt) {
                characterNode?.posture = posture
            }
        }
    }
    
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    var touchedSprite: BodyPartNode?
    var touchedLocation: CGPoint?
    var angleToRotate: CGFloat?

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        touchedLocation = touch.locationInNode(self)
        touchedSprite = nodeAtPoint(touchedLocation!) as? BodyPartNode
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        rotatePart(towards: touch.locationInNode(self))

    }
    
    func rotatePart(towards location: CGPoint) {
        guard let node = touchedSprite else {
            return
        }
        let p1 = self.convertPoint(node.position, fromNode: node.parent!)
        let p2 = location
        switch node.bodyPartName! {
        case .Head:
            node.zRotation = (p2 - p1).angle - CGFloat(M_PI_2) - node.parent!.zRotation
        case .UpperBody:
            let delta = node.zRotation - (p2 - p1).angle + CGFloat(M_PI_2)
            node.zRotation -= delta
            characterNode?.parts[.LowerBody]?.zRotation += delta
            break
        case .LeftForearm:
            let l1 = node.position.length()
            let l2 = touchedLength
            let l3 = p2 -
            let (p2 - p1).angle + CGFloat(M_PI_2) - node.parent!.zRotation
        default:
            node.zRotation = (p2 - p1).angle + CGFloat(M_PI_2) - node.parent!.zRotation
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
    private var playing = false
    private var danceMove: DanceMove?
    
    func playAnimation(dance: DanceMove) {
        danceMove = dance
        print(danceMove?.previousPosture)
        danceMove?.reset()
        playing = true
    }

        
}