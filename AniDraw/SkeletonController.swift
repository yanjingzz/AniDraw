//
//  SkeletonViewController.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

class SkeletonController: UIViewController {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet private weak var skeletonView: SkeletonView!
    
    @IBAction private func goBack(sender: UIButton) {
        dismissViewControllerAnimated(true) { }
    }
    
    private var movedView : UIView?
    private var moved = false
    
    @IBAction private func moveJointsWithPanRecognizer(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            
            let p = recognizer.locationInView(skeletonView)
            if let view = view.hitTest(p, withEvent: nil) where view != skeletonView {
                moved = true
                movedView = view
            }
        case .Changed:
            
            if let view = movedView {
                moved = true
                let p = recognizer.locationInView(skeletonView)
                let origin = p - CGPoint(x: SkeletonView.Constants.JointSize / 2, y: SkeletonView.Constants.JointSize / 2)
                view.frame = CGRect(origin: origin, size: view.frame.size)
                
                skeletonView.setNeedsDisplay()
            }
        case .Ended:
            if movedView != nil {
//                updateImage()
            }
            fallthrough
        default:
            movedView = nil
        }
    }

    func jointPoint(joint: JointName) -> CGPoint {
        return skeletonView.joints[joint]!.frame.center
    }
    
    
    var characterSkin: UIImage!
    
    
    
    func updateImage() {
        let image = characterSkin.CGImage!
        let inBodyPart = belongsToBodyPart()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            self.moved = false
            let (pixels, context) = image.toARGBBitmapData()
            var data = [BodyPartName: (pixel: UnsafeMutablePointer<UInt32>, context: CGContext?)]()
            for joint in BodyPartName.allParts {
                let c = image.createARGBBitmapContext()
                let p = UnsafeMutablePointer<UInt32>(CGBitmapContextGetData(c))
                data[joint] = (pixel: p,context: c)
            }
            let width = CGImageGetWidth(image)
            let height = CGImageGetHeight(image)
            
            
            
            for y in 0..<height {
                for x in 0..<width {
                    if self.moved {
                        return
                    }
                    let p = self.characterImageView.convertPoint(CGPoint(x:x,y:y), toView: self.skeletonView)
                    let pixel = pixels[width * y + x]
                    for part in BodyPartName.allParts {
                        if inBodyPart[part]!(p) && pixel.alphaValue != 0 && pixel.alphaValue != 0xFF {
                            pixels[width * y + x] = self.colorForPart[part]!
                        }
                    }
                    
                }
            }
            let alteredImage = CGBitmapContextCreateImage(context)!
            free(pixels)
            dispatch_async(dispatch_get_main_queue(), {
                if self.moved {
                    return
                }
                self.characterImageView.image = UIImage(CGImage: alteredImage)
            })

        }
        
    }
    
    func segmentParts() -> [BodyPartName: CGImage] {
        let image = characterSkin.CGImage!
        var ret = [BodyPartName: CGImage]()
        let inBodyPart = belongsToBodyPart()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            self.moved = false
            let (pixels, _) = image.toARGBBitmapData()
            var data = [BodyPartName: (pixel: UnsafeMutablePointer<UInt32>, context: CGContext?)]()
            for joint in BodyPartName.allParts {
                let c = image.createARGBBitmapContext()
                let p = UnsafeMutablePointer<UInt32>(CGBitmapContextGetData(c))
                data[joint] = (pixel: p,context: c)
            }
            let width = CGImageGetWidth(image)
            let height = CGImageGetHeight(image)
            
            for y in 0..<height {
                for x in 0..<width {
                    if self.moved == true {
                        return
                    }
                    let p = self.characterImageView.convertPoint(CGPoint(x:x,y:y), toView: self.skeletonView)
                    let pixel = pixels[width * y + x]
                    for part in BodyPartName.allParts {
                        if inBodyPart[part]!(p) {
                            data[part]?.pixel[width * y + x] = pixel
                        }
                    }
                    
                }
            }
            free(pixels)
            for part in BodyPartName.allParts {
                ret[part] = CGBitmapContextCreateImage(data[part]?.context)
            }

            
        }

        return ret
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let characterImage = characterSkin {
            characterImageView.image = characterImage
        } else {
            characterSkin = characterImageView.image?.trimToNontransparent()
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("prepare for segue")
        print(segue.identifier)
    }
    
    
    func belongsToBodyPart() -> [BodyPartName: (CGPoint) -> Bool] {
        let neckPoint = jointPoint(.Neck)
        let waistPoint = jointPoint(.Waist)
        let bodyPoint = (neckPoint+waistPoint)/2
        
        let leftElbowPoint = jointPoint(.LeftElbow)
        let leftShoulderPoint = jointPoint(.LeftShoulder)
        let leftWristPoint = jointPoint(.LeftWrist)
        let leftHipPoint = jointPoint(.LeftHip)
        let leftKneePoint = jointPoint(.LeftKnee)
        let leftAnklePoint = jointPoint(.LeftAnkle)
        
        let rightElbowPoint = jointPoint(.RightElbow)
        let rightShoulderPoint = jointPoint(.RightShoulder)
        let rightWristPoint = jointPoint(.RightWrist)
        let rightHipPoint = jointPoint(.RightHip)
        let rightKneePoint = jointPoint(.RightKnee)
        let rightAnklePoint = jointPoint(.RightAnkle)
        
        let headClosure:  (CGPoint) -> Bool = {
            return dot($0-neckPoint,neckPoint - waistPoint) > 0
        }
        let leftFootClosure:(CGPoint) -> Bool = { p in
            guard dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) > 0 else {
                return false
            }
            return dot(p-leftAnklePoint, leftAnklePoint - leftKneePoint) > 0
            
        }
        let leftForearmClosure:(CGPoint) -> Bool = { p in
            guard dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) > 0 else {
                return false
            }
            return dot(p-leftElbowPoint,leftElbowPoint - leftShoulderPoint) > 0 &&
                dot(p-leftShoulderPoint, (leftWristPoint - leftElbowPoint).perpendicular) < 0
            
        }
        let leftShankClosure:(CGPoint) -> Bool = { p in
            guard dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) > 0 else {
                return false
            }
            return dot(p-leftKneePoint, leftAnklePoint - leftKneePoint) > 0 &&
                dot(p-leftAnklePoint, leftAnklePoint - leftKneePoint) <= 0
        }
        let leftThighClosure:(CGPoint) -> Bool = { p in
            guard dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) > 0  && !leftForearmClosure(p) else {
                return false
            }
            return dot(p-leftHipPoint,  leftKneePoint - leftHipPoint) > 0 &&
                dot(p-leftKneePoint, leftAnklePoint - leftKneePoint) <= 0
        }
        let leftUpperArmClosure:(CGPoint) -> Bool = { p in
            guard dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) > 0 &&
                !headClosure(p) else {
                    return false
            }
            return dot(p-leftShoulderPoint, leftShoulderPoint - bodyPoint) > 0 &&
                dot(p-leftElbowPoint,leftElbowPoint - leftShoulderPoint) <= 0
        }
        
        let rightFootClosure:(CGPoint) -> Bool = { p in
            guard dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) <= 0 else {
                return false
            }
            return dot(p-rightAnklePoint, rightAnklePoint - rightKneePoint) > 0
            
        }
        let rightForearmClosure:(CGPoint) -> Bool = { p in
            guard dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) <= 0 else {
                return false
            }
            return dot(p-rightElbowPoint,rightElbowPoint - rightShoulderPoint) > 0 &&
                dot(p-rightShoulderPoint, (rightWristPoint - rightElbowPoint).perpendicular) >= 0
            
        }
        let rightShankClosure:(CGPoint) -> Bool = { p in
            guard dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) <= 0 else {
                return false
            }
            return dot(p-rightKneePoint, rightAnklePoint - rightKneePoint) > 0 &&
                dot(p-rightAnklePoint, rightAnklePoint - rightKneePoint) <= 0
        }
        let rightThighClosure:(CGPoint) -> Bool = { p in
            guard dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) <= 0   && !rightForearmClosure(p) else {
                return false
            }
            return dot(p-rightHipPoint,  rightKneePoint - rightHipPoint) > 0 &&
                dot(p-rightKneePoint, rightAnklePoint - rightKneePoint) <= 0
        }
        let rightUpperArmClosure:(CGPoint) -> Bool = { p in
            guard dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) <= 0 &&
                !headClosure(p) else {
                    return false
            }
            return dot(p-rightShoulderPoint, rightShoulderPoint - bodyPoint) > 0 &&
                dot(p-rightElbowPoint,rightElbowPoint - rightShoulderPoint) <= 0
        }
        let upperBodyClosure:(CGPoint) -> Bool = { p in
            guard !headClosure(p) && !leftForearmClosure(p) && !leftUpperArmClosure(p) && !leftThighClosure(p) && !leftFootClosure(p) && !leftShankClosure(p) && !rightForearmClosure(p) && !rightUpperArmClosure(p) && !rightThighClosure(p) && !rightFootClosure(p) && !rightShankClosure(p)
                else {
                    return false
            }
            return dot(p-waistPoint,neckPoint - waistPoint) > 0
            
        }
        let lowerBodyClosure: (CGPoint) -> Bool = { p in
            guard !headClosure(p) && !leftForearmClosure(p) && !leftUpperArmClosure(p) && !leftThighClosure(p) && !leftFootClosure(p) && !leftShankClosure(p) && !rightForearmClosure(p) && !rightUpperArmClosure(p) && !rightThighClosure(p) && !rightFootClosure(p) && !rightShankClosure(p)
                else {
                    return false
            }
            return dot(p-waistPoint,neckPoint - waistPoint) <= 0
            
        }
        
        let ret: [BodyPartName: (CGPoint) -> Bool] = [
            .Head: headClosure,
            .UpperBody: upperBodyClosure,
            .LowerBody: lowerBodyClosure,
            .LeftFoot: leftFootClosure,
            .LeftForearm: leftForearmClosure,
            .LeftShank: leftShankClosure,
            .LeftThigh: leftThighClosure,
            .LeftUpperArm: leftUpperArmClosure,
            .RightFoot: rightFootClosure,
            .RightForearm: rightForearmClosure,
            .RightShank: rightShankClosure,
            .RightThigh: rightThighClosure,
            .RightUpperArm: rightUpperArmClosure
            
        ]
        return ret
        
    }
    
    let colorForPart: [BodyPartName: UInt32] = [
        .Head:          0xFFFF00FF,
        .UpperBody:     0xFF7F00FF,
        .LowerBody:     0xFF0000FF,
        
        .LeftFoot:      0x0000FFFF,
        .LeftShank:     0x7F00FFFF,
        .LeftThigh:     0xFF00FFFF,
        .LeftForearm:   0x00FF00FF,
        .LeftUpperArm:  0x00FF7FFF,

        
        .RightFoot:      0x0000FFFF,
        .RightShank:     0x7F00FFFF,
        .RightThigh:     0xFF00FFFF,
        .RightForearm:   0x00FF00FF,
        .RightUpperArm:  0x00FF7FFF,
    ]


}


