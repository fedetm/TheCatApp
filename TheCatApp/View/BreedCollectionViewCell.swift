//
//  BreedCollectionViewCell.swift
//  TheCatApp
//
//  Created by Federico Torres on 14/05/22.
//

import UIKit
import CoreData

class BreedCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var breadName: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dislikeButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var likes: Int = 0
    var dislikes: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.masksToBounds = true
        
        updateUI()
    }
    
    func updateUI() {
        self.reloadInputViews()
    }
    
    func createInteraction(vote: Bool) {
        let newLike = VoteModel(context: context)
        newLike.name = breadName.text
        newLike.createdAt = Date()
        newLike.voteType = vote
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    @IBAction func addLike(_ sender: Any) {
        createInteraction(vote: true)
        likes += 1
        likeButton.isEnabled = false
        let fillImage = UIImage(systemName: "hand.thumbsup.fill")
        likeButton.setImage(fillImage, for: .disabled)
        dislikeButton.isEnabled = false
        updateUI()
    }
    
    @IBAction func addDislike(_ sender: Any) {
        createInteraction(vote: false)
        dislikes += 1
        dislikeButton.isEnabled = false
        let fillImage = UIImage(systemName: "hand.thumbsdown.fill")
        dislikeButton.setImage(fillImage, for: .disabled)
        likeButton.isEnabled = false
        updateUI()
    }
}
