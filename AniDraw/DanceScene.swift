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
    
    var amplitudeLabel = SKLabelNode()
    var pitchLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        danceModel = DanceModel(center: CGPoint(x: 0, y: 0))
        print(characterNode?.posture)
        
        amplitudeLabel.position = CGPoint(x: size.width - 150 , y: size.height - 40)
        pitchLabel.position = CGPoint(x: size.width - 110 , y: size.height - 100)
        addChild(amplitudeLabel)
        addChild(pitchLabel)
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
//            print("shake!")
//            print(node.parts[.Head]!.zRotation)
        }
        
        danceModel.audioRecorder.updateMeters()
        danceModel.amplitude = CGFloat(danceModel.audioRecorder.peakPowerForChannel(0))
        
        amplitudeLabel.text = "Amplitude: " + String(danceModel.amplitude)
        pitchLabel.text = "Pitch: " + String(danceModel.pitch)
    }
    

}
