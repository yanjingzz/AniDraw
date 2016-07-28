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
    var newMoveFlag = true
    var allMoves: [DanceMove]!
    var danceMove: DanceMove = DanceMove()
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
        allMoves = Moves.all()
//        for move in allMoves {
//            print("\(move.name), \(move.style), \(move.level)")
//        }
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
    
    // MARK: - Playback controls
    
    @IBAction func playAnimation(sender: UIButton) {
        if currentIndex >= 0 {
            danceMove.keyframes[currentIndex].posture = characterNode.posture
        }
        print(danceMove.keyframes)
        print(danceMove.keyframes.flipped)
        
        scene.playAnimation(danceMove)
        currentIndex = -1
    }
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var nameButton: UIButton!
    
     @IBAction func sliderValueChanged(sender: UISlider) {
        if danceMove.keyframes.isEmpty {
            currentIndex = -1
            slider.setValue(0,animated: false)
            return
        }
        if scene.playing {
            scene.playing = false
        } else if currentIndex != -1 {
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
    
    
    // MARK: Pan recognizer
    
    @IBAction func moveCharacterForPanRecognizer(recognizer: UIPanGestureRecognizer) {
        scene.moveCharacter(recognizer.translationInView(skView))
        recognizer.setTranslation(CGPointZero, inView: skView)
    }
    
    //MARK: UI controls
    
    @IBAction func addPosture(sender: UIButton) {
        
        let p = characterNode.posture
        if currentIndex >= 0 {
            danceMove.keyframes[currentIndex].posture = p
        }
        let key = Keyframe(time: 0.5, posture: p)
        danceMove.keyframes.insert(key, atIndex: currentIndex + 1)
        currentIndex += 1
        updateEditView()
    
    }
    
    func deletePosture() {
        if currentIndex >= 0 {
            danceMove.keyframes.removeAtIndex(currentIndex)
            currentIndex -= 1
            updateEditView()
        }
    }
    
    func restorePosture() {
        characterNode.posture = Posture.idle
    }

    
    @IBAction func namePopover(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let saveAction = UIAlertAction(title: "Save Dance Move", style: .Default) { [unowned self] action in
            self.saveDanceMove()
        }
        saveAction.enabled = (danceMove.keyframesSet != nil && danceMove.keyframesSet!.count != 0)
        let newAction = UIAlertAction(title: "New Dance Move", style: .Default) { [unowned self] action in
            self.newDanceMove()
        }
        let nextAction = UIAlertAction(title: "Next Dance Move", style: .Default) { [unowned self] action in
            self.nextDanceMove()
        }
        alert.addAction(saveAction)
        alert.addAction(newAction)
        alert.addAction(nextAction)
        alert.view.layoutIfNeeded()
        if let popoverVC = alert.popoverPresentationController {
            popoverVC.sourceView = view
            popoverVC.sourceRect = sender.frame
            
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func editPopover(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let restoreAction = UIAlertAction(title: "Restore Posture", style: .Destructive) { [unowned self] action in
            self.restorePosture()
        }
        
        let deleteAction = UIAlertAction(title: "Delete Posture", style: .Destructive) { [unowned self] action in
            self.deletePosture()
        }
        alert.addAction(restoreAction)
        alert.addAction(deleteAction)
        alert.view.layoutIfNeeded()
        if let popoverVC = alert.popoverPresentationController {
            popoverVC.sourceView = view
            popoverVC.sourceRect = sender.frame
            
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    


    //MARK: - Save dance move to file
    func saveDanceMove() {
        presentViewController(alertForNamePrompt, animated: true, completion: nil)
    }
    func discardChanges() {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
//        if newMoveFlag {
//            context.deleteObject(danceMove)
//        } else {
//            context.refreshObject(self.danceMove, mergeChanges: false)
//        }
        context.rollback()
        allMoves = Moves.all()
//        print(allMoves)
    }
    
    func newDanceMove() {
        discardChanges()
        newMoveFlag = true
        danceMove = DanceMove()
        nameButton.setTitle("New Dance Move", forState: .Normal)
        updateEditView()
        currentIndex = -1
    }
    
    func nextDanceMove() {
        discardChanges()
        newMoveFlag = false
        danceMove = allMoves[moveIndex]
        let name = danceMove.name ?? ""
        nameButton.setTitle("\(danceMove.style)-\(name)", forState: .Normal)
        print("\(name) \(danceMove.level) \(danceMove.style)")
        updateEditView()
        moveIndex += 1
        if moveIndex >= allMoves.count {
            moveIndex = 0
        }
        currentIndex = -1
    }
    
    func writeToFile() {
        let currentDance = danceMove
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let fileName = "danceMove.txt"
            let dir:NSURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last! as NSURL
            let fileurl =  dir.URLByAppendingPathComponent(fileName)
            
            do {
                try "\n_ = DanceMove( \nkeyframes:".appendLineToURL(fileurl)
                try "\(currentDance.keyframes), ".appendLineToURL(fileurl)
                try "levelOfIntensity: 1, \nstyle: .Generic,".appendLineToURL(fileurl)
                try "name: \"\(currentDance.name)\")".appendLineToURL(fileurl)
                print("\(fileurl)")
            }
            catch {
                print("Could not write to file")
            }
        }
        
    }
    
    private var alertForNamePrompt: UIAlertController {
        let alert = UIAlertController(title: "Save", message: "If you want to save, enter a name and press Done!", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Done", style: .Default) { action in
            
            let name = alert.textFields![0].text ?? ""
            self.danceMove.name = name
            self.writeToFile()
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.newDanceMove()
            }
        }
        
        confirmAction.enabled = !self.danceMove.name.isEmpty
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        alert.preferredAction = confirmAction
        alert.addTextFieldWithConfigurationHandler { textField in
            textField.becomeFirstResponder()
            textField.placeholder = "Name"
            textField.text = self.danceMove.name ?? ""
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
    
    @IBAction private func goBack(sender: UIButton) {
        discardChanges()
        dismissViewControllerAnimated(true) {}
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

