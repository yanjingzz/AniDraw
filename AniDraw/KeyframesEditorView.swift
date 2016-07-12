//
//  KeyframesEditorView.swift
//  AniDraw
//
//  Created by Mike on 7/11/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

class KeyframesEditorView: UIView {
    
    private var keyViews = [UIView]()
    private var timeButtons = [UIButton]()
   
    var lengths = [CGFloat]() {
        didSet {
            if oldValue.count < lengths.count {
                for _ in 0..<(lengths.count-oldValue.count) {
                    let keyView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
                    keyView.backgroundColor = UIColor.darkGrayColor()
                    keyView.layer.cornerRadius = 10.0
                    keyViews.append(keyView)
                    addSubview(keyView)
                    
                    let button = UIButton(type: .System)
                    button.tintColor = UIColor.darkGrayColor()
                    button.setTitle("", forState: .Normal)
                    timeButtons.append(button)
                    button.addTarget(nil, action: #selector(EditMoveController.showKeyframeDetail), forControlEvents: .TouchUpInside)
                    addSubview(button)
                }
            } else if oldValue.count > lengths.count{
                for _ in 0..<(oldValue.count-lengths.count) {
                    let view = keyViews.popLast()
                    view?.removeFromSuperview()
                    let button = keyViews.popLast()
                    button?.removeFromSuperview()
                }
            }
            setNeedsLayout()
        }
    }
    
    var totalLength: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (i,view) in keyViews.enumerate() {
            view.frame.origin = CGPoint(x: lengths[i] / totalLength * bounds.width - 5, y: 0)
            
        }
        for(i, button) in timeButtons.enumerate() {
            
            button.sizeToFit()
            button.tag = i
            if i == 0 {
                button.setTitle("\(lengths[i])s", forState: .Normal)
                button.frame.origin = CGPoint(x: lengths[i] / totalLength * bounds.width / 2 - 5, y: 0)
            } else {
                button.setTitle("\(lengths[i] - lengths[i-1])s", forState: .Normal)
                button.frame.origin = CGPoint(x: (lengths[i] + lengths[i-1]) / totalLength * bounds.width / 2 - 5, y: 0)
            }
        }
    }
    
}
