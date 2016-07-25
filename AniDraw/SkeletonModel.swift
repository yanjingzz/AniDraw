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
        let hipCenterPosition = (leftHipPosition + rightHipPosition) / 2
        
        let centerOfHead = CGPoint(x:neckPosition.x,y:neckPosition.y / 2)
        let centerOfUpperBody = (neckPosition + waistPosition)/2
        let centerOfLowerBody = (hipCenterPosition + waistPosition)/2
        let centerOfLeftUpperArm = (leftShoulderPosition + leftElbowPosition)/2
        let centerOfRightUpperArm = (rightShoulderPosition + rightElbowPosition)/2
        let centerOfLeftForearm = (leftElbowPosition + leftWristPosition)/2
        let centerOfRightForearm = (rightElbowPosition + rightWristPosition)/2
        let centerOfLeftThigh = (leftHipPosition + leftKneePosition)/2
        let centerOfRightThigh = (rightHipPosition + rightKneePosition)/2
        let centerOfLeftShank = (leftKneePosition+leftAnklePosition)/2
        let centerOfRightShank = (rightKneePosition+rightAnklePosition)/2
        let centerOfLeftFoot = leftAnklePosition
        let centerOfRightFoot = rightAnklePosition
        
//        let gradientOnLeftShoulderToRightShoulder = (rightShoulderPosition.y - leftShoulderPosition.y) /
//            (rightShoulderPosition.x - leftShoulderPosition.x) // the same as gradientOnCenterToRightShoulder

        //gradient for limbs
        //leftUpperArm
        var leftUpperArmVertical : Boolean = false
        var gradientOnLeftShoulderToElbow : CGFloat = 0
        if leftShoulderPosition.x == leftElbowPosition.x {
            leftUpperArmVertical = true
        } else {
            gradientOnLeftShoulderToElbow = (leftShoulderPosition.y - leftElbowPosition.y) /
            (leftShoulderPosition.x - leftElbowPosition.x)
        }
        //rightUpperArm
        var rightUpperArmVertical : Boolean = false
        var gradientOnRightShoulderToElbow : CGFloat = 0
        if rightShoulderPosition.x == rightElbowPosition.x {
            rightUpperArmVertical = true
        } else {
            gradientOnRightShoulderToElbow = (rightShoulderPosition.y - rightElbowPosition.y) /
                (rightShoulderPosition.x - rightElbowPosition.x)
        }
        //leftForearm
        var leftForearmVertical : Boolean = false
        var gradientOnLeftElbowToWrist : CGFloat = 0
        if leftElbowPosition.x == leftWristPosition.x {
            leftForearmVertical = true
        } else {
            gradientOnLeftElbowToWrist = (leftElbowPosition.y - leftWristPosition.y) /
                (leftElbowPosition.x - leftWristPosition.x)
        }
        //rightForearm
        var rightForearmVertical : Boolean = false
        var gradientOnRightElbowToWrist : CGFloat = 0
        if rightElbowPosition.x == rightWristPosition.x {
            rightForearmVertical = true
        } else {
            gradientOnRightElbowToWrist = (rightElbowPosition.y - rightWristPosition.y) /
                (rightElbowPosition.x - rightWristPosition.x)
        }
        //leftThigh
        var leftThighVertical : Boolean = false
        var gradientOnLeftHipToKnee : CGFloat = 0
        if leftHipPosition.x == leftKneePosition.x {
            leftThighVertical = true
        } else {
            gradientOnLeftHipToKnee = (leftHipPosition.y - leftKneePosition.y) /
                (leftHipPosition.x - leftKneePosition.x)
        }
        //rightThigh
        var rightThighVertical : Boolean = false
        var gradientOnRightHipToKnee : CGFloat = 0
        if rightHipPosition.x == rightKneePosition.x {
            rightThighVertical = true
        } else {
            gradientOnRightHipToKnee = (rightHipPosition.y - rightKneePosition.y) /
                (rightHipPosition.x - rightKneePosition.x)
        }
        //leftShank
        var leftShankVertical : Boolean = false
        var gradientOnLeftKneeToAnkle : CGFloat = 0
        if leftKneePosition.x == leftAnklePosition.x {
            leftShankVertical = true
        } else {
            gradientOnLeftKneeToAnkle = (leftKneePosition.y - leftAnklePosition.y) /
                (leftKneePosition.x - leftAnklePosition.x)
        }
        //rightShank
        var rightShankVertical : Boolean = false
        var gradientOnRightKneeToAnkle : CGFloat = 0
        if rightKneePosition.x == rightAnklePosition.x {
            rightShankVertical = true
        } else {
            gradientOnRightKneeToAnkle = (rightKneePosition.y - rightAnklePosition.y) /
                (rightKneePosition.x - rightAnklePosition.x)
        }
        
        print("---[gradient]---")
        print("leftUpperArm:\(gradientOnLeftShoulderToElbow)")
        print("leftForearm:\(gradientOnLeftElbowToWrist)")
        print("rightUpperArm:\(gradientOnRightShoulderToElbow)")
        print("rightForearm:\(gradientOnRightElbowToWrist)")
        print("leftThigh:\(gradientOnLeftHipToKnee)")
        print("rightThigh:\(gradientOnRightHipToKnee)")
        print("leftShank:\(gradientOnLeftKneeToAnkle)")
        print("rightShank:\(gradientOnRightKneeToAnkle)")
        
        //if raise for limbs
        var leftUpperArmRaise : Boolean = false
        var rightUpperArmRaise : Boolean = false
        var leftForearmRaise : Boolean = false
        var rightForearmRaise : Boolean = false
        
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
        
            //shoulder
            //left
        X = Int(leftShoulderPosition.x)
        Y = Int(leftShoulderPosition.y)
        var radiusOfLeftShoulder : Int = 0
        //min(shoulderWidth / 5,X,matrixWidth-X-1)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfLeftShoulder = 0
        } else {
            leftBound = 0
            rightBound = Int(shoulderCenterPostion.x) - shoulderWidth / 3
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
            radiusOfLeftShoulder = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }
        
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }
            //right
        X = Int(rightShoulderPosition.x)
        Y = Int(rightShoulderPosition.y)
        var radiusOfRightShoulder : Int = 0
        //min(shoulderWidth / 5,X,matrixWidth-X-1)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfRightShoulder = 0
        } else {
            leftBound = Int(shoulderCenterPostion.x) + shoulderWidth / 3
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
            radiusOfRightShoulder = min(max(rightSide-X,X-leftSide),X,matrixWidth-X-1)
        }
        
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return
        }
        
            //elbow
            //left
        var radiusOfLeftElbow : Int = 0
        
        X = Int(leftElbowPosition.x)
        Y = Int(leftElbowPosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfLeftElbow = 0
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
            //right
        var radiusOfRightElbow : Int = 0
        
        X = Int(rightElbowPosition.x)
        Y = Int(rightElbowPosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfRightElbow = 0
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
            //left
        var radiusOfLeftHip : Int = 0
        
        X = Int(leftHipPosition.x)
        Y = Int(leftHipPosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfLeftHip = 0
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
            //right
        var radiusOfRightHip : Int = 0
        
        X = Int(rightHipPosition.x)
        Y = Int(rightHipPosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfRightHip = 0
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
            //left
        var radiusOfLeftKnee : Int = 0
        X = Int(leftKneePosition.x)
        Y = Int(leftKneePosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfLeftKnee = 0
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
            //right
        var radiusOfRightKnee : Int = 0
        X = Int(rightKneePosition.x)
        Y = Int(rightKneePosition.y)
        leftSide = X-1
        rightSide = X+1
        if A[Y][X] != 0 && A[Y][leftSide] == 0 && A[Y][rightSide] == 0 {
            radiusOfRightKnee = 0
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
            radiusOfLeftAnkle = 0
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
            radiusOfRightAnkle = 0
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

        
        setJointBasedParaBola(radiusOfNeck, center: neckPosition, ratio: 0.6, addPart: (.Head, nil))
        setJointBasedParaBola(radiusOfWaist, center: waistPosition, ratio: 0.6, addPart: (.UpperBody,.LowerBody))
        setJointBasedCircle(radiusOfLeftShoulder, center: leftShoulderPosition, addPart: (.LeftUpperArm,nil))
        setJointBasedCircle(radiusOfLeftElbow, center: leftElbowPosition, addPart: (.LeftUpperArm,nil))
        setJointBasedCircle(radiusOfRightShoulder, center: rightShoulderPosition, addPart: (.RightUpperArm,nil))
        setJointBasedCircle(radiusOfRightElbow, center: rightElbowPosition, addPart: (.RightUpperArm,nil))
        setJointBasedCircle(radiusOfLeftHip, center: leftHipPosition, addPart: (.LeftThigh,nil))
        setJointBasedCircle(radiusOfLeftKnee, center: leftKneePosition, addPart: (.LeftThigh,nil))
        setJointBasedCircle(radiusOfLeftKnee, center: leftAnklePosition, addPart: (.LeftShank,nil))
        setJointBasedCircle(radiusOfRightHip, center: rightHipPosition, addPart: (.RightThigh,nil))
        setJointBasedCircle(radiusOfRightKnee, center: rightKneePosition, addPart: (.RightThigh,nil))
        setJointBasedCircle(radiusOfRightKnee, center: rightAnklePosition, addPart: (.RightShank,nil))
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
            leftUpperArmRaise = true
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
            rightUpperArmRaise = true
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
            leftForearmRaise = true
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
            rightForearmRaise = true
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
        
        
    // PART3:find if some non-zero pixels don't belong to any bodypart left
        
        for y in 0..<matrixHeight {
            for x in 0..<matrixWidth {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    print("update abort!")
                    return
                }
                if A[y][x] != 0 && matrix[y][x].0 == nil && matrix[y][x].1 == nil{
                    //check pixels around
                    var bodyPartCount = [BodyPartName:Int]()
                    for part in BodyPartName.allParts {
                        bodyPartCount[part] = 0
                    }
                    var hasResultThroughAroundPixels = false
                    for offsetY in -3...3 {
                        for offsetX in -3...3 {
                            Y = y+offsetY
                            X = x+offsetX
                            if X < 0 || X >= matrixWidth || Y < 0 || Y >= matrixHeight {continue}
                            if A[Y][X] != 0 &&
                                matrix[y+offsetY][x+offsetX].0 != nil {
                                hasResultThroughAroundPixels = true
                                let tempPart = (matrix[y+offsetY][x+offsetX].0)!
                                bodyPartCount[tempPart]! += 1
                            }
                        }
                    }
                    
                    if hasResultThroughAroundPixels == true {
                        //calculate the most possible bodypartname that pixel belongs to
                        var selectBodyPartName : BodyPartName = .Head
                        var maxCount : Int = -1
                        for part in BodyPartName.allParts {
                            if bodyPartCount[part]! > maxCount {
                                selectBodyPartName = part
                                maxCount = bodyPartCount[part]!
                            } else {
                                if bodyPartCount[part]! == maxCount {
                                    if priorityOfBodyPartName[part] > priorityOfBodyPartName[selectBodyPartName] {
                                        selectBodyPartName = part
                                    }
                                }
                            }
                        }
                        matrix[y][x].0 = selectBodyPartName
                    } else {
//                        calculate the distance of the pixel to all BodyPart center position & find the minimun one
                        let pixelPosition = CGPoint(x:CGFloat(x),y:CGFloat(y))
                        var distanceToBodyPart = [BodyPartName:CGFloat]()
                        distanceToBodyPart[.Head] = distance(centerOfHead,p2:pixelPosition)
                        distanceToBodyPart[.UpperBody] = distance(centerOfUpperBody,p2:pixelPosition)
                        distanceToBodyPart[.LowerBody] = distance(centerOfLowerBody,p2:pixelPosition)
                        distanceToBodyPart[.LeftUpperArm] = distance(centerOfLeftUpperArm,p2:pixelPosition)
                        distanceToBodyPart[.RightUpperArm] = distance(centerOfRightUpperArm,p2:pixelPosition)
                        distanceToBodyPart[.LeftForearm] = distance(centerOfLeftForearm,p2:pixelPosition)
                        distanceToBodyPart[.RightForearm] = distance(centerOfRightForearm,p2:pixelPosition)
                        distanceToBodyPart[.LeftThigh] = distance(centerOfLeftThigh,p2:pixelPosition)
                        distanceToBodyPart[.RightThigh] = distance(centerOfRightThigh,p2:pixelPosition)
                        distanceToBodyPart[.LeftShank] = distance(centerOfLeftShank,p2:pixelPosition)
                        distanceToBodyPart[.RightShank] = distance(centerOfRightShank,p2:pixelPosition)
                        distanceToBodyPart[.LeftFoot] = distance(centerOfLeftFoot,p2:pixelPosition)
                        distanceToBodyPart[.RightFoot] = distance(centerOfRightFoot,p2:pixelPosition)
                        var selectBodyPartName : BodyPartName = .Head
                        var minDistance : CGFloat = -1
                        for part in BodyPartName.allParts {
                            if distanceToBodyPart[part] < minDistance {
                                selectBodyPartName = part
                                minDistance = distanceToBodyPart[part]!
                            } else {
                                if distanceToBodyPart[part] == minDistance {
                                    if priorityOfBodyPartName[part] > priorityOfBodyPartName[selectBodyPartName] {
                                        selectBodyPartName = part
                                    }
                                }
                            }
                            if minDistance == -1 {
                                selectBodyPartName = part
                                minDistance = distanceToBodyPart[part]!
                            }
                        }
                        matrix[y][x].0 = selectBodyPartName
                    }
                }
            }
        }
        isPerformClassifyPixels = false
        print("perform end")
    }

    func performSuperNaiveClassifyJointsPerPixel() {
        isPerformClassifyPixels = true
        if isModelValid == false {
            return
        } else {
            print("valid!!!")
            for y in 0..<matrixHeight {
                for x in 0..<matrixWidth {
                    matrix[y][x] = (.Head,nil)
                }
            }
        }
        
    }
    
    //Naive for Test
    func performNaiveClassifyJointsPerPixel() {
        
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
    
    func getBodyPartsFromAbsolutePosition(absolutePosition: CGPoint) -> (BodyPartName?,BodyPartName?) {
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
    
    func getBodyPartsFromRelativePosition(relativePosition: CGPoint) -> (BodyPartName?,BodyPartName?) {
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
    
    private func distance(p1:CGPoint,p2:CGPoint) -> CGFloat{
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        return dx*dx+dy*dy
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
    private func setJointBasedCircle(radius:Int,center:CGPoint,addPart:(BodyPartName?,BodyPartName?)) {
        if radius == 0 {return}
        let upperBodyName = addPart.0
        let lowerBodyName = addPart.1
//        if addPart.count == 0 {return}
        for offsetX in -radius...radius {
            for offsetY in -radius...radius {
                if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                    return
                }
                if pow(CGFloat(offsetX),2.0) + pow(CGFloat(offsetY),2.0) > pow(CGFloat(radius),2) {continue}
                let X = Int(center.x) + offsetX, Y = Int(center.y) + offsetY
                if upperBodyName != nil {appendBodyPartName(X, y: Y, part: upperBodyName!)}
                if lowerBodyName != nil {appendBodyPartName(X, y: Y, part: lowerBodyName!)}
            }
        }
    }
    
    private func setJointBasedParaBola(radius:Int,center:CGPoint,ratio:Double,addPart:(BodyPartName?,BodyPartName?)) {
        if radius == 0 {return}
        let upperBodyName = addPart.0
        let lowerBodyName = addPart.1
        let k = ratio / Double(radius)
        //upper
        if upperBodyName != nil {
            for offsetY in 0...radius {
                for offsetX in -radius...radius {
                    if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                        return
                    }
                    let valueY = Double(-offsetY)
                    if valueY > k * Double(offsetX*offsetX-radius*radius) {
                        let X = Int(center.x) + offsetX, Y = Int(center.y) + offsetY
                        appendBodyPartName(X, y: Y, part: upperBodyName!)
                    }
                }
            }
        }
        //lower
        if lowerBodyName != nil {
            for offsetY in -radius...0 {
                for offsetX in -radius...radius {
                    if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
                        return
                    }
                    let valueY = Double(-offsetY)
                    if valueY < -k * Double(offsetX*offsetX-radius*radius) {
                        let X = Int(center.x) + offsetX, Y = Int(center.y) + offsetY
                        appendBodyPartName(X, y: Y, part: lowerBodyName!)
                    }
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
