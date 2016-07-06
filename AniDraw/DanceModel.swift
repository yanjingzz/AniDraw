//
//  DanceModel.swift
//  AniDraw
//
//  Created by younn on 16/7/5.
//  Copyright © 2016年 yanjingzz. All rights reserved.
//

import Foundation
import Darwin

public class DanceModel {
    var DanceMoveList : [DanceMove] = []
    
    var currentDanceMove : DanceMove
    var idleDanceMove : DanceMove
    var currentAbsolutePosition : CGPoint
    var dataSet : [[CGFloat]] = []
    let idlePosture = Posture(position: CGPoint(x: 0, y: 0))

    //TODO
    var DanceMoveData1 : [CGFloat] =
    [1,1,
    0.8,0,0,0,0,
        0.6,0,0,0,0,0,0,0,0,0,0,0,0]
    
    var DanceMoveData2 : [CGFloat] = []
    var DanceMoveData3 : [CGFloat] = []
    var DanceMoveData4 : [CGFloat] = []
    var DanceMoveData5 : [CGFloat] = []

    
    init(center: CGPoint) {
        //init idleDanceMove
        var kfs : [Keyframe] = []
        let idleKeyFrame = Keyframe(time: 1, pos: idlePosture, angleCurveIndex: 0, posCurveIndex: 0)
        kfs.append(idleKeyFrame)
        idleDanceMove = DanceMove(kfs: kfs, prPosture: idlePosture)
        currentDanceMove = idleDanceMove
        currentAbsolutePosition = center
        
        //for naive test
        dataSet.append(DanceMoveData1)
//        dataSet.append(DanceMoveData2)
//        dataSet.append(DanceMoveData3)
//        dataSet.append(DanceMoveData4)
//        dataSet.append(DanceMoveData5)
        
        loadDanceMove(dataSet)
        
    }
    
    func getPostureByIntervalTime(dtime:CFTimeInterval) -> Posture {
        var nextposture = currentDanceMove.getPostureByIntervalTime(dtime)
        if nextposture == nil {
            pickNextDanceMove()
            nextposture = currentDanceMove.getPostureByIntervalTime(dtime)
        }
        nextposture?.position = (nextposture?.position)! + currentAbsolutePosition
        return nextposture!
    }
    
    func pickNextDanceMove() {
        let index = chooseMethod()
        if index < 0 {
            currentDanceMove = idleDanceMove
        } else {
            currentDanceMove = DanceMoveList[index]
        }
    }
    
    func loadDanceMove(dataSet : [[CGFloat]]){
        var count = 0
        for data in dataSet{
            var kfs : [Keyframe] = []
            let kfNumber = Int(data[1])

            for index in 0..<kfNumber {
                let base = 2 + index * 18
                var angles = [BodyPartName : CGFloat]()
                var subIndex = 5
                for part in BodyPartName.allParts {
                    angles[part] = data[base + subIndex]
                    subIndex++
                }
                print("position:")
                print(CGPoint(x: data[base+3], y: data[base+4]))
                let posture = Posture(angles: angles, position:CGPoint(x: data[base+3], y: data[base+4]))
                
                let kf = Keyframe(time: CFTimeInterval(data[base]), pos: posture!, angleCurveIndex: Int(data[base+1]), posCurveIndex: Int(data[base+2]))
                kfs.append(kf)
            }
            
            let danceMove : DanceMove
            if count == 0 {
                danceMove = DanceMove(kfs: kfs, prPosture: idlePosture,lev:Int(data[0]))
            } else {
                danceMove = DanceMove(kfs: kfs, prPosture: DanceMoveList[count-1].keyframes[0].posture, lev:Int(data[0]))
            }
            count++
            DanceMoveList.append(danceMove)
        }
    }
    
    func chooseMethod() -> Int {
        //TODO set module
        
        let value = UInt32(DanceMoveList.count + 1)
        let result = Int(arc4random_uniform(value)) - 1
        print("choose result: \(result)")
        return result
    }
}

//Data structure:
//property part:
//1:dancemovelevel(default:1~5)
//data part:
//2:Keyframes' number
//(3~20)*N:each Keyframe {
//    time
//    angleCurveIndex
//    posCurveIndex
//    position.x
//    position.y
//    angles.Head
//    angles.UpperBody
//    angles.LowerBody
//    angles.LeftUpperArm
//    angles.LeftForearm
//    angles.LeftThigh
//    angles.LeftShank
//    angles.LeftFoot
//    angles.RightUpperArm
//    angles.RightForearm
//    angles.RightThigh
//    angles.RightShank
//    angles.RightFoot
//}

