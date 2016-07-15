//
//  SkeletonModel.swift
//  AniDraw
//
//  Created by hcsi on 16/7/14.
//  Copyright © 2016年 yanjingzz. All rights reserved.
//

import Foundation

class SkeletonModel {
    var isModelValid : Boolean = false
    var positionOffset : CGPoint = CGPoint(x:0,y:0)
    //joints' position is related to the image instead of view
    var joints = [JointName:CGPoint]()
    //matrix -> pixelsBelongToJointsMatrix
    var matrix : [[[BodyPartName]?]] = []
    var matrixWidth : Int = 0
    var matrixHeight : Int = 0
    
    init() {
//        matrixWidth = Int(image.size.width)
//        matrixHeight = Int(image.size.height)
//        if offset.x <= 0 || offset.y <= 0 {
//            return
//        }
//        positionOffset = offset
////        for joint in JointName.allJoints{
////            joints[joint] = jointList[joint]! - offset
////            if joints[joint]!.x > matrixWidth {
////                matrixWidth = joints[joint]!.x
////            }
////            if joints[joint]!.y > matrixHeight {
////                matrixHeight = joints[joint]!.y
////            }
////        }
//        matrix = Array(count: matrixHeight, repeatedValue: Array(count: matrixWidth, repeatedValue: []))
////        colors = Array(count: Int(matrixWidth), repeatedValue: Array(count: Int(matrixHeight), repeatedValue: UIColor(red: 0, green: 0, blue: 0, alpha: 0)))
//        print("Valid init: Offset:\(positionOffset)")
        
    }
    
    func setJointsPosition(setJoints:[JointName:CGPoint]) {
        for joint in JointName.allJoints {
            if setJoints[joint] != nil {
//                print("\(joint):\(setJoints[joint])")
                joints[joint] = setJoints[joint]! - positionOffset
                if Int((joints[joint]?.x)!) > matrixWidth || Int((joints[joint]?.x)!) < 0 ||
                    Int((joints[joint]?.y)!) > matrixHeight || Int((joints[joint]?.y)!) < 0 {
                    print("INVALID:\(joint):(\(joints[joint]))")
                    isModelValid = false
                    return
                }
            }
        }
    }
    
    func performClassifyJointsPerPixel() {
    // PART0:getParameters
        let neckPosition = joints[.Neck]!
        let waistPosition = joints[.Waist]!
        let leftShoulderPosition = joints[.LeftShoulder]!
        let leftElbowPosition = joints[.LeftElbow]!
        let leftWristPosition = joints[.LeftWrist]!
        let rightShoulderPosition = joints[.RightShoulder]!
        let rightElbowPosition = joints[.RightElbow]!
        let rightWristPosition = joints[.RightWrist]!
        let leftHipPosition = joints[.LeftHip]!
        let leftKneePosition = joints[.LeftKnee]!
        let leftAnklePosition = joints[.LeftAnkle]!
        let rightHipPosition = joints[.RightHip]!
        let rightKneePosition = joints[.RightKnee]!
        let rightAnklePosition = joints[.RightAnkle]!
        
        
    // PART1:classifyBasedOnJointPosition
        
        let radius = 5
        
        //TODO:
        
        //[1]get each radius
        var headRadius : Int = 1

        //[2]get half-oval-based Overlap rather than half-circle
        
        setJointBased(radius, radius: CGFloat(radius), center: neckPosition, addPart: [.Head,.UpperBody])
        setJointBased(radius, radius: CGFloat(radius), center: waistPosition, addPart: [.UpperBody,.LowerBody])
        setJointBased(radius, radius: CGFloat(radius), center: leftShoulderPosition, addPart: [.UpperBody,.LeftUpperArm])
        setJointBased(radius, radius: CGFloat(radius), center: leftElbowPosition, addPart: [.LeftUpperArm,.LeftForearm])
        setJointBased(radius, radius: CGFloat(radius), center: leftWristPosition, addPart: [.LeftForearm])
        setJointBased(radius, radius: CGFloat(radius), center: rightShoulderPosition, addPart: [.UpperBody,.RightUpperArm])
        setJointBased(radius, radius: CGFloat(radius), center: rightElbowPosition, addPart: [.RightUpperArm,.RightForearm])
        setJointBased(radius, radius: CGFloat(radius), center: rightWristPosition, addPart: [.RightForearm])
        setJointBased(radius, radius: CGFloat(radius), center: leftHipPosition, addPart: [.LowerBody,.LeftThigh])
        setJointBased(radius, radius: CGFloat(radius), center: leftKneePosition, addPart: [.LeftThigh,.LeftShank])
        setJointBased(radius, radius: CGFloat(radius), center: leftAnklePosition, addPart: [.LeftShank,.LeftFoot])
        setJointBased(radius, radius: CGFloat(radius), center: rightHipPosition, addPart: [.LowerBody,.RightThigh])
        setJointBased(radius, radius: CGFloat(radius), center: rightKneePosition, addPart: [.RightThigh,.RightShank])
        setJointBased(radius, radius: CGFloat(radius), center: rightAnklePosition, addPart: [.RightShank,.RightFoot])
        
    // PART2:classifyBoundsOfBodyParts & fill
        
        //seq: UpperArm->Forearm->Thigh->Shank->Foot->LowerBody->UpperBody->Head
        
        //UpperArm
        
        //Forearm
        
        //Thigh
        
        //Shank
        
        //Foot
        
        //LowerBody
        
        //UpperBody
        
        //Head
        
        
    }
    
