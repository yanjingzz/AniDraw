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
    
    private struct Const {
        static let leftFootCenterOffset = CGPoint(x:0,y:0)
        static let rightFootCenterOffset = CGPoint(x:0,y:0)
        static let headParaBolaRatio = 0.6
        static let waistParaBolaRatio = 0.6
    }
    
    static var lastUpdateTimeStamp : NSDate = NSDate()
    var selfUpdateTimeStamp = NSDate()
    
    var priority: [BodyPartName:Int] = [
        .Head: 0,
        .LowerBody: 15,
        .UpperBody: 15,
        .LeftThigh: 9,
        .RightThigh: 9,
        .LeftShank: 7,
        .RightShank: 7,
        .LeftFoot: 8,
        .RightFoot: 8,
        .LeftUpperArm: 13,
        .RightUpperArm: 13,
        .LeftForearm: 11,
        .RightForearm: 11
        ]
    
    var fillPartInSequence : [BodyPartName] = [
        .UpperBody,
        .LowerBody,
        .LeftUpperArm,
        .RightUpperArm,
        .LeftThigh,
        .RightThigh,
        .LeftShank,
        .RightShank,
        .LeftFoot,
        .RightFoot,
        .LeftForearm,
        .RightForearm,
        .Head
        ]

    
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
        
        var center = [BodyPartName:CGPoint]()
        var gradient = [BodyPartName:CGFloat]()
        var vertical = [BodyPartName:Boolean]()
        var radius = [JointName:Int]()
        
        //initialize center,gradient & vertical
        //vertical == true && gradient = 0 -> two direction joints' x is equal
        for part in BodyPartName.allParts {
            if needAbort() == true {return}
            let (formerJoint,latterJoint) = part.directionJoints
            if formerJoint == latterJoint {
                if formerJoint == JointName.Neck {
                    //head:
                    center[part] = joints[formerJoint]!
                    center[part]!.y = center[part]!.y / 2
                    gradient[part] = 0
                    vertical[part] = true
                }
                if formerJoint == JointName.Waist {
                    //lowerBody:
                    let hipCenter = (joints[.LeftHip]! + joints[.RightHip]!)/2
                    center[part] = (joints[formerJoint]! + hipCenter)/2
                    if joints[formerJoint]!.x == hipCenter.x {
                        gradient[part] = 0
                        vertical[part] = true
                    } else {
                        gradient[part] = (hipCenter.y - joints[formerJoint]!.y) /
                            (hipCenter.x - joints[formerJoint]!.x)
                        vertical[part] = false
                    }
                }
                if formerJoint == JointName.LeftAnkle {
                    //leftFoot:
                    center[part] = (joints[formerJoint]! + Const.leftFootCenterOffset)
                    center[part] = makePointValid(center[part]!)
                    gradient[part] = 0
                    vertical[part] = true
                }
                if formerJoint == JointName.RightAnkle {
                    //rightFoot:
                    center[part] = (joints[formerJoint]! + Const.rightFootCenterOffset)
                    center[part] = makePointValid(center[part]!)
                    gradient[part] = 0
                    vertical[part] = true
                }
            } else {
                //general
                center[part] = (joints[formerJoint]! + joints[latterJoint]!)/2
                if joints[formerJoint]!.x == joints[latterJoint]!.x {
                    gradient[part] = 0
                    vertical[part] = true
                } else {
                    gradient[part] = (joints[latterJoint]!.y - joints[formerJoint]!.y) /
                        (joints[latterJoint]!.x - joints[formerJoint]!.x)
                    vertical[part] = false
                }
            }
        }
        
    // PART1:classifyBasedOnJointPosition
        //calculate radius for each joint
        for joint in JointName.allJoints {
            if needAbort() == true {return}
            let part = joint.DriveBodyPart
            radius[joint] = performMeasureRadius(joint, center: center[part]!,
            gradient: gradient[part]!, vertical: vertical[part]!)
        }
        
        print("[preset parameters]")
        print("gradients & vertical")
        for part in BodyPartName.allParts {
            print("\(part):\(gradient[part]!),\(vertical[part]!)")
        }
        
        //fill each blocks around the joint
        for joint in JointName.allJoints {
            if needAbort() == true {return}
            let part = joint.DriveBodyPart
            if joint == JointName.Neck || joint == JointName.Waist {
                setJointBasedParaBola(radius[joint]!, center: joints[joint]!, ratio: 0.6, addPart: joint.addPart)
            } else {
                if joint != JointName.LeftWrist && joint != JointName.RightWrist {
                    setJointBasedCircle(radius[joint]!, center: joints[joint]!, addPart: joint.addPart)
                }
            }
        }
        
        print("[joints' radius]")
        for joint in JointName.allJoints {
            print("\(joint):\(radius[joint]!)")
        }
        
    // PART2:classify BodyParts & fill
        
        for part in fillPartInSequence {
            if needAbort() == true {return}
            performFillBlocks(part, center: center[part]!, gradient: gradient[part]!,
                              radius: radius[part.anchorJoint]!, vertical: vertical[part]!)
        }
        
    // PART3:find if some non-zero pixels don't belong to any bodypart left
        
        performJudgePixelsAlone(center)
        
        isPerformClassifyPixels = false
        print("perform end")
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
        if relativeX < 0 || relativeX >= matrixWidth || relativeY < 0 || relativeY >= matrixHeight {
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
        if relativeX < 0 || relativeX >= matrixWidth || relativeY < 0 || relativeY >= matrixHeight {
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
        if b1 != nil {priority1 = priority[b1!]!}
        if b2 != nil {priority2 = priority[b2!]!}
        return priority1 > priority2 ? b1 : b2
    }
    
    func setJointsPosition(setJoints:[JointName:CGPoint]) {
        for joint in JointName.allJoints {
            if setJoints[joint] != nil {
                //                print("\(joint):\(setJoints[joint])")
                joints[joint] = setJoints[joint]! - positionOffset
                if Int((joints[joint]?.x)!) >= matrixWidth || Int((joints[joint]?.x)!) < 0 ||
                    Int((joints[joint]?.y)!) >= matrixHeight || Int((joints[joint]?.y)!) < 0 {
                    print("INVALID:\(joint):(\(joints[joint]))")
                    isModelValid = false
                    return
                }
            }
        }
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
    //for PART1
    private func performMeasureRadius(joint:JointName,center:CGPoint,gradient:CGFloat,vertical:Boolean)->Int{
        var X = Int(center.x)
        var Y = Int(center.y)
        
        //Neck & waist's radius can not choose center position
        if joint == JointName.Neck || joint == JointName.Waist{
            X = Int(joints[joint]!.x)
            Y = Int(joints[joint]!.y)
        }
        
        let leftBound,rightBound,upBound,downBound : Int
        let (leftJoint,rightJoint,upJoint,downJoint) = joint.bounds
        leftBound = (leftJoint == nil ? 0:Int(joints[leftJoint!]!.x))
        rightBound = (rightJoint == nil ? matrixWidth-1:Int(joints[rightJoint!]!.x))
        upBound = (upJoint == nil ? 0:Int(joints[upJoint!]!.y))
        downBound = (downJoint == nil ? matrixHeight-1:Int(joints[downJoint!]!.y))
        
        
        if X < leftBound || X > rightBound || Y < upBound || Y > downBound {return 0}
        
        if (abs(gradient) > 1 || vertical == true) {
            var leftSide = X
            var rightSide = X
            var tempY = Y
            let dY = vertical == true ? 0 : -1 / gradient
            
            while leftSide > leftBound && A[tempY][leftSide] == 0 {
                leftSide -= 1
                tempY = Y + Int(CGFloat(leftSide-X) * dY)
                if tempY < upBound || tempY > downBound {
                    return 0
                }
            }
            if leftSide == leftBound {return 0}
            while leftSide >= leftBound && A[tempY][leftSide] != 0 {
                leftSide -= 1
                tempY = Y + Int(CGFloat(leftSide-X) * dY)
                if tempY < upBound || tempY > downBound {
                    return 0
                }
            }
            tempY = Y
            while rightSide < rightBound && A[tempY][rightSide] == 0 {
                rightSide += 1
                tempY = Y + Int(CGFloat(rightSide+X) * dY)
                if tempY < upBound || tempY > downBound {
                    return 0
                }
            }
            if leftSide == rightBound {return 0}
            while rightSide <= rightBound && A[tempY][rightSide] != 0 {
                rightSide += 1
                tempY = Y + Int(CGFloat(rightSide+X) * dY)
                if tempY < upBound || tempY > downBound {
                    return 0
                }
            }
            var leftPoint = CGPoint(x:leftSide,y:Y+Int(CGFloat(leftSide+X)*dY))
            var rightPoint = CGPoint(x:rightSide,y:Y+Int(CGFloat(rightSide+X)*dY))
            leftPoint = makePointValid(leftPoint)
            rightPoint = makePointValid(rightPoint)
            if joint == JointName.LeftElbow {
                print("leftElbow!:point:\(joints[joint]),leftPoint:\(leftPoint),rightPoint:\(rightPoint)")
            }
            return Int((leftPoint-rightPoint).length()/2)
        } else {
            var upSide = Y
            var downSide = Y
            var tempX = X
            while upSide > upBound && A[upSide][tempX] == 0 {
                upSide -= 1
                tempX = X + Int(gradient * CGFloat(Y - upSide))
                if tempX < leftBound || tempX > rightBound {
                    return 0
                }
            }
            if upSide == upBound {return 0}
            while upSide >= upBound && A[upSide][tempX] != 0 {
                upSide -= 1
                tempX = X + Int(gradient * CGFloat(Y - upSide))
                if tempX < leftBound || tempX > rightBound {
                    return 0
                }
            }
            tempX = X
            while downSide < downBound && A[downSide][tempX] == 0 {
                downSide += 1
                tempX = X + Int(gradient * CGFloat(Y - downSide))
                if tempX < leftBound || tempX > rightBound {
                    return 0
                }
            }
            if downSide == downBound {return 0}
            while downSide <= downBound && A[downSide][tempX] != 0 {
                downSide += 1
                tempX = X + Int(gradient * CGFloat(Y - downSide))
                if tempX < leftBound || tempX > rightBound {
                    return 0
                }
            }
            var upPoint = CGPoint(x:X+Int(gradient*CGFloat(Y-upSide)),y:upSide)
            var downPoint = CGPoint(x:X+Int(gradient*CGFloat(Y-downSide)),y:downSide)
            upPoint = makePointValid(upPoint)
            downPoint = makePointValid(downPoint)
            if joint == JointName.LeftElbow {
                print("leftElbow!:point:\(joints[joint]),upPoint:\(upPoint),downPoint:\(downPoint)")
            }

            return Int((upPoint-downPoint).length()/2)
        }
    }
    //for PART2
    private func performFillBlocks(part:BodyPartName,center:CGPoint,gradient:CGFloat,radius:Int,vertical:Boolean) {
        
        let (joint1,joint2) = part.directionJoints
        var endPoint1 = joints[joint1]!
        var endPoint2 = joints[joint2]!
        var X = Int(center.x)
        var Y = Int(center.y)
        
        if part == BodyPartName.Head {
            endPoint1 = CGPoint(x:center.x,y:CGFloat(0))
            X = Int(endPoint2.x)
            Y = Int(endPoint2.y)
        }
        
        if part == BodyPartName.UpperBody {
            X = Int(endPoint2.x)
            Y = Int(endPoint2.y)
        }
        
        if part == BodyPartName.LowerBody {
            endPoint2 = center
            X = Int(joints[part.anchorJoint]!.x)
            Y = Int(joints[part.anchorJoint]!.y)
        }
        
        if part == BodyPartName.LeftFoot || part == BodyPartName.RightFoot{
            endPoint2 = CGPoint(x:joints[part.anchorJoint]!.x,y:CGFloat(matrixHeight-1))
        }
        
        //choose fill direction according to gradient
        if vertical == true || abs(gradient) > 1 {
            //to endPoint1
            fillInXDegrees(X, srcY: Y, destX: Int(endPoint1.x), destY: Int(endPoint1.y), gradient: gradient, part: part, radius: radius)
            //to endPoint2
            fillInXDegrees(X, srcY: Y, destX: Int(endPoint2.x), destY: Int(endPoint2.y), gradient: gradient, part: part, radius: radius)
        } else {
            //to endPoint1
            fillInYDegrees(X, srcY: Y, destX: Int(endPoint1.x), destY: Int(endPoint1.y), gradient: gradient, part: part, radius: radius)
            //to endPoint2
            fillInYDegrees(X, srcY: Y, destX: Int(endPoint2.x), destY: Int(endPoint2.y), gradient: gradient, part: part, radius: radius)
        }
    }
    
    private func fillInXDegrees(srcX:Int,srcY:Int,destX:Int,destY:Int,gradient:CGFloat,part:BodyPartName,radius:Int) {
        let dif = gradient == 0 ? 0 : -1 / gradient
        let dx = sqrt(CGFloat(radius * radius) / (CGFloat(1) + dif * dif))
        var X = srcX
        var Y = srcY
        while Y != destY {
            //from center to leftSide
            var leftX = max(X - Int(dx),0)
            if needAbort() == true {return}
            var tmpX = leftX - 1
            var tmpY = Y + Int(dif*CGFloat(tmpX-X))
            while tmpY >= 0 && tmpY < matrixHeight && tmpX >= 0 && A[tmpY][tmpX] != 0 {
                leftX = tmpX
                tmpX = leftX - 1
                tmpY = Y + Int(dif*CGFloat(tmpX-X))
            }
            tmpX = leftX
            tmpY = Y + Int(dif*CGFloat(tmpX-X))
            while tmpY >= 0 && tmpY < matrixHeight && tmpX <= X && A[tmpY][tmpX] == 0 {
                leftX = tmpX
                tmpX = leftX + 1
                tmpY = Y + Int(dif*CGFloat(tmpX-X))
            }
            //fill from leftSide to center
            tmpX = leftX
            tmpY = Y + Int(dif*CGFloat(tmpX-X))
            while tmpX != X {
                let part1 = matrix[tmpY][tmpX].0
                if part1 == nil || (part1 != nil && priority[part] >= priority[part1!])
                    {appendBodyPartName(tmpX, y: tmpY, part: part)}
                tmpX += 1
                tmpY = Y + Int(dif*CGFloat(tmpX-X))
            }
            //from center to rightSide(as to leftSide)
            var rightX = min(X + Int(dx),matrixWidth-1)
            if needAbort() == true {return}
            tmpX = rightX + 1
            tmpY = Y + Int(dif*CGFloat(tmpX-X))
            while tmpY >= 0 && tmpY < matrixHeight && tmpX < matrixWidth-1 && A[tmpY][tmpX] != 0 {
                rightX = tmpX
                tmpX = rightX + 1
                tmpY = Y + Int(dif*CGFloat(tmpX-X))
            }
            tmpX = rightX
            tmpY = Y + Int(dif*CGFloat(tmpX-X))
            while tmpY >= 0 && tmpY < matrixHeight && tmpX >= X && A[tmpY][tmpX] == 0 {
                rightX = tmpX
                tmpX = rightX - 1
                tmpY = Y + Int(dif*CGFloat(tmpX-X))
            }
            //fill from rightSide to center
            tmpX = rightX
            tmpY = Y + Int(dif*CGFloat(tmpX-X))
            while tmpX != X {
                let part1 = matrix[tmpY][tmpX].0
                if part1 == nil || (part1 != nil && priority[part] >= priority[part1!])
                    {appendBodyPartName(tmpX, y: tmpY, part: part)}
                tmpX -= 1
                tmpY = Y + Int(dif*CGFloat(tmpX-X))
            }
            if Y < destY {
                Y += 1
                X = srcX - Int(CGFloat(Y-srcY)*dif)
            } else {
                Y -= 1
                X = srcX - Int(CGFloat(Y-srcY)*dif)
            }
        }
    }
    
    private func fillInYDegrees(srcX:Int,srcY:Int,destX:Int,destY:Int,gradient:CGFloat,part:BodyPartName,radius:Int) {
        let dy = sqrt(CGFloat(radius*radius) / (CGFloat(1) + gradient * gradient))
        var X = srcX
        var Y = srcY
        while X != destX {
            //from center to upSide
            var upY = max(0,Y - Int(dy))
            if needAbort() == true {return}
            var tmpY = upY - 1
            var tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            while tmpX >= 0 && tmpX < matrixWidth && tmpY >= 0 && A[tmpY][tmpX] != 0 {
                upY = tmpY
                tmpY = upY - 1
                tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            }
            tmpY = upY
            tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            while tmpX >= 0 && tmpX < matrixWidth && tmpY <= Y && A[tmpY][tmpX] == 0 {
                upY = tmpY
                tmpY = upY + 1
                tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            }
            //fill from upSide to center
            tmpY = upY
            tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            while tmpY != Y {
                let part1 = matrix[tmpY][tmpX].0
                if part1 == nil || (part1 != nil && priority[part] >= priority[part1!])
                    {appendBodyPartName(tmpX, y: tmpY, part: part)}
                tmpY += 1
                tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            }
            //from center to downSide
            var downY = min(Y + Int(dy),matrixHeight-1)
            if needAbort() == true {return}
            tmpY = downY + 1
            tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            while tmpX >= 0 && tmpX < matrixWidth && tmpY < matrixHeight-1 && A[tmpY][tmpX] != 0 {
                downY = tmpY
                tmpY = downY + 1
                tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            }
            tmpY = downY
            tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            while tmpX >= 0 && tmpX < matrixWidth && tmpY >= Y && A[tmpY][tmpX] == 0 {
                downY = tmpY
                tmpY = downY - 1
                tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            }
            //fill from upSide to center
            tmpY = downY
            tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            while tmpY != Y {
                let part1 = matrix[tmpY][tmpX].0
                if part1 == nil || (part1 != nil && priority[part] >= priority[part1!])
                    {appendBodyPartName(tmpX, y: tmpY, part: part)}
                tmpY -= 1
                tmpX = X - Int(gradient*CGFloat(tmpY - Y))
            }
            if X < destX {
                X += 1
                Y = srcY + Int(gradient * CGFloat(X - srcX))
            } else {
                X -= 1
                Y = srcY + Int(gradient * CGFloat(X - srcX))
            }
        }
    }
    //for PART3
    private func performJudgePixelsAlone(center:[BodyPartName:CGPoint]) {
        for y in 0..<matrixHeight {
            for x in 0..<matrixWidth {
                if needAbort() == true {return}
                if A[y][x] != 0 && matrix[y][x].0 == nil && matrix[y][x].1 == nil{
                    //check pixels around
                    var bodyPartCount = [BodyPartName:Int]()
                    for part in BodyPartName.allParts {
                        bodyPartCount[part] = 0
                    }
                    var hasResultThroughAroundPixels = false
                    for offsetY in -3...3 {
                        for offsetX in -3...3 {
                            let Y = y+offsetY
                            let X = x+offsetX
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
                                    if priority[part] > priority[selectBodyPartName] {
                                        selectBodyPartName = part
                                    }
                                }
                            }
                        }
                        matrix[y][x].0 = selectBodyPartName
                    } else {
                        //calculate the distance of the pixel to all BodyPart center position & find the minimun one
                        let pixelPosition = CGPoint(x:CGFloat(x),y:CGFloat(y))
                        var selectBodyPartName : BodyPartName = .Head
                        var minDistance : CGFloat = -1
                        for part in BodyPartName.allParts {
                            let distance = (center[part]! - pixelPosition).length()
                            if distance < minDistance {
                                selectBodyPartName = part
                                minDistance = distance
                            } else {
                                if distance == minDistance {
                                    if priority[part] > priority[selectBodyPartName] {
                                        selectBodyPartName = part
                                    }
                                }
                            }
                            if minDistance == -1 {
                                selectBodyPartName = part
                                minDistance = distance
                            }
                        }
                        matrix[y][x].0 = selectBodyPartName
                    }
                }
            }
        }
    }
    
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
                if needAbort() == true {return}
                if pow(CGFloat(offsetX),2.0) + pow(CGFloat(offsetY),2.0) > pow(CGFloat(radius),2) {continue}
                let X = Int(center.x) + offsetX, Y = Int(center.y) + offsetY
                if X < 0 || X > matrixWidth-1 || Y < 0 || Y > matrixHeight-1 {continue}
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
    
    private func makePointValid(point:CGPoint) -> CGPoint {
        var resultPoint = point
        if point.x < 0 {resultPoint.x = 0}
        if point.x > CGFloat(matrixWidth-1) {resultPoint.x = CGFloat(matrixWidth-1)}
        if point.y < 0 {resultPoint.y = 0}
        if point.y > CGFloat(matrixHeight-1) {resultPoint.y = CGFloat(matrixHeight-1)}
        return resultPoint
    }
    
    private func checkJointsValid() -> Boolean{

        if joints[.Neck]!.y > joints[.Waist]!.y ||
            joints[.Waist]!.y > joints[.LeftHip]!.y ||
            joints[.Waist]!.y > joints[.RightHip]!.y {return false}
        
        if joints[.LeftShoulder]!.x > joints[.RightShoulder]!.x ||
            joints[.LeftWrist]!.x > joints[.RightWrist]!.x ||
            joints[.LeftHip]!.x > joints[.RightHip]!.x ||
            joints[.LeftKnee]!.x > joints[.RightKnee]!.x ||
            joints[.LeftAnkle]!.x > joints[.RightAnkle]!.x {return false}
        
        if joints[.LeftHip]!.y > joints[.LeftKnee]!.y ||
            joints[.LeftKnee]!.y > joints[.LeftAnkle]!.y ||
            joints[.RightHip]!.y > joints[.RightKnee]!.y ||
            joints[.RightKnee]!.y > joints[.RightAnkle]!.y {return false}
        return true
    }

    private func needAbort() -> Boolean {
        if selfUpdateTimeStamp != SkeletonModel.lastUpdateTimeStamp {
            print("update abort!")
            return true
        }
        return false
    }
}

