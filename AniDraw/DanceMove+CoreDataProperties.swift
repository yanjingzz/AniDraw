//
//  DanceMove+CoreDataProperties.swift
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

extension DanceMove {

    @NSManaged var name: String
    @NSManaged var rawStyle: Int32
    @NSManaged var rawLevel: Int32
    @NSManaged var keyframesSet: NSSet?

}
