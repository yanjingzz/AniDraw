//
//  CGRect+.swift
//  AniDraw
//
//  Created by Mike on 6/30/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
extension CGRect {
    public var center:CGPoint {
        get {
            return CGPoint(x: midX, y: midY)
        }
        set {
            origin = newValue - CGPoint(x: width / 2, y: height / 2)
        }
    }
    public func shrinkedByMargin(margin: CGFloat) -> CGRect {
     return CGRect(x: minX + margin, y: minY + margin, width: size.width - 2 * margin, height: size.height - 2 * margin)
    }
}