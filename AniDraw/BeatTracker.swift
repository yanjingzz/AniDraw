//
//  BeatTracker.swift
//  AniDraw
//
//  Created by Mike on 7/25/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation

class BeatTracker {
    var onsetInterval = [NSTimeInterval]()
    let total: Int
    var inlinerRatio = 0.8
    var tempo = 0.5
    init(total: Int) {
        self.total = total
    }
    
    private func ransac() -> NSTimeInterval? {
        var bestInNum = 0
        var bestPara: NSTimeInterval? = nil
        for sample in onsetInterval {
            let inliners = onsetInterval.filter {
//                var e = $0
//                while e > sample * 2 {
//                    e /= 2
//                }
//                while e < sample / 2 {
//                    e *= 2
//                }
                
                
                return abs($0 - sample) < (sample / 4)
            }
            let inlinerNum = inliners.count
            if //inlinerNum >= Int(inlinerRatio * Double(onsetInterval.count)) &&
                inlinerNum > bestInNum {
                bestInNum = inlinerNum
                bestPara = inliners.reduce(0.0, combine: +) / Double(inliners.count)
                //return the average of inliners
            }
        }
        
        
        return bestPara
    }
    
    func updateByAppend(newOnsetInterval: NSTimeInterval) -> NSTimeInterval {
        onsetInterval.append(newOnsetInterval)
        while onsetInterval.count > total {
            onsetInterval.removeFirst()
        }
        updateTempo()
        return tempo
    }
    func updateByAddToLast(newOnsetInterval: NSTimeInterval) -> NSTimeInterval {
        // used to cancel last noise
        guard !onsetInterval.isEmpty else {
            return tempo
        }
        let lastIdx = onsetInterval.count - 1
        onsetInterval[lastIdx] = onsetInterval[lastIdx] + newOnsetInterval
        updateTempo()
        return tempo
    }
    func updateTempo() {
        if var ransc = ransac() {
            while ransc > 0.5 * sqrt(2.0) {
                ransc /= 2
            }
            while ransc < 0.5 * sqrt(0.5)  {
                ransc *= 2
            }
            
            tempo = tempo * 0.5 + ransc * 0.5
        }
        
    }
    
    func reset() {
        onsetInterval.removeAll(keepCapacity: true)
    }
}