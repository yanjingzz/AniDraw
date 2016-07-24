//
//  CharacterStorage.swift
//  AniDraw
//
//  Created by Mike on 7/5/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
import CoreData


class CharacterStorage: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func insertCharacter(name: String, characterNode: CharacterNode, characterImage: UIImage) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        context.performBlockAndWait {
            guard let character = NSEntityDescription.insertNewObjectForEntityForName("Character", inManagedObjectContext:context) as? CharacterStorage else {
                return
            }
            character.name = name
            character.wholeImage = UIImagePNGRepresentation(characterImage)
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
            do {
                try context.save()
            } catch {
                print("CharacterStorage save error!")
                print(error)
            }
            
        }
    }
    func edit(characterNode: CharacterNode, characterImage: UIImage) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        context.performBlockAndWait {
            self.wholeImage = UIImagePNGRepresentation(characterImage)

            for element in self.parts! {
                let bodyPart = element as! BodyPart
                let name = BodyPartName(rawValue: Int(bodyPart.tag!))!
                if let node = characterNode.parts[name] {
                    let image = UIImage(CGImage: node.texture!.CGImage())
                    let imageData = UIImagePNGRepresentation(image)
                    bodyPart.image = imageData
                    bodyPart.anchorPointX = node.anchorPoint.x
                    bodyPart.anchorPointY = node.anchorPoint.y
                    bodyPart.positionX = node.position.x
                    bodyPart.positionY = node.position.y
                    bodyPart.initialRotation = node.initialZRotation
                }
            }
            do {
                try context.save()
            } catch {
                print("CharacterStorage save error!")
                print(error)
            }
            
        }
    }
    class func allCharacters() -> [CharacterStorage]? {
        let request = NSFetchRequest(entityName: "Character")
        request.predicate = nil
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var characters: [CharacterStorage]?
        context.performBlockAndWait {
            let array = try? context.executeFetchRequest(request)
            characters = array as? [CharacterStorage]
        }
        return characters
    }

}
