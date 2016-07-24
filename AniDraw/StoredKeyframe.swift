//
//  StoredKeyframe.swift
//  AniDraw
//
//  Created by Mike on 7/22/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation
import CoreData


class StoredKeyframe: NSManagedObject {
    convenience init(keyframe: Keyframe, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        let entity = NSEntityDescription.entityForName("Keyframe", inManagedObjectContext: context!)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        posture = StoredPosture(posture: keyframe.posture, insertIntoManagedObjectContext: context)
        posture?.belongsTo = self
        interruptable = keyframe.interruptable
        time = keyframe.time
        rawAngleCurve = Int32(keyframe.angleCurve.rawValue)
        rawPositionCurve = Int32(keyframe.positionCurve.rawValue)
        index = 0
    }
}
