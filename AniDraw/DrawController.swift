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
    
    var colorButton: UIButton?
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
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
            if let skeletonVC = segue.destinationViewController as? SkeletonController {
                let image = drawView.image
                skeletonVC.characterSkin = image
            }
        case Storyborad.PopoverSegueIdentifier:
            guard let destNav = segue.destinationViewController as? UINavigationController, let colorVC = destNav.visibleViewController as? MSColorSelectionViewController, let button = sender as? UIButton else{
                break
            }
            self.colorButton = button
            let popoverVC = destNav.popoverPresentationController! as UIPopoverPresentationController
            popoverVC.sourceView = self.view
            popoverVC.sourceRect = button.frame
            popoverVC.presentedViewController.preferredContentSize = colorVC.view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            destNav.popoverPresentationController?.delegate = self
            colorVC.delegate = self
            colorVC.color = UIColor.redColor()
        default:
            break
        }
    }
    
    @IBAction private func goBack(sender: UIButton) {
        dismissViewControllerAnimated(true) {}
    }
    
    func colorViewController(colorViewCntroller: MSColorSelectionViewController!, didChangeColor color: UIColor!) {
        guard let button = colorButton, let c = color else {
            return
        }
        button.backgroundColor = c
    }
}
