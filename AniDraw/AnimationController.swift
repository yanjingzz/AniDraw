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
    var characterNode: CharacterNode!
    var audioController: AEAudioController!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScene()
        
        
        audioController = (UIApplication.sharedApplication().delegate as! AppDelegate).audioController
        do {
            try audioController.start()
        } catch {
            print("Audio controller cannot start!")
        }
        let receiver = MyAudioReceiver()
        audioController.addInputReceiver(receiver)
        MyAudioReceiver.setDelegate(scene.danceModel)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        audioController.stop()
    }
    
    private func setUpScene() {
        scene = DanceScene(fileNamed:"DanceScene")
        scene.characterNode = characterNode
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        scene.characterNode = characterNode
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



}
