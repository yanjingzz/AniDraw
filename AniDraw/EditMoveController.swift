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
            print(c.posture)
            postures.append(c.posture)
        }
       
    }
    
    @IBAction func playAnimation(sender: UIButton) {
        let danceMove = DanceMove(withSeriesOfPostures: postures, ofEqualInterval: 0.5)
        scene.playAnimation(danceMove)
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
        scene.characterNode = characterNode
        
    }
    

    
    

}

