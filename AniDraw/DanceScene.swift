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
    
    let danceModel = DanceModel(center: CGPoint(x: 0, y: 0))
    private let audioInput = AudioInput.sharedInstance
    
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
    
    var amplitudePeakLabel = SKLabelNode()
    var amplitudeAverageLabel = SKLabelNode()
    var pitchLabel = SKLabelNode()
    var tempoLabel = SKLabelNode()
    var levelLabel = SKLabelNode()
    var durationLabel = SKLabelNode()
    var singStatusLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        print(characterNode?.posture)
        
        amplitudePeakLabel.fontSize = 20
        amplitudeAverageLabel.fontSize = 20
        
        pitchLabel.fontSize = 20
        tempoLabel.fontSize = 20
        durationLabel.fontSize = 20
        levelLabel.fontSize = 20
        singStatusLabel.fontSize = 20
        
        amplitudePeakLabel.position = CGPoint(x: size.width - 180 , y: size.height - 40)
        amplitudeAverageLabel.position = CGPoint(x: size.width - 180 , y: size.height - 70)
        pitchLabel.position = CGPoint(x: size.width - 150 , y: size.height - 100)
        tempoLabel.position = CGPoint(x: size.width - 150 , y: size.height - 130)
        durationLabel.position = CGPoint(x: size.width - 160, y: size.height - 160)
        levelLabel.position = CGPoint(x: size.width - 150 , y: size.height - 190)
        singStatusLabel.position = CGPoint(x: size.width - 150, y: size.height - 220)
        
        addChild(amplitudePeakLabel)
        addChild(amplitudeAverageLabel)
        addChild(pitchLabel)
        addChild(tempoLabel)
        addChild(durationLabel)
        addChild(levelLabel)
        addChild(singStatusLabel)
        
        audioInput.start()
        audioInput.delegate = danceModel
    }
    
    override func willMoveFromView(view: SKView) {
        audioInput.stop()
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
        
//        danceModel.updateStatic(dt)
        
//        let peak = danceModel.peakAmplitude
//        let average = danceModel.averageAmplitude
//        let singStatus = danceModel.isSing == true ? "Singing" : "Waiting"
        audioInput.update()
        amplitudePeakLabel.text = "Peak: \(audioInput.amplitude)"
//        amplitudeAverageLabel.text = "Average: \(average) (\(pow(10,average/20)))"
        pitchLabel.text = "Frenquency: \(audioInput.tracker.frequency)"
//        tempoLabel.text = "Tempo: \(danceModel.tempo)"
        if audioInput.isSinging {
            durationLabel.text = "Duration: \(audioInput.singingDuration!)"
        } else {
            durationLabel.text = ""
        }
        singStatusLabel.text = "IsSinging: \(audioInput.isSinging)"
        
        levelLabel.text = "Level: " + String(danceModel.chooseMethod())
        
        
        if let node = characterNode {
//            if danceModel.needIdle == true {
//                danceModel.abortDanceMove()
//                danceModel.needIdle = false
//            }
            node.posture = danceModel.getPostureByIntervalTime(dt)
//            print("shake!")
//            print(node.parts[.Head]!.zRotation)
        }
        

    }
    

}
