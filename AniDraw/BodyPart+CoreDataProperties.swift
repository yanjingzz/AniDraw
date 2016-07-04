//
//  BodyPart+CoreDataProperties.swift
//  AniDraw
//
//  Created by Mike on 7/4/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BodyPart {

    @NSManaged var anchorPointX: NSNumber?
    @NSManaged var anchorPointY: NSNumber?
    @NSManaged var image: NSData?
    @NSManaged var initialRotation: NSNumber?
    @NSManaged var positionX: NSNumber?
    @NSManaged var positionY: NSNumber?
    @NSManaged var tag: NSNumber?
    @NSManaged var partOf: Character?

}