    //Naive for Test
    func performNavieClassifyJointsPerPixel() {
        
        if isModelValid == false {
            print("Not valid!!!")
            for y in 0..<matrixHeight {
                for x in 0..<matrixWidth {
                    matrix[y][x] = [.Head]
                }
            }
            return
        }
        print("valid!!!")
        let neckPosition = joints[.Neck]!
        let waistPosition = joints[.Waist]!
        let leftShoulderPosition = joints[.LeftShoulder]!
        let leftElbowPosition = joints[.LeftElbow]!
//        let leftWristPosition = joints[.LeftWrist]!
        let rightShoulderPosition = joints[.RightShoulder]!
        let rightElbowPosition = joints[.RightElbow]!
//        let rightWristPosition = joints[.RightWrist]!
        let leftHipPosition = joints[.LeftHip]!
        let leftKneePosition = joints[.LeftKnee]!
        let leftAnklePosition = joints[.LeftAnkle]!
        let rightHipPosition = joints[.RightHip]!
        let rightKneePosition = joints[.RightKnee]!
        let rightAnklePosition = joints[.RightAnkle]!
        
        let minimunPositionYOfLeg = leftHipPosition.y < rightHipPosition.y ? leftHipPosition.y : rightHipPosition.y
        
        //Head
        
        print(neckPosition)
        for y in 0..<Int(neckPosition.y) {
            for x in 0..<matrixWidth {
                matrix[y][x] = [.Head]
            }
        }
        //UpperArm
        for x in 0..<Int(leftShoulderPosition.x + 10) {
            for y in Int(leftShoulderPosition.y - 5)..<Int(leftElbowPosition.y) {
                matrix[y][x] = [.LeftUpperArm]
            }
        }
        for x in Int(rightShoulderPosition.x - 10)..<matrixWidth {
            for y in Int(rightShoulderPosition.y - 5)..<Int(rightElbowPosition.y) {
                matrix[y][x] = [.RightUpperArm]
            }
        }
        //UpperBody
        for x in Int(leftShoulderPosition.x + 10)..<Int(rightShoulderPosition.x - 10) {
            for y in Int(neckPosition.y)..<Int(waistPosition.y) {
                matrix[y][x] = [.UpperBody]
            }
        }
        //Forearm
        for x in 0..<Int(leftShoulderPosition.x + 10) {
            for y in Int(leftElbowPosition.y)..<Int(leftKneePosition.y) {
                matrix[y][x] = [.LeftForearm]
            }
        }
        for x in Int(rightShoulderPosition.x - 10)..<matrixWidth {
            for y in Int(rightElbowPosition.y)..<Int(rightKneePosition.y) {
                matrix[y][x] = [.RightForearm]
            }
        }
        //LowerBody
        for x in Int(leftShoulderPosition.x + 10)..<Int(rightShoulderPosition.x - 10) {
            for y in Int(waistPosition.y)..<Int(minimunPositionYOfLeg) {
                matrix[y][x] = [.LowerBody]
            }
        }
        //Thigh
        for x in Int(leftShoulderPosition.x + 10)..<Int(waistPosition.x) {
            for y in Int(minimunPositionYOfLeg)..<Int(leftKneePosition.y) {
                matrix[y][x] = [.LeftThigh]
            }
        }
        for x in Int(waistPosition.x)..<Int(rightShoulderPosition.x - 10) {
            for y in Int(minimunPositionYOfLeg)..<Int(rightKneePosition.y) {
                matrix[y][x] = [.RightThigh]
            }
        }
        //Shank
        for x in 0..<Int(waistPosition.x) {
            for y in Int(leftKneePosition.y)..<Int(leftAnklePosition.y) {
                matrix[y][x] = [.LeftShank]
            }
        }
        for x in Int(waistPosition.x)..<matrixWidth {
            for y in Int(rightKneePosition.y)..<Int(rightAnklePosition.y) {
                matrix[y][x] = [.RightShank]
            }
        }
        //Foot
        for x in 0..<Int(waistPosition.x) {
            for y in Int(leftAnklePosition.y)..<matrixHeight {
                matrix[y][x] = [.LeftFoot]
            }
        }
        for x in Int(waistPosition.x)..<matrixWidth {
            for y in Int(rightAnklePosition.y)..<matrixHeight {
                matrix[y][x] = [.RightFoot]
            }
        }
    }
    
