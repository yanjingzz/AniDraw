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
    
    var characterNode: CharacterNode? {
        didSet {
            updateCharacter()
        }
    }
    
    let scene = CharactersScene(fileNamed:"DanceScene")!
    
   
    
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
        print("Character controller update character.")
        scene.characterNode = characterNode
    }
    

    
    

}

