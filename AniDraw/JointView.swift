//
//  JointView.swift
//  AniDraw
//
//  Created by Mike on 6/29/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

class JointView: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let margin: CGFloat = 2.0
        let rect = CGRect(x: bounds.minX + margin, y: bounds.minY + margin, width: bounds.size.width - 2 * margin, height: bounds.size.height - 2 * margin)
        let path = UIBezierPath(ovalInRect: rect)
        path.lineWidth = 2.0
        UIColor.grayColor().setStroke()
        UIColor.whiteColor().setFill()
        path.stroke()
        path.fill()
    }
    
//    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
//        if window == nil || superview == nil || hidden  {
//            return false
//        }
//        return (point - bounds.center).length() < 50
//    }

}
