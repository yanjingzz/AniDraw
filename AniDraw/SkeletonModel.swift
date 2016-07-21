//
//  SkeletonModel.swift
//  AniDraw
//
//  Created by hcsi on 16/7/14.
//  Copyright © 2016年 yanjingzz. All rights reserved.
//

import Foundation

class SkeletonModel {
    var isPerformClassifyPixels : Boolean = false
    var isModelValid : Boolean = false
    var positionOffset : CGPoint = CGPoint(x:0,y:0)
    //joints' position is related to the image instead of view
    var joints = [JointName:CGPoint]()
    //matrix -> pixelsBelongToJointsMatrix
    var matrix : [[(BodyPartName?,BodyPartName?)]] = []
    var matrixWidth : Int = 0
    var matrixHeight : Int = 0
    var R : [[int]] = []
    var G : [[int]] = []
    var B : [[int]] = []
    var A : [[int]] = []
    
    static var lastUpdateTimeStamp : NSDate = NSDate()
    var selfUpdateTimeStamp : NSDate
    
    var priorityOfBodyPartName = [BodyPartName:Int]()
    
    init() {
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
        selfUpdateTimeStamp = NSDate()
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
        isPerformClassifyPixels = true
        print("perform start!")
        
        
        if isModelValid == true {
            isModelValid = checkJointsValid()
        }
        
        if isModelValid == false {
            print("Not valid!!!")
            return
        }
        matrix.removeAll()
        matrix = Array(count: matrixHeight, repeatedValue: Array(count: matrixWidth, repeatedValue: (nil,nil)))
        
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
        
        let shoulderWidth = Int(pow((pow(rightShoulderPosition.x - leftShoulderPosition.x,2) +
                pow(rightShoulderPosition.y - leftShoulderPosition.y,2)),0.5))
        let shoulderCenterPostion = (leftShoulderPosition + rightShoulderPosition) / 2
//        let gradientOnLeftShoulderToRightShoulder = (rightShoulderPosition.y - leftShoulderPosition.y) /
//            (rightShoulderPosition.x - leftShoulderPosition.x) // the same as gradientOnCenterToRightShoulder
//        let gradientOnLeftShoulderToLeftElbow = (leftShoulderPosition.y - leftElbowPosition.y) /
//            (leftShoulderPosition.x - leftElbowPosition.x)
        
        var X : Int = 0
        var Y : Int = 0
        var leftSide : Int = 0
        var rightSide : Int = 0
        var leftBound : Int = 0
        var rightBound : Int = 0
        var topBound : Int = 0
        var bottomBound : Int = 0
        var fillY : Int = 0

        
    // PART1:classifyBasedOnJointPosition
        
//        let defaultRadius = 5
        
        //[1]get each joint's radius
            //neck
        var radiusOfNeck : Int = 0
        X = Int(neckPosition.x)
        Y = Int(neckPosition.y)
        leftSide = X-1
        rightSide = X+1
        leftBound = 0
        rightBound = matrixWidth-1
        while A[Y][leftSide] == 0 && leftSide>leftBound {
            leftSide -= 1
        }
        var transparentLeft = leftSide
        while A[Y][leftSide] != 0 && leftSide>leftBound {
            leftSide -= 1
        }
        while A[Y][rightSide] == 0 && rightSide<rightBound {
            rightSide += 1
        }
        var transparentRight = rightSide
        while A[Y][rightSide] == 0 && rightSide<rightBound {
            rightSide += 1
        }
        
        if transparentLeft != 0 || transparentRight != 0 {
            if rightSide - leftSide < shoulderWidth {
                radiusOfNeck = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
            } else {
                radiusOfNeck = 0
            }
        } else {
            radiusOfNeck = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }

        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }

            //waist
        var radiusOfWaist : Int = 0
        
        X = Int(waistPosition.x)
        Y = Int(waistPosition.y)
        leftSide = X-1
        rightSide = X+1
        leftBound = 0
        rightBound = matrixWidth-1
        while A[Y][leftSide] == 0 && leftSide>leftBound {
            leftSide -= 1
        }
        transparentLeft = leftSide
        while A[Y][leftSide] != 0 && leftSide>leftBound {
            leftSide -= 1
        }
        while A[Y][rightSide] == 0 && rightSide<rightBound {
            rightSide += 1
        }
        transparentRight = rightSide
        while A[Y][rightSide] == 0 && rightSide<rightBound {
            rightSide += 1
        }
        
