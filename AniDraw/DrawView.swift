//
//  DrawView.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

class DrawView: UIView {

    @IBInspectable var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() } }
    @IBInspectable var strokeColor: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    private var path = UIBezierPath()
    private var incrementalImage: UIImage?
    var image: UIImage? {
        get {
            return incrementalImage
        }
    }
    private var pts = [CGPoint](count:5, repeatedValue: CGPoint(x: 0, y: 0))
    private var counter = 0
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        multipleTouchEnabled = false
//        backgroundColor = UIColor.whiteColor()
        path.lineWidth = lineWidth

    }
    
    // MARK: - drawing
    
    override func drawRect(rect: CGRect) {
        incrementalImage?.drawInRect(rect)
        path.stroke()
    }
    
    
    @IBAction private func drawStrokeForPanRecognizer(recognizer: UIPanGestureRecognizer) {
        let p = recognizer.locationInView(self)
//        let v = recognizer.velocityInView(self)
//        let width = strokeWidthFromSpeed(v.length())
    
        switch recognizer.state {
        case .Began:
            counter = 0
            pts[counter] = p
            
        case .Changed:
            counter += 1
            pts[counter] = p
            if counter == 4 {
                // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
                pts[3] = (pts[2] + pts[4])/2.0
                path.moveToPoint(pts[0])
                path.addCurveToPoint(pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
                
                setNeedsDisplay()
                pts[0] = pts[3]
                pts[1] = pts[4]
                counter = 1
            }

        case .Ended: fallthrough
        case .Cancelled:
            finishStroke()
        case .Failed:
            break
        default:
            break
        }
    }
    
    func strokeWidthFromSpeed(speed: CGFloat) -> CGFloat {
        return log(speed).clamped(1.0, 10.0)
    }
    
    func finishStroke() {
        drawBitmap()
        setNeedsDisplay()
        path.removeAllPoints()
        counter = 0
    }
    
    func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)

        incrementalImage?.drawAtPoint(CGPoint.zero)
        
        
        strokeColor.setStroke()
        path.stroke()
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
    }
 

}
