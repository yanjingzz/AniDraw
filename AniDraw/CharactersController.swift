//
//  CharactersController.swift
//  AniDraw
//
//  Created by Mike on 7/5/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit
import JGProgressHUD

class CharactersController: UIViewController, UIScrollViewDelegate{
    
    //TODO: update characterImage after redraw?
    
    var characters: [CharacterStorage]?
    private var currentCharacter: CharacterStorage? {
        if carousel.currentItemIndex < 0 {
            return nil
        }
        return characters?[carousel.currentItemIndex]
    }
    private var currentCharacterImage: UIImage? {
        if let imageView = carousel.currentItemView as? UIImageView, let image = imageView.image {
            return image
        }
        return nil
    }
    @IBOutlet weak var carousel: iCarousel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .CoverFlow2
        carousel.bounceDistance = 0.1
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        characters = CharacterStorage.allCharacters()
        carousel.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    
    @IBAction func editCharacter(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let redrawAction = UIAlertAction(title: "Redraw Character", style: .Default) {[unowned self] action in
            self.performSegueWithIdentifier(Storyboard.RedrawCharacterIdentifier, sender: action)
        }
        let resegmentAction = UIAlertAction(title: "Reposition Skeletion", style: .Default) {[unowned self] action in
            self.performSegueWithIdentifier(Storyboard.RepositionSkeletonIdentifier, sender: action)
        }
        let deleteAction = UIAlertAction(title: "Delete Character", style: .Destructive) {[unowned self] action in
            self.deleteCharacter()
        }
        alert.addAction(redrawAction)
        alert.addAction(resegmentAction)
        alert.addAction(deleteAction)
        alert.view.layoutIfNeeded()
        if let popoverVC = alert.popoverPresentationController {
            popoverVC.sourceView = view
            popoverVC.sourceRect = sender.frame
            
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteCharacter() {
        if let character = currentCharacter {
            let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            context.performBlock {
                context.deleteObject(character)
                
                do {
                    try context.save()
                } catch {
                    print("CharactersController deleteCharacter: save error!")
                    print(error)
                }
            }
            characters?.removeAtIndex(carousel.currentItemIndex)
        }
        carousel.reloadData()
    }
    
    
    
    @IBAction func dance(sender: UIButton) {
        guard currentCharacter != nil else {
            showNoCharacterHUD()
            return
        }
        performSegueWithIdentifier(Storyboard.DanceIdentifier, sender: sender)
    }
    @IBAction func editDanceMove(sender: UIButton) {
        guard currentCharacter != nil else {
            showNoCharacterHUD()
            return
        }
        performSegueWithIdentifier(Storyboard.EditDanceMoveIdentifier, sender: sender)
        
    }
    
    func showNoCharacterHUD() {
        let hud = JGProgressHUD(style: .ExtraLight)
        hud.indicatorView = JGProgressHUDImageIndicatorView(image: UIImage(named: "forbidden"))
        hud.textLabel.text = "Create a character first!"
        hud.showInView(view)
        hud.dismissAfterDelay(1.0)
    }

    
    // MARK: - Navigation
    
    private struct Storyboard {
        static let DoneAddingCharacterIdentifier = "doneAddingCharacter"
        static let EditDanceMoveIdentifier = "editDanceMove"
        static let DanceIdentifier = "dance"
        static let RedrawCharacterIdentifier = "redrawCharacter"
        static let RepositionSkeletonIdentifier = "repositionSkeleton"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let ident = segue.identifier else{
            return
        }
        switch ident {
        case Storyboard.DanceIdentifier:
            guard let destVC = segue.destinationViewController as? AnimationController,
                let character = currentCharacter else {
                break
            }
            
            destVC.characterNode = CharacterNode(character: character)
            
            
        case Storyboard.EditDanceMoveIdentifier:
            guard let destVC = segue.destinationViewController as? EditMoveController,
                let character = currentCharacter else {
                break
            }
            
            destVC.characterNode = CharacterNode(character: character)
            print(destVC.characterNode)

        case Storyboard.RedrawCharacterIdentifier:
            guard let destVC = segue.destinationViewController as? DrawController,
                let character = currentCharacter else {
                break
            }
            destVC.editingCharacter = character
        case Storyboard.RepositionSkeletonIdentifier:
            guard let destVC = segue.destinationViewController as? SkeletonController,
                let character = currentCharacter else {
                    break
            }
            destVC.characterSkin = currentCharacterImage?.trimToNontransparent()
            destVC.editingCharacter = character

            
        default:
            break
        }
    }
    
    @IBAction func unwindToCharactersController(segue: UIStoryboardSegue) {
        print("CharactersController unwindToCharactersController")
    }


}

//MARK: - Carousel delegate

extension CharactersController: iCarouselDataSource, iCarouselDelegate {

    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return characters?.count ?? 0
    }
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var itemView: UIImageView
        if (view == nil)
        {
            let height = carousel.bounds.height - 50
//            let width = carousel.bounds.width - 200
            itemView = UIImageView(frame:CGRect(x:0, y:0, width: height, height: height))
            itemView.contentMode = .ScaleAspectFit
        }
        else
        {
            itemView = view as! UIImageView
        }
        if let imageData = characters?[index].wholeImage, let image = UIImage(data: imageData) {
            itemView.image = image
        }
        return itemView
    }
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        if carousel.currentItemIndex < 0 {
            nameLabel.text = ""
        } else {
            nameLabel.text = characters?[carousel.currentItemIndex].name ?? ""
        }
    }
}
