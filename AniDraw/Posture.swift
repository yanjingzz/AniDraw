//
//  Posture.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

struct Posture {
    var angles: [BodyPartName:CGFloat]
    var position: CGPoint
    init? (angles: [BodyPartName:CGFloat], position: CGPoint) {
        for part in BodyPartName.allParts {
            if angles[part] != nil {
                return nil
            }
        }
        self.angles = angles
        self.position = position
    }
    init(characterNode: CharacterNode) {
        angles = [BodyPartName:CGFloat]()
        for (name, node) in characterNode.parts {
            angles[name] = node.zRotation
        }
        position = characterNode.position
    }
    init(position: CGPoint) {
        angles = [BodyPartName:CGFloat]()
        for part in BodyPartName.allParts {
            angles[part] = 0
        }
        self.position = position
    }
}