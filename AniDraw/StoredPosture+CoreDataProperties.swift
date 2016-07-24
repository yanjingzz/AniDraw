//
//  StoredPosture+CoreDataProperties.swift
//  AniDraw
//
//  Created by Mike on 7/22/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension StoredPosture {

    @NSManaged var rawPositionX: Double
    @NSManaged var rawPositionY: Double
    @NSManaged var rawAngles: [Double]
    @NSManaged var belongsTo: StoredKeyframe?

}
