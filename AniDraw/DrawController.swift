//
//  DrawController.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

enum DrawingTool: Int {
    case Pencil = 1
    case Pen
    case Brush
    case Crayon
    case Eraser
}

class DrawController: UIViewController {
    
    @IBOutlet private weak var drawView: DrawView!
    @IBOutlet var toolsButton: [UIButton]!
    
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
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTool = .Pen
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for button in toolsButton {
            button.frame.origin = CGPoint(x: -100, y: button.frame.minY)
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
        default:
            break
        }
    }
    
    @IBAction private func goBack(sender: UIButton) {
        dismissViewControllerAnimated(true) {}
    }
}