    func getJointsFromAbsolutePosition(absolutePosition: CGPoint) -> [BodyPartName]? {
        if isModelValid == false {
            return nil
        }
//        if absolutePosition.x - positionOffset.x < 0 || absolutePosition.y - positionOffset.y < 0 ||
//        absolutePosition.x - positionOffset.x > CGFloat(matrixWidth) || absolutePosition.y - positionOffset.y > CGFloat(matrixHeight)
//        {
//            return nil
//        }
        return matrix[Int(absolutePosition.y - positionOffset.y)][Int(absolutePosition.x - positionOffset.x)]
    }
    
    func getJointsFromRelativePosition(relativePosition: CGPoint) -> [BodyPartName]? {
        return matrix[Int(relativePosition.y)][Int(relativePosition.x)]
    }

    func getSkeletonModelInitValid() -> Boolean {
        return isModelValid
    }
    
    func setParameter(resetPosition: CGPoint,image: UIImage) {
        if resetPosition.x > 0 && resetPosition.y > 0 {
            isModelValid = true
            if resetPosition == positionOffset &&
                matrixWidth == Int(image.size.width) &&
                matrixHeight == Int(image.size.height) {
                print("The same")
                return
            }
            matrix.removeAll()
            matrixWidth = Int(image.size.width)
            matrixHeight = Int(image.size.height)
            matrix = Array(count: matrixHeight, repeatedValue: Array(count: matrixWidth, repeatedValue: []))
            self.positionOffset = resetPosition
            print("Reset Valid Offset: \(self.positionOffset)")
        } else  {
            isModelValid = false
            matrixWidth = 0
            matrixHeight = 0
            matrix.removeAll()
            print("Reset Invalid Offset: \(self.positionOffset)")
        }
    }
    
    //for Part1:   square(5x5) -> circle
    private func setJointBased(squareLength:Int,radius:CGFloat,center:CGPoint,addPart:[BodyPartName]) {
        for offsetX in -squareLength...squareLength {
            for offsetY in -squareLength...squareLength {
                if pow(CGFloat(offsetX),2.0) + pow(CGFloat(offsetY),2.0) > pow(radius,2) {continue}
                let X = Int(center.x) + offsetX, Y = Int(center.y) + offsetY
                if matrix[Y][X] == nil {
                    matrix[Y][X] = addPart
                } else {
                    for part in addPart {
                        matrix[Y][X]!.append(part)
                    }}}}
    }
    
}

//Head
//UpperBody
//LowerBody
//LeftUpperArm
//LeftForearm
//RightUpperArm
//RightForearm
//LeftThigh
//LeftShank
//LeftFoot
//RightThigh
//RightShank
//RightFoot
