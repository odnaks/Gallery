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
        photoCell.cape.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0)
        print("cell")
        return photoCell
    }
    
   @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
//    print("state:")
//    print(gestureRecognizer.state.rawValue)
    guard gestureRecognizer.state == UIGestureRecognizer.State.began else { return }

    let p = gestureRecognizer.location(in: self.collectionView)
    let indexPath = self.collectionView.indexPathForItem(at: p)

       if let index = indexPath {
        let cell = self.collectionView.cellForItem(at: index) as! MiniPhotoCell
        cell.cape.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.3)
//        collectionView.reloadItems(at: [index])
            print(index.row)
            let alert = UIAlertController(title: "Удалить", message: "Вы уверены, что хотите удалить фотографию?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Да", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Нет", style: .destructive, handler:
                { [index, weak collectionView] action in
                collectionView?.reloadItems(at: [index])
            }))

            self.present(alert, animated: true)
        
       } else {
           print("Could not find index path")
       }

    
    }
    
    
}

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthView = Int(collectionView.frame.width)
        let widthCell = widthView / countPhotoInRow - Int(inserts) * 2
        
        return CGSize(width: widthCell, height: widthCell)
    }
}
