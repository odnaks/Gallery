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

class GalleryCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = inserts
        layout.minimumLineSpacing = inserts * 2
        collectionView.collectionViewLayout = layout
        
        
        let lpgr = UILongPressGestureRecognizer(target: self,
                                    action:#selector(self.handleLongPress))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.view.addGestureRecognizer(lpgr)
    }

//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Helpers

    func calculateCellWidth(for collectionView: UICollectionView, section: Int) -> CGFloat {
        var width = collectionView.frame.width
        let contentInset = collectionView.contentInset
        width = width - contentInset.left - contentInset.right

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
    
   @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
//    print("state:")
//    print(gestureRecognizer.state.rawValue)
    if gestureRecognizer.state != UIGestureRecognizer.State.began {
           return
       }

    let p = gestureRecognizer.location(in: self.collectionView)
    let indexPath = self.collectionView.indexPathForItem(at: p)

       if let index = indexPath {
        var cell = self.collectionView.cellForItem(at: index)
           // do stuff with your cell, for example print the indexPath
            print(index.row)
       } else {
           print("Could not find index path")
       }

    let alert = UIAlertController(title: "Удалить", message: "Вы уверены, что хотите удалить фотографию?", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "Да", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Нет", style: .destructive, handler: nil))

    self.present(alert, animated: true)
    
    }
    
    
}

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthView = Int(collectionView.frame.width)
        let widthCell = widthView / countPhotoInRow - Int(inserts) * 2
        
        return CGSize(width: widthCell, height: widthCell)
    }
}
