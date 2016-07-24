//
//  DanceMove.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//


import UIKit
import CoreData

class DanceMove: NSManagedObject {
    var style: DanceStyle {
        get {
            return DanceStyle(rawValue: Int(rawStyle)) ?? .Generic
        }
        set {
            rawStyle = Int32(newValue.rawValue)
        }
    }
    var isEmpty: Bool {
        return keyframes.isEmpty
    }
    var keyframes: [Keyframe] {
        set {
            var storedArray = [StoredKeyframe]()
            for (i, key) in newValue.enumerate() {
                let storedKey = StoredKeyframe(keyframe: key, insertIntoManagedObjectContext: DanceMove.context)
                storedKey.belongsTo = self
                storedKey.index = Int32(i)
                storedArray.append(storedKey)
            }
            keyframesSet = NSSet(array: storedArray)
            
        }
        get {
            let stored = keyframesSet?.allObjects
            let storedKeys = stored as! [StoredKeyframe]
            let orderdStoredKeys = storedKeys.sort { (lhs, rhs) -> Bool in
                return lhs.index < rhs.index
            }
            var keys = [Keyframe]()
            for key in orderdStoredKeys{
                keys.append(Keyframe(storedKeyframe: key))
            }
            return keys
        }
    }
    
    var totalTime: NSTimeInterval {
        var time = 0.0
        if let storedKeys = keyframesSet?.allObjects as? [StoredKeyframe] {
            for key in storedKeys {
                time += key.time
            }
        }
        return time
    }
    var count:Int {
        return keyframesSet?.count ?? 0
    }
    var level : Int {
        set{
            rawLevel = Int32(level)
        }
        get{
            return Int(rawLevel)
        }
        
    }
    private static let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    convenience init(
        keyframes kfs:[Keyframe],
        levelOfIntensity level:Int = 0,
        style: DanceStyle = .Generic,
        name: String = "",
        insertIntoManagedObjectContext context: NSManagedObjectContext? = context)
    {
        let entity = NSEntityDescription.entityForName("DanceMove", inManagedObjectContext: context!)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        var storedArray = [StoredKeyframe]()
        for (i, key) in kfs.enumerate() {
            let storedKey = StoredKeyframe(keyframe: key, insertIntoManagedObjectContext: DanceMove.context)
            storedKey.belongsTo = self
            storedKey.index = Int32(i)
            storedArray.append(storedKey)
        }
        keyframesSet = NSSet(array: storedArray)
        rawLevel = Int32(level)
        rawStyle = Int32(style.rawValue)
        self.name = name
    }
    convenience init() {
        let context = DanceMove.context
        let entity = NSEntityDescription.entityForName("DanceMove", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
//    convenience init?(times: [NSTimeInterval], postures: [Posture], angleCurves: [Keyframe.Curve], postureCurves: [Keyframe.Curve], levelOfIntensity intensity: Int) {
//        guard times.length == postures.length
//            && times.length == angleCurves.length
//            && postureCurves.length == times.length else {
//            return nil
//        }
//        var kfs = [Keyframe]()
//        for i in 0..<times.length {
//            kfs.append(Keyframe(time: times[i], posture: postures[i], angleCurve: angleCurves[i],positionCurve: postureCurves[i]))
//        }
//        
//        self.init(keyframes: kfs,levelOfIntensity: intensity)
//    }
//    
//    convenience init?(times: [NSTimeInterval], postures: [Posture], levelOfIntensity intensity: Int) {
//        guard times.length == postures.length else {
//                return nil
//        }
//        var kfs = [Keyframe]()
//        for i in 0..<times.length {
//            kfs.append(Keyframe(time: times[i], posture: postures[i], angleCurve: .EaseInOut ,positionCurve: .EaseInOut))
//        }
//        
//        self.init(keyframes: kfs,levelOfIntensity: intensity)
//    }
}

enum DanceStyle: Int {
    case Generic = 0;
    case Ethnic;
    case Ballet;
    case Jazz;
    case HipHop;
}

