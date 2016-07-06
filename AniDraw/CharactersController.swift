//
//  CharactersController.swift
//  AniDraw
//
//  Created by Mike on 7/5/16.
//  Copyright © 2016 yanjingzz. All rights reserved.
//

import UIKit

class CharactersController: UIViewController {

    var characters: [CharacterStorage]?
    private var currentCharacter: CharacterStorage? {
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

    //TODO: update characterImage after redraw?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private struct Storyboard {
        static let DoneAddingCharacterIdentifier = "doneAddingCharacter"
        static let EditDanceMoveIdentifier = "editDanceMove"
        static let DanceIdentifier = "dance"
        static let RedrawCharacterIdentifier = "redrawCharacter"
        static let RepositionSkeletonIdentifier = "repositionSkeleton"
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
    
    // MARK: - Navigation
    
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
            destVC.characterSkin = currentCharacterImage
            destVC.editingCharacter = character

            
        default:
            break
        }
    }
    
    @IBAction func unwindToCharactersController(segue: UIStoryboardSegue) {
        print("CharactersController unwindToCharactersController")
    }

    
    


}

extension CharactersController: iCarouselDataSource, iCarouselDelegate {

    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return characters?.count ?? 0
    }
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var itemView: UIImageView
        if (view == nil)
        {
            let size = carousel.bounds.height - 100
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:size, height:size))
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
        nameLabel.text = characters?[carousel.currentItemIndex].name ?? ""

    }
}
