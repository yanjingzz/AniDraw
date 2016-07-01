//
//  BodyNode.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import SpriteKit

class CharacterNode: SKNode {
    var parts = [BodyPartName: BodyPartNode]()
    func positionChildNodeForPosture(posture: Posture) {
    }
    
    convenience init(bodyPartImages:[BodyPartName: CGImage],imagesFrame: [BodyPartName: CGRect], jointsPosition: [JointName: CGPoint]) {
        self.init()
        var absolutePosition = [BodyPartName: CGPoint]()
        for part in BodyPartName.allParts {
            guard let image = bodyPartImages[part],let frame = imagesFrame[part], let anchorPositionInView = jointsPosition[part.anchorJoint] else {
                print("Imcomplete information fot part \(part)")
                continue
            }
            let node = BodyPartNode(texture: SKTexture(CGImage: image))
            let anchorPosition = CGPoint(x: anchorPositionInView.x, y: -anchorPositionInView.y)
            let anchorX =  (anchorPosition.x - frame.minX) / (frame.maxX - frame.minX)
            let anchorY =  (frame.maxY + anchorPosition.y) / (frame.maxY - frame.minY)
            node.anchorPoint = CGPoint(x: anchorX, y: anchorY)
            absolutePosition[part] = anchorPosition
            node.bodyPartName = part
            parts[part] = node
        }
        
        for (part, node) in parts {
            for childPart in part.childPart {
                if let childNode = parts[childPart] {
                    childNode.position =  absolutePosition[childPart]! - absolutePosition[part]!
                    node.addChild(childNode)
                }
                
                
            }
            if part.parentPart == nil {
                self.addChild(node)
                node.position = CGPoint.zero
            }
        }
        for (part, node) in parts {
            print("\(part): achorpoint \(node.anchorPoint), position \(node.position) ")
        }
        
        
        
    }
}
