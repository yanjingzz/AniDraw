//
//  CGImage+.swift
//  AniDraw
//
//  Created by Mike on 6/30/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
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
    
    func rotateImageBy (anglesInRadians angle: CGFloat, at origin: CGPoint) -> CGImage? {
        let context = createARGBBitmapContext()
        let imageRect = CGRect(origin: origin, size: CGSize(width: CGImageGetWidth(self), height: CGImageGetHeight(self)))
        CGContextTranslateCTM(context, imageRect.origin.x, imageRect.origin.y)
        CGContextRotateCTM(context, angle)
        CGContextTranslateCTM(context, imageRect.size.width * -0.5, imageRect.size.height * -0.5)
        CGContextDrawImage(context, CGRect(origin: CGPointZero, size: imageRect.size), self)
        return CGBitmapContextCreateImage(context)
    }
    
}