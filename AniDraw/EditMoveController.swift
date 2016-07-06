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
    var postures = [Posture]()
    
    @IBAction func addPosture(sender: UIButton) {
        if let c = characterNode {
            let p = c.posture
            postures.append(p)
        }
       
    }
    @IBAction func restorePosture(sender: UIButton) {
        characterNode?.posture = Posture.idle
    }
    
    @IBAction func playAnimation(sender: UIButton) {
        let danceMove = DanceMove(withSeriesOfPostures: postures, ofEqualInterval: 0.5)
        scene.playAnimation(danceMove)
        print("[")
        for posture in postures {
            posture.printConstructor()
        }
        print("]")
    }
    
    var characterNode: CharacterNode? {
        didSet {
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

