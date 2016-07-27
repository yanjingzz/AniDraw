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
    
    var skeletonModelJoints = [JointName:CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let characterImage = characterSkin {
            characterImageView.image = characterImage
        } else {
            characterSkin = characterImageView.image?.trimToNontransparent()
        }
        // Do any additional setup after loading the view.
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    ////        self.reset()
    ////        updateImage()
    //    }
    
    // MARK: - Move Points
    
    private var movedView : UIView?
    private var moved = false
    
    
    @IBAction private func moveJointsWithPanRecognizer(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            let p = recognizer.locationInView(skeletonView)
            if let view = view.hitTest(p, withEvent: nil) where view != skeletonView {
                
                SkeletonModel.lastUpdateTimeStamp = NSDate()
                
                moved = true
                movedView = view
            }
        case .Changed:
            if let view = movedView {
                moved = true
                let p = recognizer.locationInView(skeletonView)
                view.frame.center = p
                skeletonView.setNeedsDisplay()
            }
        case .Ended:
            if movedView != nil {
                self.resetJoints()
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
        let confirmAction = UIAlertAction(title: "Done", style: .Default) { [unowned self] action in
            dispatch_async(dispatch_get_main_queue()) {
                self.HUD.textLabel.text = "Saving"
                self.HUD.showInView(self.view)
                self.characterName = alert.textFields![0].text
                self.saveCharacter()
            }
            
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
            
            textField.addTarget(self, action: #selector(SkeletonController.textChangedForNamePrompt), forControlEvents: .EditingChanged)
            
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
    
    //TODO: CGContext issues
    
    func updateImage() {  //preview
        
        print("updateImage")
        
        let image = characterSkin.CGImage!
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            
            let skeletonModel = SkeletonModel()
            SkeletonModel.lastUpdateTimeStamp = skeletonModel.selfUpdateTimeStamp
            skeletonModel.setParameter(self.characterImageView.frame.origin,image:self.characterSkin)
            if skeletonModel.needAbort() == true {return}
            skeletonModel.setJointsPosition(self.skeletonModelJoints)
            if skeletonModel.needAbort() == true {return}
            skeletonModel.performClassifyJointsPerPixel()
            if skeletonModel.needAbort() == true {return}
            
            let inBodyPart = skeletonModel.getBodyPartsFromAbsolutePosition
            
            
            self.moved = false
            let (pixels, context) = image.toARGBBitmapData()
            
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
                        let (part1,part2) = inBodyPart(p)
                        let partBasedOnPriority = SkeletonModel.getBodyPartNameInPriority(part1, b2: part2)
                        if partBasedOnPriority != nil {
                            pixels[width * y + x] = self.colorForPart[partBasedOnPriority!]!
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
    
    func segmentParts(completion: () -> Void){ //save image
        print("segmentParts")
        for joint in JointName.allJoints {
            print("segmentParts: .\(joint): CGPoint(x: \(jointPoint(joint).x), y: \(jointPoint(joint).y))")
        }
        let image = characterSkin.CGImage!
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            
            let skeletonModel = SkeletonModel()
            SkeletonModel.lastUpdateTimeStamp = skeletonModel.selfUpdateTimeStamp
            skeletonModel.setParameter(self.characterImageView.frame.origin,image:self.characterSkin)
            skeletonModel.setJointsPosition(self.skeletonModelJoints)
            skeletonModel.performClassifyJointsPerPixel()
            
            let inBodyPart = skeletonModel.getBodyPartsFromAbsolutePosition
            
            
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
                        let (part1,part2) = inBodyPart(p)
                        if part1 != nil {
                            data[part1!]?.pixel[width * y + x] = pixel
                            lowX[part1!] = x < lowX[part1!] ? x : lowX[part1!]
                            highX[part1!] = x > highX[part1!] ? x : highX[part1!]
                            lowY[part1!] = y < lowY[part1!] ? y : lowY[part1!]
                            highY[part1!] = y > highY[part1!] ? y : highY [part1!]
                        }
                        if part2 != nil {
                            data[part2!]?.pixel[width * y + x] = pixel
                            lowX[part2!] = x < lowX[part2!] ? x : lowX[part2!]
                            highX[part2!] = x > highX[part2!] ? x : highX[part2!]
                            lowY[part2!] = y < lowY[part2!] ? y : lowY[part2!]
                            highY[part2!] = y > highY[part2!] ? y : highY [part2!]
                        }
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
    
    func resetJoints() {
        for joint in JointName.allJoints {
            skeletonModelJoints[joint] = jointPoint(joint)
            print("\(joint):\(skeletonModelJoints[joint])")
        }
    }
    
}


