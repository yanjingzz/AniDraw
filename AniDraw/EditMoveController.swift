//
//  ViewController.swift
//  AniDraw
//
//  Created by Mike on 6/28/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
import SpriteKit

class EditMoveController: UIViewController, KeyframeDetailControllerDelegate {
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var editView: KeyframesEditorView!
    
    var danceMove = DanceMove()
    var currentIndex: Int = -1 {
        didSet {
            currentIndex.clamp(-1, danceMove.count - 1)
            if currentIndex == -1 {
                characterNode?.posture = Posture.idle
                slider.value = 0
                return
            }
            
            var beforeTime = 0.0
            for (i,keyframe) in danceMove.keyframes.enumerate() {
                beforeTime += keyframe.time
                if i == currentIndex {
                    break
                }
            }
            slider.value = Float(beforeTime / danceMove.totalTime)
            characterNode?.posture = danceMove.keyframes[currentIndex].posture
        }
    }
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        if danceMove.keyframes.isEmpty {
            currentIndex = -1
            slider.setValue(0,animated: false)
            return
        }
        let beforeTime = Double(slider.value) * danceMove.totalTime
        if beforeTime <= danceMove.keyframes[0].time/2 {
            currentIndex = -1
            return
        }
        var accTime = 0.0
        for (i,k) in danceMove.keyframes.enumerate() {
            if i == danceMove.count-1 {
                currentIndex = i
                return
            }
            accTime += k.time
            if accTime + danceMove.keyframes[i+1].time/2 > beforeTime {
                currentIndex = i
                return
            }
            
        }
        
    }
    func updateEditView() {
        var lengths = [CGFloat]()
        var currentLength: CGFloat = 0.0
        for key in danceMove.keyframes {
            currentLength += CGFloat(key.time)
            lengths.append(currentLength)
            
        }
        editView.lengths = lengths
        editView.totalLength = currentLength
    }
    @IBAction func addPosture(sender: UIButton) {
        if let c = characterNode {
            let p = c.posture
            let key = Keyframe(time: 0.5, posture: p)
            
            danceMove.keyframes.insert(key, atIndex: currentIndex + 1)
            currentIndex += 1
            updateEditView()
        }
       
    }
    @IBAction func deletePosture(sender: AnyObject) {
        if currentIndex >= 0 {
            danceMove.keyframes.removeAtIndex(currentIndex)
            currentIndex -= 1
            updateEditView()
        }
    }
    
    @IBAction func restorePosture(sender: UIButton) {
        characterNode?.posture = Posture.idle
    }
    
    @IBAction func playAnimation(sender: UIButton) {
        if !postures.isEmpty {
            let danceMove = DanceMove(withSeriesOfPostures: postures, ofEqualInterval: 0.5)
            scene.playAnimation(danceMove)
            print("[")
            for posture in postures {
                posture.printConstructor()
            }
            print("]")
        }
//        let random = Int.random(min: 1, max: 5)
//        scene.playAnimation(danceMove)
    }
    
    var characterNode: CharacterNode? {
        didSet {
            print(characterNode)
            updateCharacter()
        }
    }
    
    let scene = EditMoveScene(fileNamed:"DanceScene")!
    
    @IBAction func moveCharacterForPanRecognizer(recognizer: UIPanGestureRecognizer) {

        scene.moveCharacter(recognizer.translationInView(skView))
        recognizer.setTranslation(CGPointZero, inView: skView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }
    
    @objc func showKeyframeDetail(sender: UIButton) {
        performSegueWithIdentifier(Storyborad.PopoverSegueIdentifier, sender: sender)
    }
    
    
    
    func updateCharacter() {
        characterNode?.posture = Posture.idle
        scene.characterNode = characterNode
        
    }
    
    private struct Storyborad {
        static let PopoverSegueIdentifier = "showKeyframeDetail"
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
            
        case Storyborad.PopoverSegueIdentifier:
            guard let destNav = segue.destinationViewController as? UINavigationController, let keyVC = destNav.visibleViewController as? KeyframeDetailController, let button = sender as? UIButton else{
                break
            }
            
            let popoverVC = destNav.popoverPresentationController! as UIPopoverPresentationController
            popoverVC.sourceView = button
            popoverVC.presentedViewController.preferredContentSize = keyVC.view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            let index = button.tag
            let data = KeyframeDetailData(
                index: index,
                time: danceMove.keyframes[index].time,
                positionCurve: danceMove.keyframes[index].positionCurve,
                angleCurve: danceMove.keyframes[index].angleCurve)
            keyVC.setData(data)
            keyVC.delegate = self
        default:
            break
        }
        
    }
    
    
    func keyframeDetailControllerWillDisapper(withData data: KeyframeDetailData) {
        let index = data.index
        danceMove.keyframes[index].time = data.time
        danceMove.keyframes[index].angleCurve = data.angleCurve
        danceMove.keyframes[index].positionCurve = data.positionCurve
        updateEditView()
    }
    
    

}

