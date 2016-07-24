//
//  Moves.swift
//  AniDraw
//
//  Created by Mike on 7/6/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation
import CoreData
class Moves {
    static func ofStyle(style: DanceStyle, withLevel level: Int?) -> [DanceMove]? {
        let request = NSFetchRequest(entityName: "DanceMove")
        let rawStyle = NSNumber(int: Int32(style.rawValue))
        if level != nil {
            let rawLevel = NSNumber(int: Int32(level!))
            let predicate = NSPredicate(format: "(rawStyle = %@) AND (rawLevel = %@)", rawStyle, rawLevel)
            request.predicate = predicate
            request.sortDescriptors = nil
        } else {
            request.predicate = NSPredicate(format: "rawStyle = %@", rawStyle)
            request.sortDescriptors = [NSSortDescriptor(key: "rawLevel", ascending: true)]
        }
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var moves: [DanceMove]? = nil
        context.performBlockAndWait {
            let array = try? context.executeFetchRequest(request)
            moves = array as? [DanceMove]
        }
        return moves
    }
    static func dictOfStyle(style: DanceStyle) -> [Int: [DanceMove]] {
        var ret = [Int: [DanceMove]]()
        for i in 1...5 {
            ret[i] = Moves.ofStyle(style, withLevel: i) ?? [DanceMove]()
        }
        return ret
    }
    
    static func all() -> [DanceMove]? {
        let request = NSFetchRequest(entityName: "DanceMove")
        request.predicate = nil
        request.sortDescriptors = [
            NSSortDescriptor(key: "rawStyle", ascending: true),
            NSSortDescriptor(key: "rawLevel", ascending: true)]
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var moves: [DanceMove]? = nil
        context.performBlockAndWait {
            let array = try? context.executeFetchRequest(request)
            moves = array as? [DanceMove]
        }
        return moves
    }
}