        if transparentLeft != 0 || transparentRight != 0 {
            if rightSide - leftSide < Int(rightElbowPosition.x - leftElbowPosition.x) {
                radiusOfWaist = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
            } else {
                print("invalid position on waist")
                radiusOfWaist = 0
            }
        } else {
            radiusOfNeck = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }
        
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }
        
            //shoulder(1/5 of shoulderwidth)
        var radiusOfLeftShoulder : Int = shoulderWidth / 5
        
        var radiusOfRightShoulder : Int = shoulderWidth / 5
        
            //elbow
        var radiusOfLeftElbow : Int = 0
        
        X = Int(leftElbowPosition.x)
        Y = Int(leftElbowPosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfLeftElbow = 1
        } else {
            leftBound = 0
            rightBound = Int(shoulderCenterPostion.x) - radiusOfWaist
            while A[Y][leftSide] == 0 && leftSide>leftBound {
                leftSide -= 1
            }
            transparentLeft = leftSide
            while A[Y][leftSide] != 0 && leftSide>leftBound {
                leftSide -= 1
            }
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            transparentRight = rightSide
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            radiusOfLeftElbow = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }
        
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }

        var radiusOfRightElbow : Int = 0
        
        X = Int(rightElbowPosition.x)
        Y = Int(rightElbowPosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfRightElbow = 1
        } else {
            leftBound = Int(shoulderCenterPostion.x) + radiusOfWaist
            rightBound = matrixWidth-1
            while A[Y][leftSide] == 0 && leftSide>leftBound {
                leftSide -= 1
            }
            transparentLeft = leftSide
            while A[Y][leftSide] != 0 && leftSide>leftBound {
                leftSide -= 1
            }
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            transparentRight = rightSide
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            radiusOfRightElbow = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }

        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }

            //Hip
        var radiusOfLeftHip : Int = 0
        
        X = Int(leftHipPosition.x)
        Y = Int(leftHipPosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfLeftHip = 1
        } else {
            leftBound = 0
            rightBound = Int(waistPosition.x)
            while A[Y][leftSide] == 0 && leftSide>leftBound {
                leftSide -= 1
            }
            transparentLeft = leftSide
            while A[Y][leftSide] != 0 && leftSide>leftBound {
                leftSide -= 1
            }
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            transparentRight = rightSide
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            radiusOfLeftHip = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }
        
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }

        var radiusOfRightHip : Int = 0
        
        X = Int(rightHipPosition.x)
        Y = Int(rightHipPosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfRightHip = 1
        } else {
            leftBound = Int(waistPosition.x)
            rightBound = matrixWidth-1
            while A[Y][leftSide] == 0 && leftSide>leftBound {
                leftSide -= 1
            }
            transparentLeft = leftSide
            while A[Y][leftSide] != 0 && leftSide>leftBound {
                leftSide -= 1
            }
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            transparentRight = rightSide
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            radiusOfRightHip = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }

        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }

            //knee
        var radiusOfLeftKnee : Int = 0
        X = Int(leftKneePosition.x)
        Y = Int(leftKneePosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfLeftKnee = 1
        } else {
            leftBound = 0
            rightBound = Int(waistPosition.x)
            while A[Y][leftSide] == 0 && leftSide>leftBound {
                leftSide -= 1
            }
            transparentLeft = leftSide
            while A[Y][leftSide] != 0 && leftSide>leftBound {
                leftSide -= 1
            }
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            transparentRight = rightSide
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            radiusOfLeftKnee = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }
        
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }
        
        var radiusOfRightKnee : Int = 0
        X = Int(rightKneePosition.x)
        Y = Int(rightKneePosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfRightKnee = 1
        } else {
            leftBound = Int(waistPosition.x)
            rightBound = matrixWidth-1
            while A[Y][leftSide] == 0 && leftSide>leftBound {
                leftSide -= 1
            }
            transparentLeft = leftSide
            while A[Y][leftSide] != 0 && leftSide>leftBound {
                leftSide -= 1
            }
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            transparentRight = rightSide
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            radiusOfRightKnee = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }
        
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }
        
            //Ankle
        var radiusOfLeftAnkle : Int = 0
        X = Int(leftAnklePosition.x)
        Y = Int(leftAnklePosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfLeftAnkle = 1
        } else {
            leftBound = 0
            rightBound = Int(waistPosition.x)
            while A[Y][leftSide] == 0 && leftSide>leftBound {
                leftSide -= 1
            }
            transparentLeft = leftSide
            while A[Y][leftSide] != 0 && leftSide>leftBound {
                leftSide -= 1
            }
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            transparentRight = rightSide
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            radiusOfLeftAnkle = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }
        
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }
        
        var radiusOfRightAnkle : Int = 0
        X = Int(rightAnklePosition.x)
        Y = Int(rightAnklePosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfRightAnkle = 1
        } else {
            leftBound = Int(waistPosition.x)
            rightBound = matrixWidth-1
            while A[Y][leftSide] == 0 && leftSide>leftBound {
                leftSide -= 1
            }
            transparentLeft = leftSide
            while A[Y][leftSide] != 0 && leftSide>leftBound {
                leftSide -= 1
            }
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            transparentRight = rightSide
            while A[Y][rightSide] == 0 && rightSide<rightBound {
                rightSide += 1
            }
            radiusOfRightAnkle = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }
        
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }
        //TODO: get half-oval-based Overlap rather than half-circle
        
        print("check radius:")
        print("Neck:\(radiusOfNeck)")
        print("Waist:\(radiusOfWaist)")
        print("LeftShoulder:\(radiusOfLeftShoulder)")
        print("RightShoulder:\(radiusOfRightShoulder)")
        print("LeftElbow:\(radiusOfLeftElbow)")
        print("RightElbow:\(radiusOfRightElbow)")
        print("LeftHip:\(radiusOfLeftHip)")
        print("RightHip:\(radiusOfRightHip)")
        print("LeftKnee:\(radiusOfLeftKnee)")
        print("RightKnee:\(radiusOfRightKnee)")
        print("LeftAnkle:\(radiusOfLeftKnee)")
        print("RightAnkle:\(radiusOfRightKnee)")

        
        setJointBased(radiusOfNeck, center: neckPosition, addPart: [.Head,.UpperBody])
        setJointBased(radiusOfWaist, center: waistPosition, addPart: [.UpperBody,.LowerBody])
        setJointBased(radiusOfLeftShoulder, center: leftShoulderPosition, addPart: [.UpperBody,.LeftUpperArm])
        setJointBased(radiusOfLeftElbow, center: leftElbowPosition, addPart: [.LeftUpperArm,.LeftForearm])
        setJointBased(radiusOfRightShoulder, center: rightShoulderPosition, addPart: [.UpperBody,.RightUpperArm])
        setJointBased(radiusOfRightElbow, center: rightElbowPosition, addPart: [.RightUpperArm,.RightForearm])
        setJointBased(radiusOfLeftHip, center: leftHipPosition, addPart: [.LowerBody,.LeftThigh])
        setJointBased(radiusOfLeftKnee, center: leftKneePosition, addPart: [.LeftThigh,.LeftShank])
        setJointBased(radiusOfLeftKnee, center: leftAnklePosition, addPart: [.LeftShank,.LeftFoot])
        setJointBased(radiusOfRightHip, center: rightHipPosition, addPart: [.LowerBody,.RightThigh])
        setJointBased(radiusOfRightKnee, center: rightKneePosition, addPart: [.RightThigh,.RightShank])
        setJointBased(radiusOfRightKnee, center: rightAnklePosition, addPart: [.RightShank,.RightFoot])
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }

    // PART2:classify BodyParts & fill
        
        //seq: UpperBody->LowerBody->UpperArm->Thigh->Shank->Foot->Forearm->Head
        
            //UpperBody
        bottomBound = Int(waistPosition.y)
        topBound = Int(neckPosition.y)
        leftBound = Int(leftElbowPosition.x)
        rightBound = Int(rightElbowPosition.x)
        leftSide = Int(waistPosition.x) - radiusOfWaist
        rightSide = Int(waistPosition.x) + radiusOfWaist
        fillY = bottomBound
        while fillY > topBound {
            if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                print("update abort!")
                return
            }
            while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
            while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
            while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
            while A[fillY][rightSide] == 0 && rightSide > leftSide {rightSide -= 1}
            for fillX in leftSide...rightSide {
                appendBodyPartName(fillX, y: fillY, part: .UpperBody)
            }
            fillY -= 1
        }
            //LowerBody
        bottomBound = Int(min(leftHipPosition.y,rightHipPosition.y))
        topBound = Int(waistPosition.y)
        leftBound = Int(leftElbowPosition.x)
        rightBound = Int(rightElbowPosition.x)
        leftSide = Int(waistPosition.x) - radiusOfWaist
        rightSide = Int(waistPosition.x) + radiusOfWaist
        fillY = topBound
        while fillY < bottomBound {
            if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                print("update abort!")
                return
            }
            while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
            while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
            while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
            while A[fillY][rightSide] == 0 && rightSide > leftSide {rightSide -= 1}
            for fillX in leftSide...rightSide {
                appendBodyPartName(fillX, y: fillY, part: .LowerBody)
            }
            fillY += 1
        }
            //leftUpperArm
        if leftShoulderPosition.y < leftElbowPosition.y {
            bottomBound = Int(leftElbowPosition.y)
            topBound = Int(leftShoulderPosition.y)
            leftBound = 0
            rightBound = Int(shoulderCenterPostion.x)
            leftSide = Int(leftShoulderPosition.x) - radiusOfLeftShoulder
            rightSide = Int(leftShoulderPosition.x) + radiusOfLeftShoulder
            fillY = topBound
            while fillY < bottomBound {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    print("update abort!")
                    return
                }
                while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
                while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
                while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 &&
                    !hasBodyPartName(rightSide+1, y: fillY, part: .UpperBody) &&
                    !hasBodyPartName(rightSide+1, y: fillY, part: .LowerBody) {rightSide += 1}
                while (A[fillY][rightSide] == 0 ||
                    hasBodyPartName(rightSide, y: fillY, part: .UpperBody) ||
                    hasBodyPartName(rightSide, y: fillY, part: .LowerBody))
                    && rightSide > leftSide {rightSide -= 1}
                for fillX in leftSide...rightSide {
                    appendBodyPartName(fillX, y: fillY, part: .LeftUpperArm)
                }
                fillY += 1
            }
        } else {    //raise arm
            topBound = Int(leftElbowPosition.y)
            bottomBound = Int(leftShoulderPosition.y)
            leftBound = 0
            rightBound = Int(shoulderCenterPostion.x)
            leftSide = Int(leftShoulderPosition.x) - radiusOfLeftShoulder
            rightSide = Int(leftShoulderPosition.x) + radiusOfLeftShoulder
            fillY = bottomBound
            while fillY > topBound {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    print("update abort!")
                    return
                }
                while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
                while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
                while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 &&
                    !hasBodyPartName(rightSide+1, y: fillY, part: .UpperBody) &&
                    !hasBodyPartName(rightSide+1, y: fillY, part: .LowerBody) {rightSide += 1}
                while (A[fillY][rightSide] == 0 ||
                    hasBodyPartName(rightSide, y: fillY, part: .UpperBody) ||
                    hasBodyPartName(rightSide, y: fillY, part: .LowerBody))
                    && rightSide > leftSide {rightSide -= 1}
                for fillX in leftSide...rightSide {
                    appendBodyPartName(fillX, y: fillY, part: .LeftUpperArm)
                }
                fillY -= 1
            }
        }
            //rightUpperArm
        if rightShoulderPosition.y < rightElbowPosition.y {
            bottomBound = Int(rightElbowPosition.y)
            topBound = Int(rightShoulderPosition.y)
            leftBound = Int(shoulderCenterPostion.x)
            rightBound = matrixWidth-1
            leftSide = Int(rightShoulderPosition.x) - radiusOfRightShoulder
            rightSide = Int(rightShoulderPosition.x) + radiusOfRightShoulder
            fillY = topBound
            while fillY < bottomBound {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    print("update abort!")
                    return
                }
                while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 &&
                    !hasBodyPartName(leftSide-1, y: fillY, part: .UpperBody) &&
                    !hasBodyPartName(leftSide-1, y: fillY, part: .LowerBody) {leftSide -= 1}
                while (A[fillY][leftSide] == 0  ||
                    hasBodyPartName(leftSide, y: fillY, part: .UpperBody) ||
                    hasBodyPartName(leftSide, y: fillY, part: .LowerBody)) &&
                    leftSide < rightSide {leftSide += 1}
                while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
                while (A[fillY][rightSide] == 0 && rightSide > leftSide) {rightSide -= 1}
                for fillX in leftSide...rightSide {
                    appendBodyPartName(fillX, y: fillY, part: .RightUpperArm)
                }
                fillY += 1
            }
        } else {    //raise arm
            topBound = Int(rightElbowPosition.y)
            bottomBound = Int(rightShoulderPosition.y)
            leftBound = Int(shoulderCenterPostion.x)
            rightBound = matrixWidth-1
            leftSide = Int(rightShoulderPosition.x) - radiusOfRightShoulder
            rightSide = Int(rightShoulderPosition.x) + radiusOfRightShoulder
            fillY = bottomBound
            while fillY > topBound {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    print("update abort!")
                    return
                }
                while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 &&
                    !hasBodyPartName(leftSide-1, y: fillY, part: .UpperBody) &&
                    !hasBodyPartName(leftSide-1, y: fillY, part: .LowerBody) {leftSide -= 1}
                while (A[fillY][leftSide] == 0  ||
                    hasBodyPartName(leftSide, y: fillY, part: .UpperBody) ||
                    hasBodyPartName(leftSide, y: fillY, part: .LowerBody)) &&
                    leftSide < rightSide {leftSide += 1}
                while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
                while (A[fillY][rightSide] == 0 && rightSide > leftSide) {rightSide -= 1}
                for fillX in leftSide...rightSide {
                    appendBodyPartName(fillX, y: fillY, part: .RightUpperArm)
                }
                fillY -= 1
            }
        }
            //Thigh
            //left
        bottomBound = Int(leftKneePosition.y)
        topBound = Int(leftHipPosition.y)
        leftBound = 0
        rightBound = Int(shoulderCenterPostion.x)
        leftSide = Int(leftHipPosition.x) - radiusOfLeftHip
        rightSide = Int(leftHipPosition.x) + radiusOfLeftHip
        fillY = topBound
        while fillY < bottomBound {
            if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                print("update abort!")
                return
            }
            while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
            while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
            while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
            while A[fillY][rightSide] == 0 && rightSide > leftSide {rightSide -= 1}
            for fillX in leftSide...rightSide {
                appendBodyPartName(fillX, y: fillY, part: .LeftThigh)
            }
            fillY += 1
        }
            //right
        bottomBound = Int(rightKneePosition.y)
        topBound = Int(rightHipPosition.y)
        leftBound = Int(shoulderCenterPostion.x)
        rightBound = matrixWidth-1
        leftSide = Int(rightHipPosition.x) - radiusOfRightHip
        rightSide = Int(rightHipPosition.x) + radiusOfRightHip
        fillY = topBound
        while fillY < bottomBound {
            if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                print("update abort!")
                return
            }
            while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
            while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
            while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
            while A[fillY][rightSide] == 0 && rightSide > leftSide {rightSide -= 1}
            for fillX in leftSide...rightSide {
                appendBodyPartName(fillX, y: fillY, part: .RightThigh)
            }
            fillY += 1
        }
            //Shank
            //left
        bottomBound = Int(leftAnklePosition.y)
        topBound = Int(leftKneePosition.y)
        leftBound = 0
        rightBound = Int(shoulderCenterPostion.x)
        leftSide = Int(leftKneePosition.x) - radiusOfLeftKnee
        rightSide = Int(leftKneePosition.x) + radiusOfLeftKnee
        fillY = topBound
        while fillY < bottomBound {
            if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                print("update abort!")
                return
            }
            while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
            while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
            while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
            while A[fillY][rightSide] == 0 && rightSide > leftSide {rightSide -= 1}
            for fillX in leftSide...rightSide {
                appendBodyPartName(fillX, y: fillY, part: .LeftShank)
            }
            fillY += 1
        }
            //right
        bottomBound = Int(rightAnklePosition.y)
        topBound = Int(rightKneePosition.y)
        leftBound = Int(shoulderCenterPostion.x)
        rightBound = matrixWidth-1
        leftSide = Int(rightKneePosition.x) - radiusOfRightKnee
        rightSide = Int(rightKneePosition.x) + radiusOfRightKnee
        fillY = topBound
        while fillY < bottomBound {
            if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                print("update abort!")
                return
            }
            while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
            while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
            while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
            while A[fillY][rightSide] == 0 && rightSide > leftSide {rightSide -= 1}
            for fillX in leftSide...rightSide {
                appendBodyPartName(fillX, y: fillY, part: .RightShank)
            }
            fillY += 1
        }
            //Foot
            //left
        bottomBound = matrixHeight-1
        topBound = Int(leftAnklePosition.y)
        leftBound = 0
        rightBound = Int(shoulderCenterPostion.x)
        leftSide = Int(leftAnklePosition.x) - radiusOfLeftAnkle
        rightSide = Int(leftAnklePosition.x) + radiusOfLeftAnkle
        fillY = topBound
        while fillY < bottomBound {
            if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                print("update abort!")
                return
            }
            while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
            while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
            while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
            while A[fillY][rightSide] == 0 && rightSide > leftSide {rightSide -= 1}
            for fillX in leftSide...rightSide {
                appendBodyPartName(fillX, y: fillY, part: .LeftFoot)
            }
            fillY += 1
        }
            //right
        bottomBound = matrixHeight-1
        topBound = Int(rightAnklePosition.y)
        leftBound = Int(shoulderCenterPostion.x)
        rightBound = matrixWidth-1
        leftSide = Int(rightAnklePosition.x) - radiusOfRightAnkle
        rightSide = Int(rightAnklePosition.x) + radiusOfRightAnkle
        fillY = topBound
        while fillY < bottomBound {
            if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                print("update abort!")
                return
            }
            while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
            while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
            while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
            while A[fillY][rightSide] == 0 && rightSide > leftSide {rightSide -= 1}
            for fillX in leftSide...rightSide {
                appendBodyPartName(fillX, y: fillY, part: .RightFoot)
            }
            fillY += 1
        }
            //Forearm
            //left
        if leftElbowPosition.y < leftWristPosition.y {
            bottomBound = Int(leftKneePosition.y)
            topBound = Int(leftElbowPosition.y)
            leftBound = 0
            rightBound = Int(shoulderCenterPostion.x)
            leftSide = Int(leftElbowPosition.x) - radiusOfLeftElbow
            rightSide = Int(leftElbowPosition.x) + radiusOfLeftElbow
            fillY = topBound
            while fillY < bottomBound {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    print("update abort!")
                    return
                }
                while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
                while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
                while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 &&
                    !hasBodyPartName(rightSide+1, y: fillY, part: .UpperBody) &&
                    !hasBodyPartName(rightSide+1, y: fillY, part: .LowerBody) {rightSide += 1}
                while (A[fillY][rightSide] == 0 ||
                    hasBodyPartName(rightSide, y: fillY, part: .UpperBody) ||
                    hasBodyPartName(rightSide, y: fillY, part: .LowerBody))
                    && rightSide > leftSide {rightSide -= 1}
                for fillX in leftSide...rightSide {
                    appendBodyPartName(fillX, y: fillY, part: .LeftForearm)
                }
                fillY += 1
            }
        } else {    //raise arm
            topBound = 0
            bottomBound = Int(leftKneePosition.y)
            leftBound = 0
            rightBound = Int(shoulderCenterPostion.x)
            leftSide = Int(leftElbowPosition.x) - radiusOfLeftElbow
            rightSide = Int(leftElbowPosition.x) + radiusOfLeftElbow
            fillY = bottomBound
            while fillY > topBound {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    print("update abort!")
                    return
                }
                while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 {leftSide -= 1}
                while A[fillY][leftSide] == 0 && leftSide < rightSide {leftSide += 1}
                while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 &&
                    !hasBodyPartName(rightSide+1, y: fillY, part: .UpperBody) &&
                    !hasBodyPartName(rightSide+1, y: fillY, part: .LowerBody) {rightSide += 1}
                while (A[fillY][rightSide] == 0 ||
                    hasBodyPartName(rightSide, y: fillY, part: .UpperBody) ||
                    hasBodyPartName(rightSide, y: fillY, part: .LowerBody))
                    && rightSide > leftSide {rightSide -= 1}
                for fillX in leftSide...rightSide {
                    appendBodyPartName(fillX, y: fillY, part: .LeftForearm)
                }
                fillY -= 1
            }
        }
            //right
        if rightElbowPosition.y < rightWristPosition.y {
            bottomBound = Int(rightKneePosition.y)
            topBound = Int(rightElbowPosition.y)
            leftBound = Int(shoulderCenterPostion.x)
            rightBound = matrixWidth-1
            leftSide = Int(rightElbowPosition.x) - radiusOfRightElbow
            rightSide = Int(rightElbowPosition.x) + radiusOfRightElbow
            fillY = topBound
            while fillY < bottomBound {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    print("update abort!")
                    return
                }
                while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 &&
                    !hasBodyPartName(leftSide-1, y: fillY, part: .UpperBody) &&
                    !hasBodyPartName(leftSide-1, y: fillY, part: .LowerBody) {leftSide -= 1}
                while (A[fillY][leftSide] == 0  ||
                    hasBodyPartName(leftSide, y: fillY, part: .UpperBody) ||
                    hasBodyPartName(leftSide, y: fillY, part: .LowerBody)) &&
                    leftSide < rightSide {leftSide += 1}
                while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
                while (A[fillY][rightSide] == 0 && rightSide > leftSide) {rightSide -= 1}
                for fillX in leftSide...rightSide {
                    appendBodyPartName(fillX, y: fillY, part: .RightForearm)
                }
                fillY += 1
            }
        } else {    //raise arm
            topBound = 0
            bottomBound = Int(rightElbowPosition.y)
            leftBound = Int(shoulderCenterPostion.x)
            rightBound = matrixWidth-1
            leftSide = Int(rightElbowPosition.x) - radiusOfRightElbow
            rightSide = Int(rightElbowPosition.x) + radiusOfRightElbow
            fillY = bottomBound
            while fillY > topBound {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    print("update abort!")
                    return
                }
                while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 &&
                    !hasBodyPartName(rightSide-1, y: fillY, part: .UpperBody) &&
                    !hasBodyPartName(rightSide-1, y: fillY, part: .LowerBody) {leftSide -= 1}
                while (A[fillY][leftSide] == 0  ||
                    hasBodyPartName(rightSide, y: fillY, part: .UpperBody) ||
                    hasBodyPartName(rightSide, y: fillY, part: .LowerBody)) &&
                    leftSide < rightSide {leftSide += 1}
                while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 {rightSide += 1}
                while (A[fillY][rightSide] == 0 && rightSide > leftSide) {rightSide -= 1}
                for fillX in leftSide...rightSide {
                    appendBodyPartName(fillX, y: fillY, part: .RightForearm)
                }
                fillY -= 1
            }
        }
            //Head
        bottomBound = Int(neckPosition.y)
        topBound = 0
        leftBound = 0
        rightBound = matrixWidth-1
        leftSide = Int(neckPosition.x) - radiusOfNeck
        rightSide = Int(neckPosition.x) + radiusOfNeck
        fillY = bottomBound
        while fillY > topBound {
            if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                print("update abort!")
                return
            }
            while leftSide-1 > leftBound && A[fillY][leftSide-1] != 0 && matrix[fillY][leftSide].0 == nil {leftSide -= 1}
            while (A[fillY][leftSide] == 0  || matrix[fillY][leftSide].0 != nil) &&
            leftSide < rightSide {leftSide += 1}
            while rightSide+1 < rightBound && A[fillY][rightSide+1] != 0 && matrix[fillY][rightSide].0 == nil {rightSide += 1}
            while (A[fillY][rightSide] == 0 || matrix[fillY][rightSide].0 != nil) && rightSide > leftSide {rightSide -= 1}
            for fillX in leftSide...rightSide {
                appendBodyPartName(fillX, y: fillY, part: .Head)
            }
            fillY -= 1
        }
        
        
    // PART3:find if some pixels left
        for y in 0..<matrixHeight {
            for x in 0..<matrixWidth {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    print("update abort!")
                    return
                }
                if matrix[y][x].0 == nil && matrix[y][x].1 == nil{
                    if y < Int(neckPosition.y)  {matrix[y][x].0 = .Head}
                    else {
                        if y < Int(max(leftKneePosition.y,rightKneePosition.y)) {
                            if x < Int(shoulderCenterPostion.x) {matrix[y][x].0 = .LeftForearm}
                            else {matrix[y][x].0 = .RightForearm}
                        } else {
                            if x < Int(shoulderCenterPostion.x) {matrix[y][x].0 = .LeftFoot}
                            else {matrix[y][x].0 = .RightFoot}
                        }
                    }
                }
            }
        }
        isPerformClassifyPixels = false
        print("perform end")
    }
    
    //Naive for Test
    func performNavieClassifyJointsPerPixel() {
        
        isPerformClassifyPixels = true
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
        isPerformClassifyPixels = false
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
        if isPerformClassifyPixels == true {
            return (.Head,nil)
        }
        let relativeX = Int(absolutePosition.x - positionOffset.x)
        let relativeY = Int(absolutePosition.y - positionOffset.y)
        return matrix[relativeY][relativeX]
    }
    
    func getJointsFromRelativePosition(relativePosition: CGPoint) -> (BodyPartName?,BodyPartName?) {
        if isModelValid == false {
            return (nil,nil)
        }
        if isPerformClassifyPixels == true {
            return (.Head,nil)
        }
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
        if y >= matrixHeight || y<0 || x>=matrixWidth || x<0 {return}
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
                    //need setting priority of each part here?[Nop]
                    
                }
            }
        }
    }
    
    private func hasBodyPartName(x:Int,y:Int,part:BodyPartName) -> Boolean {
        let (part1,part2) = matrix[y][x]
        if part1 == nil && part2 == nil {return false}
        if part1 == nil && part2 != nil {return part2 == part}
        return part1 == part || part2 == part
    }
    
    
    //for Part1:   circle
    private func setJointBased(radius:Int,center:CGPoint,addPart:[BodyPartName]) {
        if addPart.count == 0 {return}
        for offsetX in -radius...radius {
            for offsetY in -radius...radius {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    return
                }
                if pow(CGFloat(offsetX),2.0) + pow(CGFloat(offsetY),2.0) > pow(CGFloat(radius),2) {continue}
                let X = Int(center.x) + offsetX, Y = Int(center.y) + offsetY
                for part in addPart {
                    appendBodyPartName(X, y: Y, part: part)
                }
            }
        }
    }
    
    private func checkJointsValid() -> Boolean{

        if joints[.Neck]!.y > joints[.Waist]!.y {return false}
        if joints[.Waist]!.y > joints[.LeftHip]!.y {return false}
        if joints[.Waist]!.y > joints[.RightHip]!.y {return false}
        
        if joints[.LeftShoulder]!.x > joints[.RightShoulder]!.x {return false}
        if joints[.LeftWrist]!.x > joints[.RightWrist]!.x {return false}
        if joints[.LeftHip]!.x > joints[.RightHip]!.x {return false}
        if joints[.LeftKnee]!.x > joints[.RightKnee]!.x {return false}
        if joints[.LeftAnkle]!.x > joints[.RightAnkle]!.x {return false}
        
        if joints[.LeftHip]!.y > joints[.LeftKnee]!.y {return false}
        if joints[.LeftKnee]!.y > joints[.LeftAnkle]!.y {return false}
        if joints[.RightHip]!.y > joints[.RightKnee]!.y {return false}
        if joints[.RightKnee]!.y > joints[.RightAnkle]!.y {return false}
        
        return true
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
