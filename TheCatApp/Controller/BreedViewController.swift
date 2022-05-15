//
//  BreedViewController.swift
//  TheCatApp
//
//  Created by Federico Torres on 14/05/22.
//

import UIKit

class BreedViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var breedLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    let breed: Breed

    init?(coder: NSCoder, breed: Breed) {
        self.breed = breed
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        breedLabel.text = breed.name
        descriptionLabel.text = breed.description
        
        Task.init {
            guard let url = breed.image?.url else {
                imageView.image = UIImage(systemName: "photo.on.rectangle")
                return
            }
            if let image = try? await BreedController.shared.fetchImage(from: url) {
                imageView.image = image
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
