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
    
    @IBAction private func moveJointsWithPanRecognizer(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            let p = recognizer.locationInView(skeletonView)
            print(p)
            if let view = view.hitTest(p, withEvent: nil) where view != skeletonView {
                movedView = view
                print(movedView)
            }
        case .Changed:
            if let view = movedView {
                let p = recognizer.locationInView(skeletonView)
                let origin = p - CGPoint(x: SkeletonView.Constants.JointSize / 2, y: SkeletonView.Constants.JointSize / 2)
                view.frame = CGRect(origin: origin, size: view.frame.size)
                
                skeletonView.setNeedsDisplay()
            }
        case .Ended:
            updateImage()
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
        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            let (pixels, context) = image.toARGBBitmapData()
            let width = CGImageGetWidth(image)
            let height = CGImageGetHeight(image)
            
            
            
            for y in 0..<height {
                for x in 0..<width {
                    let p = self.characterImageView.convertPoint(CGPoint(x:x,y:y), toView: self.skeletonView)
                    let pixel = pixels[width * y + x]
                    if dot(p-neckPoint,neckPoint - waistPoint) > 0 {
                        // head
                        if pixel.alphaValue != 0 {
                            pixels[width * y + x] = 0x00FF00FF // green
                        }
                    } else if dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) > 0 {
//                        switch p {
//                        case _ where dot(p-leftAnklePoint, leftAnklePoint - leftKneePoint) > 0:
//                            // left foot
//                            if pixel.alphaValue != 0 {
//                                pixels[width * y + x] = 0x00FFFFFF //yellow
//                            }
//                        case _ where  dot(p-leftElbowPoint,leftElbowPoint - leftShoulderPoint) > 0 &&
//                            dot(p-leftShoulderPoint, (leftWristPoint - leftElbowPoint).perpendicular) < 0 :
//                            //left forarm
//                            if pixel.alphaValue != 0 {
//                                pixels[width * y + x] = 0x0000FFFF // red
//                            }
//                            
//                        case _ where dot(p-leftKneePoint, leftAnklePoint - leftKneePoint) > 0:
//                            // left shank
//                            if pixel.alphaValue != 0 {
//                                pixels[width * y + x] = 0xFFFF00FF //cyan
//                            }
//                        case _ where dot(p-leftHipPoint,  leftKneePoint - leftHipPoint) > 0:
//                            //right thigh
//                            if pixel.alphaValue != 0 {
//                                pixels[width * y + x] = 0xFF00FFFF //magenta
//                            }
//                            
//                            
//                        case _ where dot(p-leftShoulderPoint, leftShoulderPoint - bodyPoint) > 0:
//                            //left upper arm
//                            if pixel.alphaValue != 0 {
//                                pixels[width * y + x] = 0xFF0000FF // blue
//                            }
//                        default:
//                            break
//                        }
                    } else {
                        switch p {
                        case _ where dot(p-rightAnklePoint, rightAnklePoint - rightKneePoint) > 0:
                            // right foot
                            if pixel.alphaValue != 0 {
                                pixels[width * y + x] = 0x00FFFFFF //yellow
                            }
                        case _ where  dot(p-rightElbowPoint,rightElbowPoint - rightShoulderPoint) > 0 &&
                            dot(p-rightShoulderPoint, (rightWristPoint - rightElbowPoint).perpendicular) > 0 :
                            //right forarm
                            if pixel.alphaValue != 0 {
                                pixels[width * y + x] = 0x0000FFFF // red
                            }
                            
                        case _ where dot(p-rightKneePoint, rightAnklePoint - rightKneePoint) > 0:
                            // right shank
                            if pixel.alphaValue != 0 {
                                pixels[width * y + x] = 0xFFFF00FF //cyan
                            }
                        case _ where dot(p-rightHipPoint,  rightKneePoint - rightHipPoint) > 0:
                            //right thigh
                            if pixel.alphaValue != 0 {
                                pixels[width * y + x] = 0xFF00FFFF //magenta
                            }
                            
                            
                        case _ where dot(p-rightShoulderPoint, rightShoulderPoint - bodyPoint) > 0:
                            //right upper arm
                            if pixel.alphaValue != 0 {
                                pixels[width * y + x] = 0xFF0000FF // blue
                            }
                        default:
                            break
                        }
                    }
                }
            }
            let alteredImage = CGBitmapContextCreateImage(context)!
            free(pixels)
            dispatch_async(dispatch_get_main_queue(), {
                self.characterImageView.image = UIImage(CGImage: alteredImage)
            })

        }
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let characterImage = characterSkin {
            print(characterImage.size)
            characterImageView.image = characterImage
        } else {
            characterSkin = characterImageView.image
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


