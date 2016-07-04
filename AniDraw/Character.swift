//
//  Character.swift
//  AniDraw
//
//  Created by Mike on 7/4/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
import CoreData


class Character: NSManagedObject {
// Insert code here to add functionality to your managed object subclass
    class func insertCharacter(name: String, characterNode: CharacterNode) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        context.performBlock {
            guard let character = NSEntityDescription.insertNewObjectForEntityForName("Character", inManagedObjectContext:context) as? Character else {
                return
            }
            character.name = name
            for (name, node) in characterNode.parts {
                let tag = name.rawValue
                if let bodyPart = NSEntityDescription.insertNewObjectForEntityForName("BodyPart", inManagedObjectContext:context) as? BodyPart {
                    bodyPart.tag = tag
                    let image = UIImage(CGImage: node.texture!.CGImage())
                    let imageData = UIImagePNGRepresentation(image)
                    bodyPart.image = imageData
                    bodyPart.anchorPointX = node.anchorPoint.x
                    bodyPart.anchorPointY = node.anchorPoint.y
                    bodyPart.positionX = node.position.x
                    bodyPart.positionY = node.position.y
                    bodyPart.initialRotation = node.initialZRotation
                    bodyPart.partOf = character
                }
            }
        }
    }
    class func allCharacters() -> [Character]? {
        let request = NSFetchRequest(entityName: "Character")
        request.predicate = nil
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var characters: [Character]?
        context.performBlockAndWait {
            let array = try? context.executeFetchRequest(request)
            characters = array as? [Character]
        }
        return characters
    }
}
