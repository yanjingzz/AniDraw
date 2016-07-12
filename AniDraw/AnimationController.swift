//
//  AnimationController.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import SpriteKit
import UIKit

class AnimationController: UIViewController {

    @IBOutlet weak var skView: SKView!
    
    var scene: DanceScene!
    var characterNode: CharacterNode? {
        didSet {
            guard let scene = scene, let character = characterNode else {
                return
            }
            scene.characterNode = character
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScene()

    }
    private func setUpScene() {
        scene = DanceScene(fileNamed:"DanceScene")
        scene.characterNode = characterNode
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
    @IBAction func goBack(sender: AnyObject) {
        characterNode?.removeFromParent()
        dismissViewControllerAnimated(true) {
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
