//
//  SkeletonModel.swift
//  AniDraw
//
//  Created by hcsi on 16/7/14.
//  Copyright © 2016年 yanjingzz. All rights reserved.
//

import Foundation

class SkeletonModel {
    var positionOffset : CGPoint = CGPoint()
    //joints' position is related to the image instead of view
    var joints : [JointName:CGPoint]!
    var characterImage : UIImage!
    var pixelsBelongToJointsMatrix : [[[BodyPartName]?]]
    
    init(offset: CGPoint, image:UIImage, jointList:[JointName:CGPoint]) {
        characterImage = image
        var matrixWidth = image.size.width
        var matrixHeight = image.size.height
        positionOffset = offset
        for joint in JointName.allJoints{
            joints[joint] = jointList[joint]! - offset
            if joints[joint]!.x > matrixWidth {
                matrixWidth = joints[joint]!.x
            }
            if joints[joint]!.y > matrixHeight {
                matrixHeight = joints[joint]!.y
            }
        }
        pixelsBelongToJointsMatrix = Array(count: Int(matrixWidth), repeatedValue: Array(count: Int(matrixHeight), repeatedValue: nil))
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
        
        let jointRadius = 5
        
    // PART1:classifyBasedOnJointPosition
        // Head
        
//        for offsetX in -jointsRadius...jointRadius {
//            for offsetY in -jointsRadiu...jointRadius {
//                
//            }
//        }
        
        
    // PART2:classifyBoundsOfBodyParts
        
        
    // PART3:fillPixelsBasedOnBounds
        
        
    }
    
    func getJointsFromAbsolutePosition(absolutePosition: CGPoint) -> [BodyPartName]? {
        return pixelsBelongToJointsMatrix[Int(absolutePosition.x - positionOffset.x)][Int(absolutePosition.y - positionOffset.y)]
    }
    
    func getJointsFromRelativePosition(relativePosition: CGPoint) -> [BodyPartName]? {
        return pixelsBelongToJointsMatrix[Int(relativePosition.x)][Int(relativePosition.y)]
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
