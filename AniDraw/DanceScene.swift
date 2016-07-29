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
    
    let danceModel = DanceModel()
    
    var lastUpdateTime : CFTimeInterval = 0
    var dt : CFTimeInterval = 0
    var characterNode: CharacterNode!
    
    var amplitudePeakLabel = SKLabelNode()
    var amplitudeAverageLabel = SKLabelNode()
    var pitchLabel = SKLabelNode()
    var tempoLabel = SKLabelNode()
    var levelLabel = SKLabelNode()
    var durationLabel = SKLabelNode()
    var singStatusLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
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
        
        characterNode.position = CGPoint(x: size.width/2, y: size.height/2)
        characterNode.zPosition = 100
        addChild(characterNode)

    }
    
    override func willMoveFromView(view: SKView) {
    }

    
    override func update(currentTime: CFTimeInterval) {


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
//        
//        amplitudePeakLabel.text = "Peak: \(audioInput.amplitude)"
////        amplitudeAverageLabel.text = "Average: \(average) (\(pow(10,average/20)))"
//        pitchLabel.text = "Frenquency: \(audioInput.tracker.frequency)"
////        tempoLabel.text = "Tempo: \(danceModel.tempo)"
//        if audioInput.isSinging {
//            durationLabel.text = "Duration: \(audioInput.singingDuration!)"
//        } else {
//            durationLabel.text = ""
//        }
//        singStatusLabel.text = "IsSinging: \(audioInput.isSinging)"
        
        levelLabel.text = "Level: \(danceModel.currentLevel ?? 0), index: \(danceModel.currentIndex ?? 0)"
        tempoLabel.text = "Ave: \(danceModel.pitchAverage ?? 0), count: \(danceModel.lastPitches.count)"
        pitchLabel.text = "Frenquency: \(danceModel.currentPitch)"
        amplitudePeakLabel.text = "Peak: \(danceModel.currentDecibel)"
        amplitudeAverageLabel.text = "Higher: \(danceModel.pitchHigherBound), Lower: \(danceModel.pitchLowerBound)"
        
        
        
        characterNode.posture = danceModel.getPostureByIntervalTime(dt)
        

    }
    

}
