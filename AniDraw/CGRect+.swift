//
//  CGRect+.swift
//  AniDraw
//
//  Created by Mike on 6/30/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
extension CGRect {
    var center:CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}