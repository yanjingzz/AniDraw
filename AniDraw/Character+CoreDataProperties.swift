//
//  Character+CoreDataProperties.swift
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

extension Character {

    @NSManaged var name: String?
    @NSManaged var parts: NSSet?

}
