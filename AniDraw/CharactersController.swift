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
    private var curentCharacter: CharacterStorage? {
        return characters?[carousel.currentItemIndex]
    }
    @IBOutlet weak var carousel: iCarousel!

    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .CoverFlow2
        carousel.bounceDistance = 0.1
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        characters = CharacterStorage.allCharacters()
        carousel.reloadData()
        carousel.currentItemIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private struct Storyboard {
        static let DoneAddingCharacterIdentifier = "doneAddingCharacter"
    }
    
   

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let ident = segue.identifier else{
            return
        }
        switch ident {
        case "dance":
            if let destVC = segue.destinationViewController as? AnimationController {
                if let character = curentCharacter {
                    destVC.characterNode = CharacterNode(character: character)
                }
            }
        default:
            break
        }
    }
    
    @IBAction func unwindToCharactersController(segue: UIStoryboardSegue) {
        //        if let identifier = segue.identifier where identifier == Storyboard.DoneAddingCharacterIdentifier {
        //            displayCharacter()
        //
        //        }
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
}
