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
            let posture = dancePlayback.getPostureByIntervalTime(dt)
            characterNode?.posture = posture
            if dancePlayback.isEmpty {
                playing = false
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
        let touchedLocationInScene = touch.locationInNode(self)
        touchedSprite = nodeAtPoint(touchedLocationInScene) as? BodyPartNode
        if touchedSprite != nil {
            touchedLocation = touch.locationInNode(touchedSprite!)
        }
        
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
        case .LeftForearm, .RightForearm, .LeftShank, .RightShank:
            let l1 = node.position.length()
            let l2 = touchedLocation!.length()
            let l3 = node.parent!.convertPoint(p2, fromNode: self).length()
            let p0 = node.parent!.convertPoint(CGPoint.zero, toNode: self)
            if l3 > l1 + l2 {
                node.parent!.zRotation = (p2 - p0).angle + CGFloat(M_PI_2) - node.parent!.parent!.zRotation
                node.zRotation = 0
            } else if l3 < abs(l1 - l2) {
                node.zRotation = CGFloat.pi
                node.parent!.zRotation = -(p2 - p0).angle + CGFloat(M_PI_2) + node.parent!.parent!.zRotation
                
            } else {
                
                if (shortestAngleBetween((p1 - p0).angle,(p2 - p0).angle) > 0) {
                    node.zRotation = CGFloat.pi - acos((l2*l2 + l1*l1 - l3*l3) / (2*l1*l2))
                    node.parent!.zRotation = CGFloat.pi - acos((l3*l3 + l1*l1 - l2*l2) / (2*l1*l3)) + (p2 - p0).angle - CGFloat(M_PI_2) - node.parent!.parent!.zRotation
                } else {
                    node.zRotation = CGFloat.pi + acos((l2*l2 + l1*l1 - l3*l3) / (2*l1*l2))
                    node.parent!.zRotation = CGFloat.pi + acos((l3*l3 + l1*l1 - l2*l2) / (2*l1*l3)) + (p2 - p0).angle - CGFloat(M_PI_2) - node.parent!.parent!.zRotation
                }
            }
        
            
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
    var playing = false
    
    
    private var dancePlayback = DancePlayback()
    
    func playAnimation(dance: DanceMove) {
        dancePlayback.startDanceMove(dance.keyframes)
        playing = true
    }

        
}