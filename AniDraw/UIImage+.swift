//
//  UIImage+.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

public extension UIImage {
    
    func trimToNontransparent() -> CGRect {
        let imageAsCGImage = self.CGImage
        guard let context:CGContextRef = self.createARGBBitmapContext() else {
            return CGRectZero
        }
        let width = Int(CGImageGetWidth(imageAsCGImage))
        let height = Int(CGImageGetHeight(imageAsCGImage))
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
        CGContextDrawImage(context, rect, imageAsCGImage)
        
        var lowX:Int = width
        var lowY:Int = height
        var highX:Int = 0
        var highY:Int = 0
        let data:UnsafeMutablePointer<Void>? = CGBitmapContextGetData(context)
        if let data = data {
            var dataType:UnsafeMutablePointer<UInt8>? = UnsafeMutablePointer<UInt8>(data)
            if var dataType = dataType {
                for y in 0..<height {
                    for x in 0..<width {
                        var pixelIndex:Int = (width * y + x) * 4 /* 4 for A, R, G, B */;
                        if (dataType[pixelIndex] != 0) { //Alpha value is not zero; pixel is not transparent.
                            if (x < lowX) { lowX = x };
                            if (x > highX) { highX = x };
                            if (y < lowY) { lowY = y};
                            if (y > highY) { highY = y};
                        }
                    }
                }
            }
            free(data)
        } else {
            return CGRectZero
        }
        return CGRect(x: CGFloat(lowX), y: CGFloat(lowY), width: CGFloat(highX-lowX), height: CGFloat(highY-lowY))
            
        
        
        
    }
    
    
    func createARGBBitmapContext() -> CGContext? {
        let image = self.CGImage
        var bitmapByteCount = 0
        var bitmapBytesPerRow = 0
        
        //Get image width, height
        let pixelsWide = CGImageGetWidth(image)
        let pixelsHigh = CGImageGetHeight(image)
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        bitmapBytesPerRow = Int(pixelsWide) * 4
        bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(Int(bitmapByteCount))
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue)
        
        return context
    }
}