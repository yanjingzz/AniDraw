//
//  SkeletonView.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

class SkeletonView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    lazy var joints: [JointName: JointView] = self.createJoints()
    
    private func createJoints() -> [JointName: JointView] {
        var joints = [JointName: JointView]()
        for part in JointName.allJoints {
            let jointView = JointView()
            jointView.bounds = CGRect(x: 0, y: 0, width: Constants.JointSize, height: Constants.JointSize)
            joints[part] = jointView
            jointView.opaque = false
            addSubview(jointView)
            jointView.userInteractionEnabled = true
        }
        return joints
    }
    override func layoutSubviews() {
        for joint in JointName.allJoints {
            let position = Constants.DefaultPositionForJoint[joint]!
            joints[joint]!.frame = CGRect(x: position.x, y: position.y, width: Constants.JointSize, height: Constants.JointSize)
        }
    }
    
    override func drawRect(rect: CGRect) {
        for (partA, partB) in Constants.LinesBetweenJoints {
            let pointA = joints[partA]!.center
            let pointB = joints[partB]!.center
            let path = UIBezierPath()
            path.moveToPoint(pointA)
            path.addLineToPoint(pointB)
            path.lineWidth = 2.0
            UIColor.grayColor().setStroke()
            path.stroke()
            
        }
    }
    
    
    
        
    
    struct Constants {
        static let DefaultPositionForJoint:[JointName: CGPoint] = [
            .Neck:     CGPoint(x: 512, y: 200),
            .Waist:     CGPoint(x: 512, y: 300),
            .LeftShoulder:  CGPoint(x: 512 - 150, y: 250),
            .LeftElbow:   CGPoint(x: 512 - 150, y: 350),
            .LeftWrist:   CGPoint(x: 512 - 150, y: 450),
            .LeftHip:     CGPoint(x: 512 - 50, y: 400),
            .LeftKnee:     CGPoint(x: 512 - 50, y: 500),
            .LeftAnkle:      CGPoint(x: 512 - 50, y: 550),
            .RightShoulder: CGPoint(x: 512 + 150, y: 250),
            .RightElbow:  CGPoint(x: 512 + 150, y: 350),
            .RightWrist:   CGPoint(x: 512 + 150, y: 450),
            .RightHip:    CGPoint(x: 512 + 50, y: 400),
            .RightKnee:    CGPoint(x: 512 + 50, y: 500),
            .RightAnkle:     CGPoint(x: 512 + 50, y: 550)
        ]
        static let LinesBetweenJoints: [(JointName, JointName)] = [
            (.Neck, .Waist),
            (.Neck, .LeftShoulder),
            (.Neck, .RightShoulder),
            
            (.LeftElbow, .LeftShoulder),
            (.LeftElbow, .LeftWrist),
            (.RightElbow, .RightShoulder),
            (.RightElbow, .RightWrist),
            
            
            (.Waist, .LeftHip),
            (.Waist, .RightHip),
            
            (.LeftKnee, .LeftHip),
            (.RightKnee, .RightHip),
            
            (.LeftKnee, .LeftAnkle),
            (.RightKnee, .RightAnkle),
            
        ]
        static let JointSize: CGFloat = 30
    }

}


