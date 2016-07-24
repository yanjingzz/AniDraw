//
//  StoredPosture.swift
//  AniDraw
//
//  Created by Mike on 7/22/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import CoreData

class StoredPosture: NSManagedObject {
    
    convenience init(posture:Posture, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        let entity = NSEntityDescription.entityForName("Posture", inManagedObjectContext: context!)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        rawPositionX = Double(posture.position.x)
        rawPositionY = Double(posture.position.y)
        var tempArray = [Double]()
        for i in 0..<BodyPartName.count {
            tempArray.append(Double(posture.angles[BodyPartName(rawValue:i)!] ?? 0.0))
        }
        rawAngles = tempArray
    }
}
