//
//  ViewController.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
import SpriteKit

class EditMoveController: UIViewController {
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var slider: UISlider!
    
    var postures = [Posture]() {
        didSet {
            slider.setValue(Float(currentIndex) / Float(postures.count), animated: false)
        }
    }
    var tempPosture: Posture?
    var currentIndex: Int = 0 {
        willSet {
            if currentIndex == postures.count {
                tempPosture = characterNode?.posture
            }
        }
        didSet {
            currentIndex.clamp(0, postures.count)
            if currentIndex < postures.count {
                
                characterNode?.posture = postures[currentIndex]
            } else if let posture = tempPosture {
                characterNode?.posture = posture
            }
            slider.setValue(Float(currentIndex) / Float(postures.count), animated: false)
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        if postures.isEmpty {
            currentIndex = 0
            slider.setValue(1,animated: false)
            return
        }
        let index = Int(round(slider.value * Float(postures.count)))
        currentIndex = index
        
        
    }
    
    @IBAction func addPosture(sender: UIButton) {
        if let c = characterNode {
            let p = c.posture
                postures.insert(p, atIndex: currentIndex)
        }
       
    }
    @IBAction func deletePosture(sender: AnyObject) {
        if currentIndex < postures.count {
            postures.removeAtIndex(currentIndex)
        }
    }
    
    @IBAction func restorePosture(sender: UIButton) {
        characterNode?.posture = Posture.idle
    }
    
    @IBAction func playAnimation(sender: UIButton) {
        if !postures.isEmpty {
            let danceMove = DanceMove(withSeriesOfPostures: postures, ofEqualInterval: 0.5)
            scene.playAnimation(danceMove)
            print("[")
            for posture in postures {
                posture.printConstructor()
            }
            print("]")
        }
        let random = Int.random(min: 1, max: 5)
        scene.playAnimation(MovesStorage.allMoves[random]![0])
    }
    
    var characterNode: CharacterNode? {
        didSet {
            print(characterNode)
            updateCharacter()
        }
    }
    
    let scene = EditMoveScene(fileNamed:"DanceScene")!
    
    @IBAction func moveCharacterForPanRecognizer(recognizer: UIPanGestureRecognizer) {

        scene.moveCharacter(recognizer.translationInView(skView))
        recognizer.setTranslation(CGPointZero, inView: skView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }
    
    
    func updateCharacter() {
        characterNode?.posture = Posture.idle
        scene.characterNode = characterNode
        
    }
    

    
    

}

