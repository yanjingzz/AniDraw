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
        
        var lowX:Int = width
        var lowY:Int = height
        var highX:Int = 0
        var highY:Int = 0
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
        return CGRect(x: CGFloat(lowX), y: CGFloat(lowY), width: CGFloat(highX-lowX), height: CGFloat(highY-lowY))
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

extension CGImage {
    
    func createARGBBitmapContext() -> CGContext? {
        var bitmapByteCount = 0
        var bitmapBytesPerRow = 0
        
        //Get image width, height
        let pixelsWide = CGImageGetWidth(self)
        let pixelsHigh = CGImageGetHeight(self)
        
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
    
    func toARGBBitmapData() -> (UnsafeMutablePointer<UInt32>, CGContext?) {
        
        //Get image width, height
        let pixelsWide = CGImageGetWidth(self)
        let pixelsHigh = CGImageGetHeight(self)
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        let bitmapBytesPerRow = pixelsWide * 4
        let bitmapByteCount = bitmapBytesPerRow * pixelsHigh
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue)
        let rect:CGRect = CGRect(x: 0, y: 0, width: pixelsWide, height: pixelsHigh)
        CGContextDrawImage(context, rect, self)
        
        return (UnsafeMutablePointer<UInt32>(bitmapData), context)
    }

}