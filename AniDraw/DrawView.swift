//
//  DrawView.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

class DrawView: UIView{

    var tool: DrawingTool = .Pencil
    var color: UIColor = UIColor.blackColor()
    
    private var path: UIBezierPath?
    private var points = [PointWithWidth]()
    private var incrementalImage: UIImage?
    var initialImage: UIImage?
    
    var croppedImage: UIImage? {
        get {
            return incrementalImage?.trimToNontransparent()
        }
    }
    
    private struct Constants {
        static let PointsDistanceThreshold: CGFloat = 0.5
        static let bezierArcConstant: CGFloat = (2/3)*CGFloat(tan(M_PI_4))
    }
    
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
    
    // MARK: Private definitions
    
    private let drawingQueue = dispatch_queue_create("drawingQueue", DISPATCH_QUEUE_SERIAL)
    
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
    private var pointWidth: CGFloat {
        switch tool {
        case .Pencil:
            return 2.0
        case .Pen:
            return 2.0
        case .Eraser:
            return 10
        case .Crayon:
            return 7.0
        default:
            return 0

        }
    }

    
    // MARK: - drawing
    
    override func drawRect(rect: CGRect) {
        incrementalImage?.drawInRect(rect)
        drawPath()
    }
    func drawPath() {
        switch tool {
        case .Eraser:
            path?.fillWithBlendMode(CGBlendMode.Clear, alpha: 1)
        case .Brush:
            color.setFill()
            path?.fillWithBlendMode(CGBlendMode.Multiply, alpha: 0.8)
        case .Crayon:
            color.setFill()
            path?.fillWithBlendMode(CGBlendMode.Darken, alpha: 1)
        default:
            color.setFill()
            path?.fill()
            
        }

    }
    
    @IBAction private func drawDotforTapRecognizer(recognizer: UITapGestureRecognizer) {
        let p = recognizer.locationInView(self)
        let width:CGFloat = pointWidth
        let current = PointWithWidth(point: p, width: width)
        path = current.path
        finishStroke()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //employed to remedy the pan recognizer delay
        guard touches.count == 1 else {
            return
        }
        let touch = touches.first!
        let current = PointWithWidth(point: touch.locationInView(self), width: pointWidth)
        if !points.isEmpty {
            points.removeAll()
        }
        points.append(current)
        path = current.path
    }
    
    
    @IBAction private func drawStrokeForPanRecognizer(recognizer: UIPanGestureRecognizer) {
        let p = recognizer.locationInView(self)
        let v = recognizer.velocityInView(self)
        let width = strokeWidthFromSpeed(v.length())
        let current = PointWithWidth(point: p, width: width)
        if points.isEmpty
            || (points.last!.point - p).length() > Constants.PointsDistanceThreshold {
            
            points.append(current)
        }
        switch tool {
        case .Brush:
            path = connectPointsToFill()
        default:
            path = connectPointsToStroke()
        }
        
        setNeedsDisplay()
        if recognizer.state == .Ended || recognizer.state == .Cancelled {
            finishStroke()
        }
    }
    
    func connectPointsToFill() -> UIBezierPath {
        guard points.count >= 3 else {
            print("drawView pan gesture recognizer points[] empty!")
            return UIBezierPath()
        }
        let path = UIBezierPath()
        let firstMidPoint = (points[0].point + points[1].point) / 2
        path.moveToPoint(points[0].point)
        path.addLineToPoint(firstMidPoint)
        for i in 1 ..< points.count - 1 {
            let midPoint = (points[i].point + points[i+1].point) / 2
            path.addQuadCurveToPoint(midPoint, controlPoint: points[i].point)
        }
        path.addLineToPoint(points.last!.point)
        path.closePath()
        return path
        
        
    }

