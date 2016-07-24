//
//  StoredKeyframe+CoreDataProperties.swift
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

extension StoredKeyframe {

    @NSManaged var interruptable: Bool
    @NSManaged var time: NSTimeInterval
    @NSManaged var rawAngleCurve: Int32
    @NSManaged var rawPositionCurve: Int32
    @NSManaged var index: Int32
    @NSManaged var belongsTo: DanceMove?
    @NSManaged var posture: StoredPosture?

}
