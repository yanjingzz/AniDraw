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
    
    var characterNode: CharacterNode!
    var moveIndex = 0
    var danceMove = MovesStorage.array[0]
    var scene: EditMoveScene!
    
    var currentIndex: Int = -1 {
        didSet {
            currentIndex.clamp(-1, danceMove.count - 1)
            if currentIndex == -1 {
                characterNode.posture = Posture.idle
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
            characterNode.posture = danceMove.keyframes[currentIndex].posture
        }
    }

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScene()
        characterNode.posture = Posture.idle
        scene.characterNode = characterNode
        updateEditView()
    }

    
    private func setUpScene() {
        scene = EditMoveScene(fileNamed:"DanceScene")
        scene.characterNode = characterNode
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
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
    
    // MARK: - Controls
    
    @IBAction func playAnimation(sender: UIButton) {
        print(danceMove.keyframes)
        scene.playAnimation(danceMove)
        currentIndex = danceMove.count - 1
    }
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        if danceMove.keyframes.isEmpty {
            currentIndex = -1
            slider.setValue(0,animated: false)
            return
        }
        if currentIndex != -1 {
            danceMove.keyframes[currentIndex].posture = characterNode.posture
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
        characterNode.posture = Posture.idle
    }
    
    // MARK: Pan recognizer
    
    @IBAction func moveCharacterForPanRecognizer(recognizer: UIPanGestureRecognizer) {
        scene.moveCharacter(recognizer.translationInView(skView))
        recognizer.setTranslation(CGPointZero, inView: skView)
    }

    //MARK: - Save dance move to file
    
    @IBAction func nextDanceMove() {
        moveIndex += 1
        if moveIndex >= MovesStorage.array.count {
            moveIndex = 0
        }
        danceMove = MovesStorage.array[moveIndex]
        updateEditView()
        currentIndex = -1

    }
    
    @IBAction func saveDanceMove(sender: AnyObject) {
        presentViewController(alertForNamePrompt, animated: true, completion: nil)
        
    }
    func writeToFileAndUpdate(name: String?) {
        let fileName = "danceMove.txt"
        let dir:NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last! as NSURL
        let fileurl =  dir.URLByAppendingPathComponent(fileName)
        
        do {
            if let name = name {
                try "\n\nstatic let \(name) = DanceMove( \nkeyframes:".appendLineToURL(fileurl)
                try "\(danceMove.keyframes), ".appendLineToURL(fileurl)
                try "levelOfIntensity: 1)".appendLineToURL(fileurl)
            }
            
            print("\(fileurl)")
            
        }
        catch {
            print("Could not write to file")
        }
        danceMove = DanceMove()
        updateEditView()
        currentIndex = -1
    }
    
    private var alertForNamePrompt: UIAlertController {
        let alert = UIAlertController(title: "Name", message: "Give a name to dance move you just created!", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Done", style: .Default) { action in
            self.writeToFileAndUpdate(alert.textFields![0].text)
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
            
            textField.addTarget(self, action: #selector(self.textChangedForNamePrompt), forControlEvents: .EditingChanged)
            
        }
        return alert
    }
    
    @objc private func textChangedForNamePrompt(sender: UITextField) {
        var resp : UIResponder = sender
        while !(resp is UIAlertController) { resp = resp.nextResponder()! }
        let alert = resp as! UIAlertController
        alert.actions[1].enabled = (sender.text != "")
    }
    
    // MARK: - Navigation
    
    private struct Storyborad {
        static let PopoverSegueIdentifier = "showKeyframeDetail"
    }
    
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
    
    // MARK: Keyframe detail controller
    
    @objc func showKeyframeDetail(sender: UIButton) {
        performSegueWithIdentifier(Storyborad.PopoverSegueIdentifier, sender: sender)
    }
    
    func keyframeDetailControllerWillDisapper(withData data: KeyframeDetailData) {
        let index = data.index
        danceMove.keyframes[index].time = data.time
        danceMove.keyframes[index].angleCurve = data.angleCurve
        danceMove.keyframes[index].positionCurve = data.positionCurve
        updateEditView()
    }

    
    
    

}

