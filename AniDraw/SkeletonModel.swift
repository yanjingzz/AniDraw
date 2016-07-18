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
    var matrix : [[(BodyPartName?,BodyPartName?)]] = []
    var matrixWidth : Int = 0
    var matrixHeight : Int = 0
    var R : [[Int]] = []
    var G : [[Int]] = []
    var B : [[int]] = []
    var A : [[int]] = []
    
    var priorityOfBodyPartName = [BodyPartName:Int]()
    
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
        priorityOfBodyPartName[.Head] = 0
        priorityOfBodyPartName[.LowerBody] = 1
        priorityOfBodyPartName[.UpperBody] = 2
        priorityOfBodyPartName[.LeftThigh] = 3
        priorityOfBodyPartName[.RightThigh] = 4
        priorityOfBodyPartName[.LeftShank] = 5
        priorityOfBodyPartName[.RightShank] = 6
        priorityOfBodyPartName[.LeftFoot] = 7
        priorityOfBodyPartName[.RightFoot] = 8
        priorityOfBodyPartName[.LeftUpperArm] = 9
        priorityOfBodyPartName[.RightUpperArm] = 10
        priorityOfBodyPartName[.LeftForearm] = 11
        priorityOfBodyPartName[.RightForearm] = 12
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
        
        if isModelValid == false {
            print("Not valid!!!")
            for y in 0..<matrixHeight {
                for x in 0..<matrixWidth {
                    matrix[y][x] = (.Head,nil)
                }
            }
            return
        }
        
        //Naive pre
        for x in 0..<matrixWidth {
            for y in 0..<matrixHeight {
                matrix[y][x] = (.Head,nil)
            }
        }
        
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
        
        var temporaryX : Int = 0
        var temporaryY : Int = 0
        
    // PART1:classifyBasedOnJointPosition
        
        let defaultRadius = 5
        
        //TODO:
        
        //[1]get each radius
            //head
        var headRadius : Int = 1
        temporaryX = Int(neckPosition.x)
        temporaryY = Int(neckPosition.y)
        
        

        //[2]get half-oval-based Overlap rather than half-circle
        
        setJointBased(defaultRadius, center: neckPosition, addPart: [.Head,.UpperBody])
        setJointBased(defaultRadius, center: waistPosition, addPart: [.UpperBody,.LowerBody])
        setJointBased(defaultRadius, center: leftShoulderPosition, addPart: [.UpperBody,.LeftUpperArm])
        setJointBased(defaultRadius, center: leftElbowPosition, addPart: [.LeftUpperArm,.LeftForearm])
        setJointBased(defaultRadius, center: leftWristPosition, addPart: [.LeftForearm])
        setJointBased(defaultRadius, center: rightShoulderPosition, addPart: [.UpperBody,.RightUpperArm])
        setJointBased(defaultRadius, center: rightElbowPosition, addPart: [.RightUpperArm,.RightForearm])
        setJointBased(defaultRadius, center: rightWristPosition, addPart: [.RightForearm])
        setJointBased(defaultRadius, center: leftHipPosition, addPart: [.LowerBody,.LeftThigh])
        setJointBased(defaultRadius, center: leftKneePosition, addPart: [.LeftThigh,.LeftShank])
        setJointBased(defaultRadius, center: leftAnklePosition, addPart: [.LeftShank,.LeftFoot])
        setJointBased(defaultRadius, center: rightHipPosition, addPart: [.LowerBody,.RightThigh])
        setJointBased(defaultRadius, center: rightKneePosition, addPart: [.RightThigh,.RightShank])
        setJointBased(defaultRadius, center: rightAnklePosition, addPart: [.RightShank,.RightFoot])
        
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
                    matrix[y][x] = (nil,nil)
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
                matrix[y][x] = (.Head,nil)
            }
        }
        //UpperArm
        for x in 0..<Int(leftShoulderPosition.x + 10) {
            for y in Int(leftShoulderPosition.y - 5)..<Int(leftElbowPosition.y) {
                matrix[y][x] = (.LeftUpperArm,nil)
            }
        }
        for x in Int(rightShoulderPosition.x - 10)..<matrixWidth {
            for y in Int(rightShoulderPosition.y - 5)..<Int(rightElbowPosition.y) {
                matrix[y][x] = (.RightUpperArm,nil)
            }
        }
        //UpperBody
        for x in Int(leftShoulderPosition.x + 10)..<Int(rightShoulderPosition.x - 10) {
            for y in Int(neckPosition.y)..<Int(waistPosition.y) {
                matrix[y][x] = (.UpperBody,nil)
            }
        }
        //Forearm
        for x in 0..<Int(leftShoulderPosition.x + 10) {
            for y in Int(leftElbowPosition.y)..<Int(leftKneePosition.y) {
                matrix[y][x] = (.LeftForearm,nil)
            }
        }
        for x in Int(rightShoulderPosition.x - 10)..<matrixWidth {
            for y in Int(rightElbowPosition.y)..<Int(rightKneePosition.y) {
                matrix[y][x] = (.RightForearm,nil)
            }
        }
        //LowerBody
        for x in Int(leftShoulderPosition.x + 10)..<Int(rightShoulderPosition.x - 10) {
            for y in Int(waistPosition.y)..<Int(minimunPositionYOfLeg) {
                matrix[y][x] = (.LowerBody,nil)
            }
        }
        //Thigh
        for x in Int(leftShoulderPosition.x + 10)..<Int(waistPosition.x) {
            for y in Int(minimunPositionYOfLeg)..<Int(leftKneePosition.y) {
                matrix[y][x] = (.LeftThigh,nil)
            }
        }
        for x in Int(waistPosition.x)..<Int(rightShoulderPosition.x - 10) {
            for y in Int(minimunPositionYOfLeg)..<Int(rightKneePosition.y) {
                matrix[y][x] = (.RightThigh,nil)
            }
        }
        //Shank
        for x in 0..<Int(waistPosition.x) {
            for y in Int(leftKneePosition.y)..<Int(leftAnklePosition.y) {
                matrix[y][x] = (.LeftShank,nil)
            }
        }
        for x in Int(waistPosition.x)..<matrixWidth {
            for y in Int(rightKneePosition.y)..<Int(rightAnklePosition.y) {
                matrix[y][x] = (.RightShank,nil)
            }
        }
        //Foot
        for x in 0..<Int(waistPosition.x) {
            for y in Int(leftAnklePosition.y)..<matrixHeight {
                matrix[y][x] = (.LeftFoot,nil)
            }
        }
        for x in Int(waistPosition.x)..<matrixWidth {
            for y in Int(rightAnklePosition.y)..<matrixHeight {
                matrix[y][x] = (.RightFoot,nil)
            }
        }
    }
    
    func getJointsFromAbsolutePosition(absolutePosition: CGPoint) -> (BodyPartName?,BodyPartName?) {
        if isModelValid == false {
            return (nil,nil)
        }
//        if absolutePosition.x - positionOffset.x < 0 || absolutePosition.y - positionOffset.y < 0 ||
//        absolutePosition.x - positionOffset.x > CGFloat(matrixWidth) || absolutePosition.y - positionOffset.y > CGFloat(matrixHeight)
//        {
//            return nil
//        }
        let relativeX = Int(absolutePosition.x - positionOffset.x)
        let relativeY = Int(absolutePosition.y - positionOffset.y)
        return matrix[relativeY][relativeX]
    }
    
    func getJointsFromRelativePosition(relativePosition: CGPoint) -> (BodyPartName?,BodyPartName?) {
        return matrix[Int(relativePosition.y)][Int(relativePosition.x)]
    }

    func getSkeletonModelInitValid() -> Boolean {
        return isModelValid
    }
    
    func getColorFromAbsolutePosition(absolutePosition: CGPoint) -> (r:Int,g:Int,b:Int,a:Int)? {
        if isModelValid == false {
            print("getColor:[Model is invalid]")
            return nil
        }
        let relativeX = Int(absolutePosition.x - positionOffset.x)
        let relativeY = Int(absolutePosition.y - positionOffset.y)
        if relativeX < 0 || relativeX > matrixWidth || relativeY < 0 || relativeY > matrixHeight {
            print("getColor:[Out of index]")
            return nil
        } else {
            return (R[relativeY][relativeX],G[relativeY][relativeX],B[relativeY][relativeX],A[relativeY][relativeX])
        }
    }
    
    func getColorFromRelativePosition(absolutePosition: CGPoint) -> (r:Int,g:Int,b:Int,a:Int)? {
        if isModelValid == false {
            print("getColor:[Model is invalid]")
            return nil
        }
        let relativeX = Int(absolutePosition.x)
        let relativeY = Int(absolutePosition.y)
        if relativeX < 0 || relativeX > matrixWidth || relativeY < 0 || relativeY > matrixHeight {
            print("getColor:[Out of index]")
            return nil
        } else {
            return (R[relativeY][relativeX],G[relativeY][relativeX],B[relativeY][relativeX],A[relativeY][relativeX])
        }
    }
    
    func setParameter(resetPosition: CGPoint,image: UIImage) {
        if resetPosition.x > 0 && resetPosition.y > 0 {
            if resetPosition == positionOffset &&
                matrixWidth == Int(image.size.width) &&
                matrixHeight == Int(image.size.height) {
                print("The same")
                if isModelValid == true {return}
            }
            matrix.removeAll()
            matrixWidth = Int(image.size.width)
            matrixHeight = Int(image.size.height)
            matrix = Array(count: matrixHeight, repeatedValue: Array(count: matrixWidth, repeatedValue: (nil,nil)))
            self.positionOffset = resetPosition
            loadColorsFromImage(image)
            print("Reset Valid Offset: \(self.positionOffset)")
            isModelValid = true
        } else  {
            isModelValid = false
            matrixWidth = 0
            matrixHeight = 0
            matrix.removeAll()
            print("Reset Invalid Offset: \(self.positionOffset)")
        }
    }
    
    func getBodyPartNameInPriority(b1:BodyPartName?,b2:BodyPartName?) -> BodyPartName? {
        var priority1 = -1 ,priority2 = -1
        if b1 != nil {priority1 = priorityOfBodyPartName[b1!]!}
        if b2 != nil {priority2 = priorityOfBodyPartName[b2!]!}
        return priority1 > priority2 ? b1 : b2
    }
    
    //for setParameter
    private func loadColorsFromImage(image:UIImage) {
        let (pixels, _) = image.CGImage!.toARGBBitmapData()        
        let height = Int(image.size.height)
        let width = Int(image.size.width)
        R = Array(count: height, repeatedValue: Array(count: width, repeatedValue: Int()))
        G = Array(count: height, repeatedValue: Array(count: width, repeatedValue: Int()))
        B = Array(count: height, repeatedValue: Array(count: width, repeatedValue: Int()))
        A = Array(count: height, repeatedValue: Array(count: width, repeatedValue: Int()))
        
        for y in 0..<height {
            for x in 0..<width {
                let pixel = pixels[width * y + x]
                R[y][x] = pixel.rValue
                G[y][x] = pixel.gValue
                B[y][x] = pixel.bValue
                A[y][x] = pixel.alphaValue
                }
        }
        free(pixels)
    }
    
    //for Part1: addBodyPartName
    private func appendBodyPartName(x:Int,y:Int,part:BodyPartName) {
        if matrix[y][x].0 == nil {
            matrix[y][x].0 = part
        } else {
            if matrix[y][x].0 == part {
                return
            } else {
                if matrix[y][x].1 == nil {
                    matrix[y][x].1 = part
                } else {
                    //TODO
                    //need setting priority of each part here?
                    
                }
            }
        }
    }
    
    //for Part1:   circle
    private func setJointBased(radius:Int,center:CGPoint,addPart:[BodyPartName]) {
        if addPart.count == 0 {return}
        for offsetX in -radius...radius {
            for offsetY in -radius...radius {
                if pow(CGFloat(offsetX),2.0) + pow(CGFloat(offsetY),2.0) > pow(CGFloat(radius),2) {continue}
                let X = Int(center.x) + offsetX, Y = Int(center.y) + offsetY
                for part in addPart {
                    appendBodyPartName(X, y: Y, part: part)
                }
            }
        }
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
