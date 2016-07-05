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
        var absoluteRotation = [BodyPartName: CGFloat]()
        for part in BodyPartName.allParts {
            guard let image = bodyPartImages[part],let frame = imagesFrame[part], let anchorPositionInView = jointsPosition[part.anchorJoint] else {
                print("Imcomplete information fot part \(part)")
                continue
            }
            let node = BodyPartNode(bodyPartName: part, texture: SKTexture(CGImage: image))
            let anchorPosition = CGPoint(x: anchorPositionInView.x, y: -anchorPositionInView.y)
            let anchorX =  (anchorPosition.x - frame.minX) / (frame.maxX - frame.minX)
            let anchorY =  (frame.maxY + anchorPosition.y) / (frame.maxY - frame.minY)
            node.anchorPoint = CGPoint(x: anchorX, y: anchorY)
            let (j1, j2) = part.directionJoints
            let directionVec = jointsPosition[j1]! - jointsPosition[j2]!
            absoluteRotation[part] = directionVec.angle + CGFloat(M_PI_2)
            
            absolutePosition[part] = anchorPosition
            parts[part] = node
        }
        
        for (part, node) in parts {
            for childPart in part.childPart {
                if let childNode = parts[childPart] {
                    childNode.position =  absolutePosition[childPart]! - absolutePosition[part]!
                    childNode.initialZRotation = absoluteRotation[childPart]! - absoluteRotation[part]!
                    
                    node.addChild(childNode)
                }
            }
            
            if part.parentPart == nil {
                self.addChild(node)
                node.position = CGPoint.zero
                node.initialZRotation = absoluteRotation[part]!
            }
        }
        for (part, node) in parts {
            print("part: \(part), rotation: \(node.zRotation.radiansToDegrees())")
            node.zRotation = 0
            print("part: \(part), rotation: \(node.initialZRotation.radiansToDegrees())")
        }
        
        
        
    }
    convenience init(character: CharacterStorage) {
        self.init()
        guard let partsSet = character.parts else {
            return
        }
        self.name = character.name
        for element in partsSet {
            let part = element as! BodyPart
            guard let imageData = part.image, let image = UIImage(data: imageData) else {
                continue
            }
            let name = BodyPartName(rawValue: Int(part.tag!))!
            let node = BodyPartNode(bodyPartName: name, texture: SKTexture(image: image))
            node.initialZRotation = CGFloat(part.initialRotation!)
            node.position = CGPoint(x: CGFloat(part.positionX!),y: CGFloat(part.positionY!))
            node.anchorPoint = CGPoint(x: CGFloat(part.anchorPointX!),y: CGFloat(part.anchorPointY!))
            parts[name] = node
        }
        for (part, node) in parts {
            for childPart in part.childPart {
                if let childNode = parts[childPart] {
                    node.addChild(childNode)
                }
            }
            
            if part.parentPart == nil {
                self.addChild(node)
            }
        }
        
    }
}
