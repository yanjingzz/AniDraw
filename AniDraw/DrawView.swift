//
//  DrawView.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var tool: DrawingTool?
    var color: UIColor = UIColor.blackColor()
    private struct PointWithWidth {
        var point: CGPoint
        var width: CGFloat
        static func average (p0: PointWithWidth,_ p1: PointWithWidth) -> PointWithWidth {
            let p = (p0.point + p1.point) / 2
            let w = (p0.width + p1.width) / 2
            return PointWithWidth(point: p, width: w)
        }
        var path: UIBezierPath {
            let rect1 = CGRect(origin: point - CGPoint(x: width/2,  y:width/2), size: CGSize(width: width, height:width))
            
            return UIBezierPath(ovalInRect: rect1)
        }
    }
    @IBInspectable var strokeColor: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    private var paths = [UIBezierPath]()
    private var incrementalImage: UIImage?
    var initialImage: UIImage?
    
    override func layoutSubviews() {
        if let image = initialImage where incrementalImage == nil {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
            let center = bounds.center
            let origin = center - CGPoint(x: image.size.width / 2, y: image.size.height / 2)
            image.drawAtPoint(origin)
            incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
        }
    }
    private let drawingQueue = dispatch_queue_create("drawingQueue", DISPATCH_QUEUE_SERIAL)
    
    private enum State {
        case FirstPoint (prev: PointWithWidth)
        case SecondAndUp (first: PointWithWidth,second: PointWithWidth)
        case ThirdAndUp (first: PointWithWidth,second: PointWithWidth)
    }
    private var state: State?
    
    
    var image: UIImage? {
        get {
            return incrementalImage?.trimToNontransparent()
        }
    }
    
    // MARK: - drawing
    
    override func drawRect(rect: CGRect) {
        incrementalImage?.drawInRect(rect)
        for path in paths {
            if tool == .Some(.Eraser) {
                UIColor.whiteColor().setFill()
                UIColor.whiteColor().setStroke()
                path.fill()
                path.stroke()
            } else {
                color.setFill()
                color.setStroke()
                path.fill()
                path.stroke()
            }
        }
    }
    
    private struct Constants {
        
    }
    @IBAction private func drawDotforTapRecognizer(recognizer: UITapGestureRecognizer) {
        let p = recognizer.locationInView(self)
        let width:CGFloat = 5.0
        let current = PointWithWidth(point: p, width: width)
        paths.append(current.path)
        finishStroke()
    }
    
    
    
    @IBAction private func drawStrokeForPanRecognizer(recognizer: UIPanGestureRecognizer) {
        let p = recognizer.locationInView(self)
        let v = recognizer.velocityInView(self)
        let width = strokeWidthFromSpeed(v.length())
        let current = PointWithWidth(point: p, width: width)
    
        switch recognizer.state {
        case .Began:
            paths.append(current.path)
            state = State.FirstPoint(prev: current)
            
        case .Changed:
            guard let s = state else {
                break
            }
            switch s {
            case .FirstPoint(prev: let prev):
                let middlePoint = PointWithWidth.average(current, prev)
                let dir = p - prev.point
                let prevEndPoints = endPoints(atPositionWithWidth: prev, perpendicularTo: dir)
                let currentEndPoints = endPoints(atPositionWithWidth: middlePoint, perpendicularTo: dir)
                let path = UIBezierPath()
                path.moveToPoint(prevEndPoints.0)
                path.addLineToPoint(prevEndPoints.1)
                path.addLineToPoint(currentEndPoints.1)
                path.addLineToPoint(currentEndPoints.0)
                path.addLineToPoint(prevEndPoints.0)
                paths.append(path)
                state = State.SecondAndUp(first: prev, second: current)
                
            case .SecondAndUp(first: let first, second: _):
                state = State.ThirdAndUp(first: first,second: current)
            case .ThirdAndUp(first: let first, second: let second):
                let middlePoint1 = PointWithWidth.average(first, second)
                let middlePoint2 = PointWithWidth.average(second, current)
                let m1EndPoints = endPoints(atPositionWithWidth: middlePoint1, perpendicularTo: second.point - first.point)
                let m2EndPoints = endPoints(atPositionWithWidth: middlePoint2, perpendicularTo: current.point - second.point)
                let controlEndPoints = endPoints(atPositionWithWidth: second, perpendicularTo: current.point - first.point)
                let path = UIBezierPath()
                path.moveToPoint(m1EndPoints.0)
                path.addLineToPoint(m1EndPoints.1)
                path.addQuadCurveToPoint(m2EndPoints.1, controlPoint: controlEndPoints.1)
                path.addLineToPoint(m2EndPoints.0)
                path.addQuadCurveToPoint(m1EndPoints.0, controlPoint: controlEndPoints.0)
                path.closePath()
                if second.point == current.point {
                    //TODO: deal with second == current
                }
                paths.append(path)
                state = State.ThirdAndUp(first: second,second: current)
            }
            setNeedsDisplay()

        case .Ended:
            guard let s = state else {
                break
            }
            let prev: PointWithWidth
            switch s {
            case .FirstPoint(prev: let pp):
                
                prev = PointWithWidth.average(pp, current)
            case .SecondAndUp(first: let first, second: _):
                prev = PointWithWidth.average(first, current)
            case .ThirdAndUp(first: let first, second:  _):
                prev = PointWithWidth.average(first, current)
                
            }
            let dir = p - prev.point
            let prevEndPoints = endPoints(atPositionWithWidth: prev, perpendicularTo: dir)
            let currentEndPoints = endPoints(atPositionWithWidth: current, perpendicularTo: dir)
            let path = UIBezierPath()
            path.moveToPoint(prevEndPoints.0)
            path.addLineToPoint(prevEndPoints.1)
            path.addLineToPoint(currentEndPoints.1)
            path.addLineToPoint(currentEndPoints.0)
            path.addLineToPoint(prevEndPoints.0)
            paths.append(path)
            paths.append(current.path)
            fallthrough
        case .Cancelled:
            finishStroke()
        case .Failed:
            break
        default:
            break
        }
    }


    private func endPoints(atPositionWithWidth pw: PointWithWidth, perpendicularTo direction: CGPoint)  -> (CGPoint, CGPoint) {
        let p = pw.point
        let width = pw.width
        let d = direction.normalized() / 2
        let a = CGPoint(x: p.x - d.y * width, y: p.y + d.x * width)
        let b = CGPoint(x: p.x + d.y * width, y: p.y - d.x * width)
        return (a, b)
    }
    
    func strokeWidthFromSpeed(speed: CGFloat) -> CGFloat {
        let t = tool ?? .Pencil
        switch t {
        case .Pencil:
            return (speed / 500).clamped(1.0, 10.0)
        case .Pen:
            return (100 / speed).clamped(1.0, 3.0)
        case .Eraser:
            return (speed / 50).clamped(10.0, 100.0)
        default:
            return (speed / 1000).clamped(7.0, 10.0)
        }
    }
    
    func finishStroke() {
        drawBitmap()
        setNeedsDisplay()
        paths.removeAll()
        state = nil
    }
    
    func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        incrementalImage?.drawAtPoint(CGPoint.zero)
        
        for path in paths {
            
            if tool == .Some(.Eraser) {
                
                path.fillWithBlendMode(CGBlendMode.Clear, alpha: 1.0)
                path.strokeWithBlendMode(CGBlendMode.Clear, alpha: 1.0)
            } else {
                color.setFill()
                color.setStroke()
                path.fill()
                path.stroke()
            }
        }
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
    }
 

}
