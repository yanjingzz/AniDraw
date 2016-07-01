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
    
    lazy private var joints: [JointName: JointView] = self.createJoints()
    var jointPositionInView:[JointName: CGPoint] {
        var ret = [JointName: CGPoint]()
        for (joint, view) in joints {
            ret[joint] = view.frame.center
        }
        return ret
    }
    
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
            .Neck: CGPoint(x: 511.0, y: 280.0),
            .Waist: CGPoint(x: 511.0, y: 339.0),
            .LeftShoulder: CGPoint(x: 460.0, y: 299.0),
            .LeftElbow: CGPoint(x: 419.0, y: 335.0),
            .LeftWrist: CGPoint(x: 395.0, y: 460.0),
            .LeftHip: CGPoint(x: 487.0, y: 435.0),
            .LeftKnee: CGPoint(x: 486.0, y: 519.0),
            .LeftAnkle: CGPoint(x: 481.0, y: 607.0),
            .RightShoulder: CGPoint(x: 559.0, y: 296.0),
            .RightElbow: CGPoint(x: 607.0, y: 336.0),
            .RightWrist: CGPoint(x: 629.0, y: 452.0),
            .RightHip: CGPoint(x: 537.0, y: 434.0),
            .RightKnee: CGPoint(x: 542.0, y: 514.0),
            .RightAnkle: CGPoint(x: 549.0, y: 601.0)
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