    func connectPointsToStroke() -> UIBezierPath {
        guard let current = points.last else {
            print("drawView pan gesture recognizer points[] empty!")
            return UIBezierPath()
        }
        
        switch points {
        case _ where points.count == 1:
            return current.path
            
        case _ where points.count == 2:
            let path = UIBezierPath()
            let prev = points[0]
            let middlePoint = PointWithWidth.average(current, prev)
            let dir = current.point - prev.point
            let prevEndPoints = endPoints(at: prev, perpTo: dir)
            let currentEndPoints = endPoints(at: middlePoint, perpTo: dir)
            
            path.moveToPoint(prevEndPoints.1)
            path.addLineToPoint(currentEndPoints.1)
            
            let off0 = dir.normalized() * prev.width * Constants.bezierArcConstant
            path.addCurveToPoint(currentEndPoints.0, controlPoint1: currentEndPoints.1 + off0, controlPoint2: prevEndPoints.0 + off0)
            path.addLineToPoint(prevEndPoints.0)
            let off1 = dir.normalized() * current.width * Constants.bezierArcConstant
            path.addCurveToPoint(prevEndPoints.1, controlPoint1: prevEndPoints.0 - off1, controlPoint2: prevEndPoints.1 - off1)
            path.closePath()
            return path
            
        default:
            let path = UIBezierPath()
            
            do { // first cap
                let first = points[0]
                let second = points[1]
                let mid = PointWithWidth.average(first, second)
                let firstEnds = endPoints(at: first, perpTo: mid.point - first.point)
                let midEnds = endPoints(at: mid, perpTo: second.point - first.point)
                path.moveToPoint(midEnds.1)
                path.addLineToPoint(firstEnds.1)
                
                let off0 = (mid.point - first.point).normalized() * first.width * Constants.bezierArcConstant
                path.addCurveToPoint(firstEnds.0, controlPoint1: firstEnds.1 - off0, controlPoint2: firstEnds.0 - off0)
                path.addLineToPoint(firstEnds.0)
            }
            //first half
            for i in 0 ..< points.count - 2 {
                let first = points[i]
                let second = points[i+1]
                let third = points[i+2]
                let mid2 = PointWithWidth.average(second, third)
                let m2Ends = endPoints(at: mid2, perpTo: third.point - second.point)
                let controlEndPoints = endPoints(at: second, perpTo: third.point - first.point)
                path.addQuadCurveToPoint(m2Ends.0, controlPoint: controlEndPoints.0)
            }
            do { // second cap
                let first = points[points.count-2]
                let second = points[points.count-1]
                let mid = PointWithWidth.average(first, second)
                let secondEnds = endPoints(at: second, perpTo: second.point - mid.point)
                let midEnds = endPoints(at: mid, perpTo: second.point - first.point)
                path.moveToPoint(midEnds.0)
                path.addLineToPoint(secondEnds.0)
                
                let off0 = (second.point - mid.point).normalized() * first.width * Constants.bezierArcConstant
                path.addCurveToPoint(secondEnds.1, controlPoint1: secondEnds.0 + off0, controlPoint2: secondEnds.1 + off0)
                path.addLineToPoint(midEnds.1)
            }
            
            //second half
            for j in 0 ..< points.count - 2 {
                let i = points.count - 3 - j
                let first = points[i]
                let second = points[i+1]
                let third = points[i+2]
                let mid1 = PointWithWidth.average(first, second)
                let m1Ends = endPoints(at: mid1, perpTo: second.point - first.point)
                let controlEndPoints = endPoints(at: second, perpTo: third.point - first.point)
                path.addQuadCurveToPoint(m1Ends.1, controlPoint: controlEndPoints.1)
            }
            path.closePath()
            return path
        }

    }
    private func endPoints(at pw: PointWithWidth, perpTo direction: CGPoint)  -> (CGPoint, CGPoint) {
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
        case .Brush:
            return (speed / 1000).clamped(20.0, 30.0)
        default:
            return (speed / 1000).clamped(7.0, 10.0)
        }
    }
    
    private func finishStroke() {
//        print("finished")
        drawBitmap()
        points.removeAll()
        path = nil
        setNeedsDisplay()
    }
    
    private func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        incrementalImage?.drawAtPoint(CGPoint.zero)
        drawPath()
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        //undo and redo
        
        if undoImages.count >= 21 {
            undoImages.removeFirst()
        }
        if undoImages.count == 0 {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
            undoImages.push(UIGraphicsGetImageFromCurrentImageContext())
            UIGraphicsEndImageContext()
        }
        
        undoImages.push(incrementalImage!)
        redoImages.removeAll()
        
    }
    
    //MARK: - Undo & redo
    
    var undoImages : [UIImage] = []
    var redoImages : [UIImage] = []
    
    func undo() -> Bool{
        guard undoImages.count > 1 else{
            return false
        }
        let temporaryImage = undoImages.pop()
        redoImages.push(temporaryImage!)
        incrementalImage = undoImages.get(undoImages.endIndex-1)
        setNeedsDisplay()
        return true
        
        
    }
    
    func redo() -> Bool {
        guard !redoImages.isEmpty else {
            return false
        }
        incrementalImage = redoImages.get(redoImages.endIndex-1)
        let temporaryImage = redoImages.pop()
        undoImages.push(temporaryImage!)
        setNeedsDisplay()
        return true
    }
    
    
    
}

