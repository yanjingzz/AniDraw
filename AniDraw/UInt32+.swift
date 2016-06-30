//
//  UInt32+.swift
//  AniDraw
//
//  Created by Mike on 6/30/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import Foundation

extension UInt32 {
    var alphaValue: Int {
        return Int(self & 0xFF)
    }
    var rValue: Int {
        return Int((self >> 8) & 0xFF)
    }
    var gValue: Int {
        return Int((self >> 16) & 0xFF)
    }
    var bValue: Int {
        return Int((self >> 24)  & 0xFF)
    }
}