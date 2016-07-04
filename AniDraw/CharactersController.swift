//
//  ViewController.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
import SpriteKit

class CharactersController: UIViewController {
    
    @IBOutlet weak var skView: SKView!
    var characterNode: CharacterNode? {
        didSet {
            updateCharacter()
        }
    }
    
    let scene = CharactersScene(fileNamed:"DanceScene")!
    private struct Storyboard {
        static let DoneAddingCharacterIdentifier = "doneAddingCharacter"
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let character = Character.allCharacters()?.first {
            characterNode = CharacterNode(character: character)
            print(character.name)
            
        }
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func updateCharacter() {
        print("Character controller update character.")
        scene.characterNode = characterNode
    }
    
    @IBAction func unwindToCharactersController(segue: UIStoryboardSegue) {
//        if let identifier = segue.identifier where identifier == Storyboard.DoneAddingCharacterIdentifier {
//            displayCharacter()
//
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let ident = segue.identifier else{
            return
        }
        switch ident {
        case "dance":
            if let destVC = segue.destinationViewController as? AnimationController {
                destVC.characterNode = characterNode?.copy() as! CharacterNode?
            }
        default:
            break
        }
    }

}

