//
//  DrawController.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
import MSColorPicker

enum DrawingTool: Int {
    case Pencil = 1
    case Pen
    case Brush
    case Crayon
    case Eraser
}

class DrawController: UIViewController, MSColorSelectionViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet private weak var drawView: DrawView!
    @IBOutlet var toolsButton: [UIButton]!
    @IBOutlet weak var selectedColorCircleView: UIImageView!
    @IBOutlet weak var firstColorButton: UIButton!
    var editingCharacter: CharacterStorage?
    
    var selectedColorButton: UIButton? {
        didSet {
            if selectedColorButton != nil {
                selectedColorCircleView.frame.origin = selectedColorButton!.frame.origin
            }
            
        }
    }
    
    @IBAction private func selectColor(sender: UIButton) {
        if let c = sender.backgroundColor {
            drawView.color = c
        }
        
        if sender == selectedColorButton {
            performSegueWithIdentifier(Storyborad.PopoverSegueIdentifier, sender: sender)
        }
        self.selectedColorButton = sender
    }
    
    private struct Constant {
        static let drawingToolsAnimationDuration = 0.3
    }
    
    
    var selectedTool = DrawingTool.Pencil {
        willSet {
            guard newValue != selectedTool else {
                return
            }
            for button in toolsButton {
                if button.tag == selectedTool.rawValue {
                    UIView.animateWithDuration(
                        Constant.drawingToolsAnimationDuration,
                        delay: 0,
                        options: .CurveEaseInOut,
                        animations: { button.frame.origin = CGPoint(x: -100, y: button.frame.minY) },
                        completion: nil
                    )
                    
                }
                if button.tag == newValue.rawValue {
                    UIView.animateWithDuration(
                        Constant.drawingToolsAnimationDuration,
                        delay: 0,
                        options: .CurveEaseInOut,
                        animations: { button.frame.origin = CGPoint(x: 0, y: button.frame.minY) },
                        completion: nil
                    )
                }
            }
        }
        didSet {
            drawView?.tool = selectedTool
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.color = firstColorButton.backgroundColor!
        selectedColorButton = firstColorButton
        if let character = editingCharacter,
            let imageData = character.wholeImage,
            let image = UIImage(data: imageData) {
            drawView.initialImage = image
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectedColorCircleView.frame.origin = selectedColorButton!.frame.origin
        for button in toolsButton {
            if button.tag == DrawingTool.Pencil.rawValue {
                button.frame.origin = CGPoint(x: 0, y: button.frame.minY)
            } else {
                button.frame.origin = CGPoint(x: -100, y: button.frame.minY)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func selectTool(sender: UIButton) {
        selectedTool = DrawingTool(rawValue: sender.tag)!
    }
    
    private struct Storyborad {
        static let NextStepSegueIdentifier = "putSkeleton"
        static let PopoverSegueIdentifier = "showPopover"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case Storyborad.NextStepSegueIdentifier:
            guard let skeletonVC = segue.destinationViewController as? SkeletonController else {
                break
            }
            let image = drawView.image
            skeletonVC.characterSkin = image
            if let character = editingCharacter {
                skeletonVC.editingCharacter = character
            }

            
        case Storyborad.PopoverSegueIdentifier:
            guard let destNav = segue.destinationViewController as? UINavigationController, let colorVC = destNav.visibleViewController as? MSColorSelectionViewController else{
                break
            }
            
            let popoverVC = destNav.popoverPresentationController! as UIPopoverPresentationController
            popoverVC.sourceView = self.view
            popoverVC.sourceRect = selectedColorCircleView.frame
            popoverVC.presentedViewController.preferredContentSize = colorVC.view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            destNav.popoverPresentationController?.delegate = self
            colorVC.delegate = self
            if let c = selectedColorButton?.backgroundColor {
                colorVC.color = c
            }
            
        default:
            break
        }
    }
    
    @IBAction private func goBack(sender: UIButton) {
        dismissViewControllerAnimated(true) {}
    }
    
    func colorViewController(colorViewCntroller: MSColorSelectionViewController!, didChangeColor color: UIColor!) {
        guard let button = selectedColorButton, let c = color else {
            return
        }
        button.backgroundColor = c
        drawView.color = c
    }
}
