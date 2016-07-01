//
//  UIImage+.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

public extension UIImage {
    
    func BoundingBoxOfNontransparentPixels() -> CGRect {
        let imageAsCGImage = self.CGImage
        guard let context:CGContextRef = self.createARGBBitmapContext() else {
            return CGRectZero
        }
        let width = CGImageGetWidth(imageAsCGImage)
        let height = CGImageGetHeight(imageAsCGImage)
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
        CGContextDrawImage(context, rect, imageAsCGImage)
        
        var lowX = width
        var lowY = height
        var highX = 0
        var highY = 0
        let data = CGBitmapContextGetData(context)

        let dataType = UnsafeMutablePointer<UInt8>(data)
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex:Int = (width * y + x) * 4 /* 4 for A, R, G, B */;
                if (dataType[pixelIndex] != 0) { //Alpha value is not zero; pixel is not transparent.
                    if (x < lowX) { lowX = x };
                    if (x > highX) { highX = x };
                    if (y < lowY) { lowY = y};
                    if (y > highY) { highY = y};
                }
            }
        }
        free(data)
        return CGRect(x: lowX, y: lowY, width: highX-lowX, height: highY-lowY)
    }
    
    func trimToNontransparent() -> UIImage? {
        let newRect = self.BoundingBoxOfNontransparentPixels()
        guard !CGRectIsEmpty(newRect) else {
            return nil
        }
        guard let imageRef = CGImageCreateWithImageInRect(self.CGImage!, newRect) else{
            return nil
        }
        return UIImage(CGImage: imageRef)
    }
    
    
    func createARGBBitmapContext() -> CGContext? {
        let image = self.CGImage
        return image?.createARGBBitmapContext()
    }
}

