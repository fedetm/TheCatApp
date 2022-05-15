//
//  BreedCollectionViewController.swift
//  TheCatApp
//
//  Created by Federico Torres on 14/05/22.
//

import UIKit

private let reuseIdentifier = "BreedCell"

class BreedCollectionViewController: UICollectionViewController {

    var breeds = [Breed]()
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(UINib(nibName: "BreedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        Task.init {
            do {
                let breeds = try await BreedController.shared.fetchBreeds()
                updateUI(with: breeds)
            } catch {
                print(error)
                displayError(error, title: "Failed to Fetch Breeds")
            }
        }

        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }
    
    func updateUI(with breeds: [Breed]) {
        self.breeds = breeds
        self.collectionView.reloadData()
    }
    
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let padding: CGFloat = 20
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(padding)
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: padding,
            bottom: 0,
            trailing: padding
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = padding
        section.contentInsets = NSDirectionalEdgeInsets(
            top: padding,
            leading: 0,
            bottom: padding,
            trailing: 0
        )
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breeds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BreedCollectionViewCell
    
        configureCell(cell, forBreedAt: indexPath)
    
        return cell
    }
    
    func configureCell(_ cell: BreedCollectionViewCell, forBreedAt indexPath: IndexPath) {
        let breed = breeds[indexPath.row]
        
        cell.imageView.image = UIImage(systemName: "photo.on.rectangle")
        cell.breadName.text = breed.name.capitalized
        
        imageLoadTasks[indexPath] = Task.init {
            guard let url = breed.image?.url else { return }
            if let image = try? await
                BreedController.shared.fetchImage(from: (url)) {
                if let currentIndexPath = self.collectionView.indexPath(for: cell),
                   currentIndexPath == indexPath {
                        cell.imageView.image = image
                        cell.breadName.text = breed.name.capitalized
                    }
                }
            imageLoadTasks[indexPath] = nil
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
