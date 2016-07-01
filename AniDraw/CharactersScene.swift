//
//  CharactersScene.swift
//  AniDraw
//
//  Created by Mike on 7/1/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import SpriteKit

class CharactersScene: SKScene {
    var characterNode: CharacterNode? {
        willSet {
            if let character = characterNode {
                scene?.removeChildrenInArray([character])
            }
           
        }
        didSet {
            if let character = characterNode {
                print("Character scene display character")
                character.position = view?.bounds.center ?? CGPointZero
                character.zPosition = 100
                scene?.addChild(character)
            }
        }
    }
    override func didMoveToView(view: SKView) {
    }

    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
        
        
}