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
        for i in 1...3 {
            let rect = bounds.shrinkedByMargin(CGFloat(i) * margin)
            let path = UIBezierPath(ovalInRect: rect)
            path.lineWidth = 2.0
            if i % 2 == 0 {
                UIColor.grayColor().setStroke()
            }
            else {
                UIColor.whiteColor().setStroke()
            }
            path.stroke()
        }
       
        
        
        
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if window == nil || superview == nil || hidden  {
            return false
        }
        return (point - bounds.center).length() < 20
    }

}
