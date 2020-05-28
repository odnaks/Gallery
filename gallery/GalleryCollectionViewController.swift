//
//  GalleryCollectionViewController.swift
//  gallery
//
//  Created by 18450686 on 28.05.2020.
//  Copyright © 2020 Ksenia Lukoshkina. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let inserts: CGFloat = 2
private let countPhotoInRow: Int = 4

class GalleryCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = inserts
        layout.minimumLineSpacing = inserts * 2
        collectionView.collectionViewLayout = layout
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Helpers

    func calculateCellWidth(for collectionView: UICollectionView, section: Int) -> CGFloat {
        var width = collectionView.frame.width
        let contentInset = collectionView.contentInset
        width = width - contentInset.left - contentInset.right

        // Uncomment the following two lines if you're adjusting section insets
        // let sectionInset = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, insetForSectionAt: section)
        // width = width - sectionInset.left - sectionInset.right

        // Uncomment if you are using the sectionInset property on flow layouts
        // let sectionInset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? UIEdgeInsets.zero
        // width = width - sectionInset.left - sectionInset.right

        return width
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 100
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MiniPhotoCell else {return cell}
        photoCell.photoImageView.image = UIImage(named: "graph")
//        photoCell.frame = CGRect(x: photoCell.frame.origin.x, y: photoCell.frame.origin.y, width: 80, height: 80)

        print("cell")
        return photoCell
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

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthView = Int(collectionView.frame.width)
        let widthCell = widthView / countPhotoInRow - Int(inserts) * 2
        
        return CGSize(width: widthCell, height: widthCell)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: calculateCellWidth(for: collectionView, section: indexPath.section), height: 60)
//    }

}
