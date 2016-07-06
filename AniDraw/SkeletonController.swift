//
//  SkeletonViewController.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
import CoreData
import JGProgressHUD

class SkeletonController: UIViewController {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet private weak var skeletonView: SkeletonView!
    
    @IBAction private func goBack(sender: UIButton) {
        dismissViewControllerAnimated(true) { }
    }
    
    var editingCharacter: CharacterStorage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let characterImage = characterSkin {
            characterImageView.image = characterImage
        } else {
            characterSkin = characterImageView.image?.trimToNontransparent()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateImage()
    }
    
    // MARK: - Move Points
    
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
                updateImage()
            }
            fallthrough
        default:
            movedView = nil
        }
    }
    
    // MARK: - Navigation
    
    private struct Storyboard {
        static let DoneAddingCharacterIdentifier = "doneAddingCharacter"
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier where identifier == Storyboard.DoneAddingCharacterIdentifier {
        }
    }
    
    // MARK: - Add Character
    var characterName: String?
    var segmentationDone = false
    let HUD = JGProgressHUD(style: .Light)
    
    //TODO: clean up logic saving character
    
    @IBAction private func doneAddingCharacter() {
        if editingCharacter == nil {
            self.presentViewController(alertForNamePrompt, animated: true) {}
        } else {
            HUD.textLabel.text = "Saving"
            HUD.showInView(self.view)
        }
        segmentParts(){
            self.segmentationDone = true
            self.saveCharacter()
        }
        
    }
    
    func saveCharacter() {
        guard segmentationDone == true else  {
            return
        }
        let node = CharacterNode(bodyPartImages: segmentedParts,imagesFrame: segmentedPartsFrame, jointsPosition: self.skeletonView.jointPositionInView)
        if let character = editingCharacter {
            character.edit(node, characterImage: characterSkin)
        } else {
            if characterName != nil {
                CharacterStorage.insertCharacter(characterName!, characterNode: node, characterImage: characterSkin)
            } else {
                return
            }

        }
        HUD.dismiss()
        performSegueWithIdentifier(Storyboard.DoneAddingCharacterIdentifier, sender: nil)
        
    }
    
    
    
    private var alertForNamePrompt: UIAlertController{
        let alert = UIAlertController(title: "Name", message: "Give a name to the character you just created!", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Done", style: .Default) { action in
            self.HUD.textLabel.text = "Saving"
            self.HUD.showInView(self.view)
            self.characterName = alert.textFields![0].text
            self.saveCharacter()
        }
        
        confirmAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        alert.preferredAction = confirmAction
        alert.addTextFieldWithConfigurationHandler { textField in
            textField.becomeFirstResponder()
            textField.placeholder = "Name"
            textField.clearButtonMode = .WhileEditing
            textField.autocapitalizationType = .Words
            textField.autocorrectionType = .No
            textField.returnKeyType = .Done

            textField.addTarget(self, action: "textChangedForNamePrompt:", forControlEvents: .EditingChanged)

        }
        return alert
    }
    
    @objc private func textChangedForNamePrompt(sender: UITextField) {
        var resp : UIResponder = sender
        while !(resp is UIAlertController) { resp = resp.nextResponder()! }
        let alert = resp as! UIAlertController
        alert.actions[1].enabled = (sender.text != "")
    }
    
    // MARK:  Image Segmentation
    
    
    var segmentedParts = [BodyPartName: CGImage]()
    var segmentedPartsFrame = [BodyPartName: CGRect]()
    func jointPoint(joint: JointName) -> CGPoint {
        return skeletonView.jointPositionInView[joint]!
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
                    if pixel.alphaValue != 0 && pixel.alphaValue != 0xFF {
                        let part = inBodyPart(p)
                        pixels[width * y + x] = self.colorForPart[part]!
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
    
    func segmentParts(completion: () -> Void){
        for joint in JointName.allJoints {
            print("segmentParts: .\(joint): CGPoint(x: \(jointPoint(joint).x), y: \(jointPoint(joint).y))")
        }
        let image = characterSkin.CGImage!
        let inBodyPart = belongsToBodyPart()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            self.moved = false
            let (pixels, _) = image.toARGBBitmapData()
            var data = [BodyPartName: (pixel: UnsafeMutablePointer<UInt32>, context: CGContext?)]()
            
            let width = CGImageGetWidth(image)
            let height = CGImageGetHeight(image)
            
            var lowX = [BodyPartName: Int]()
            var lowY = [BodyPartName: Int]()
            var highX = [BodyPartName: Int]()
            var highY = [BodyPartName: Int]()
            
            for part in BodyPartName.allParts {
                lowX[part] = width
                lowY[part] = height
                highX[part] = 0
                highY[part] = 0
            }
            
            for part in BodyPartName.allParts {
                let c = image.createARGBBitmapContext()
                let p = UnsafeMutablePointer<UInt32>(CGBitmapContextGetData(c))
                data[part] = (pixel: p,context: c)
            }
            
            
            for y in 0..<height {
                for x in 0..<width {
                    if self.moved == true {
                        return
                    }
                    let p = self.characterImageView.convertPoint(CGPoint(x:x,y:y), toView: self.skeletonView)
                    let pixel = pixels[width * y + x]
                    if pixel.alphaValue != 0 {
                        let part = inBodyPart(p)
                        data[part]?.pixel[width * y + x] = pixel
                        lowX[part] = x < lowX[part] ? x : lowX[part]
                        highX[part] = x > highX[part] ? x : highX[part]
                        lowY[part] = y < lowY[part] ? y : lowY[part]
                        highY[part] = y > highY[part] ? y : highY [part]
                    }
                }
            }
            free(pixels)
            for part in BodyPartName.allParts {
                let image = CGBitmapContextCreateImage(data[part]?.context)
                let newRect = CGRect(x: lowX[part]!, y: lowY[part]!, width: highX[part]!-lowX[part]!, height: highY[part]!-lowY[part]!)
                if let imageRef = CGImageCreateWithImageInRect(image, newRect) {
                    self.segmentedParts[part] = imageRef
                } else {
                    print("image not generated for \(part), rectangle is \(newRect)")
                }
                let convertedRect = CGRect(origin: self.characterImageView.convertPoint(newRect.origin, toView: self.skeletonView), size: newRect.size)
                self.segmentedPartsFrame[part] = convertedRect
                free(data[part]!.pixel)
            }

            dispatch_async(dispatch_get_main_queue(), completion)
        }

    }
    
    func belongsToBodyPart() -> (CGPoint) -> BodyPartName {
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
        let ret: (CGPoint) -> BodyPartName = {p in
            if dot(p-neckPoint,neckPoint - waistPoint) > 0 {
                return .Head
            }
            if dot(p-bodyPoint, (neckPoint - waistPoint).perpendicular) > 0 {
                // left body
                if dot(p-leftAnklePoint, leftAnklePoint - leftKneePoint) > 0 {
                    return .LeftFoot
                }
                if dot(p-leftElbowPoint,leftElbowPoint - leftShoulderPoint) > 0 &&
                    dot(p-leftShoulderPoint, (leftWristPoint - leftElbowPoint).perpendicular) < 0 {
                    return .LeftForearm
                }
                if dot(p-leftKneePoint, leftAnklePoint - leftKneePoint) > 0 {
                    // && dot(p-leftAnklePoint, leftAnklePoint - leftKneePoint) <= 0
                    return .LeftShank
                }
                if dot(p-leftHipPoint,  leftKneePoint - leftHipPoint) > 0 {
                    // && dot(p-leftKneePoint, leftAnklePoint - leftKneePoint) <= 0
                    return .LeftThigh
                }
                if dot(p-leftShoulderPoint, leftShoulderPoint - bodyPoint) > 0 &&
                    dot(p-leftElbowPoint,leftElbowPoint - leftShoulderPoint) <= 0 {
                    return .LeftUpperArm
                }
            
            } else {
                // right body
                if dot(p-rightAnklePoint, rightAnklePoint - rightKneePoint) > 0 {
                    return .RightFoot
                }
                if dot(p-rightElbowPoint,rightElbowPoint - rightShoulderPoint) > 0 &&
                    dot(p-rightShoulderPoint, (rightWristPoint - rightElbowPoint).perpendicular) >= 0 {
                    return .RightForearm
                }
                if dot(p-rightKneePoint, rightAnklePoint - rightKneePoint) > 0 {
                    // && dot(p-rightAnklePoint, rightAnklePoint - rightKneePoint) <= 0
                    return .RightShank
                }
                if dot(p-rightHipPoint,  rightKneePoint - rightHipPoint) > 0 {
                    // && dot(p-rightKneePoint, rightAnklePoint - rightKneePoint) <= 0
                    return .RightThigh
                }
                if dot(p-rightShoulderPoint, rightShoulderPoint - bodyPoint) > 0 &&
                    dot(p-rightElbowPoint,rightElbowPoint - rightShoulderPoint) <= 0 {
                    return .RightUpperArm
                }
            }
            //Not limbs or head
            if dot(p-waistPoint,neckPoint - waistPoint) > 0 {
                return .UpperBody
            }
            return .LowerBody
            
        }
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


