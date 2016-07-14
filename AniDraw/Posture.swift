//
//  Posture.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

struct Posture: CustomStringConvertible {
    var angles: [BodyPartName:CGFloat]
    var position: CGPoint
    init (angles: [BodyPartName:CGFloat], position: CGPoint) {
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
    static let idle = Posture(position: CGPoint(x: 0, y: 0))
    var description: String {
        var string = "Posture( \n"
        string += "    angles: [\n"
        for (i,(name, angle)) in angles.enumerate() {
            if i != angles.count - 1 {
                string += "    .\(name): \(angle), \n"
            } else {
                string += "    .\(name): \(angle)], \n"
            }
        }
        string += "    position: CGPoint(x: \(position.x), y: \(position.y)))"
        return string
    }
    
    var flipped: Posture {
        let newPosition = CGPoint(x: -position.x, y: position.y)
        var newAngles = [BodyPartName:CGFloat]()
        for (name, angle) in angles {
            switch name {
            case name where name.rawValue >= 8:
                let newName = BodyPartName(rawValue: name.rawValue - 5)!
                newAngles[newName] = -angle
            case name where name.rawValue >= 3:
                let newName = BodyPartName(rawValue: name.rawValue + 5)!
                newAngles[newName] = -angle
            default:
                newAngles[name] = -angle
            }
        }
        return Posture(angles: newAngles, position: newPosition)
    }
}