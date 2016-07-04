//
//  AnimationScene.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import SpriteKit

class DanceScene: SKScene {
    var characterNode: CharacterNode? {
        willSet {
             if let c = characterNode {
                removeChildrenInArray([c])
            }
        }
        didSet {
            if let c = characterNode {
                
                if let v = view {
                    c.position = v.bounds.center
                }
                addChild(c)
            }
        }
    }
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    

}
