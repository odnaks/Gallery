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
private let countPhotoInRow: Int = 3

class GalleryCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {

    let imageService = ImageService()
    var images = [ImageInGallery]()
    var dictIdImage = [Int: Data?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        for i in 1...5 {
            DispatchQueue.global().async { [weak self] in
                for i in 1...10 {
                self?.imageService.getPhotos(page: i) { [weak self] images in
                    self?.images += images
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
                }
            }
//        }
        
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
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MiniPhotoCell else {return cell}
        let id = images[indexPath.row].id
        if let imageData = dictIdImage[id] {
            photoCell.photoImageView.image = UIImage(data: imageData!)
        }
        else {
            print("new key", id)
            let imageLink = images[indexPath.row].url
            photoCell.photoImageView.kf.setImage(with: URL(string: imageLink))
            if let image = photoCell.photoImageView.image {
                DispatchQueue.global(qos: .background).async { [weak self] in
                    let imageData = image.jpegData(compressionQuality: 0.1) //resize(image)
                    self?.dictIdImage[id] = imageData
                }
            }

        }

        photoCell.cape.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0)
        print(indexPath.row)
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
        cell.cape.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4)
            print(index.row)
            let alert = UIAlertController(title: "Удалить", message: "Вы уверены, что хотите удалить фотографию?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Да", style: .default, handler:
                { [index, weak collectionView, weak self] action in
                    self?.images.remove(at: index.row)
                    collectionView?.reloadData()
                }
            ))
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


//    func resize(_ image: UIImage) -> UIImage {
//        var actualHeight = Float(image.size.height)
//        var actualWidth = Float(image.size.width)
//        let maxHeight: Float = 800.0
//        let maxWidth: Float = 800.0
//        var imgRatio: Float = actualWidth / actualHeight
//        let maxRatio: Float = maxWidth / maxHeight
//        let compressionQuality: Float = 0.5
//        //50 percent compression
//        if actualHeight > maxHeight || actualWidth > maxWidth {
//            if imgRatio < maxRatio {
//                //adjust width according to maxHeight
//                imgRatio = maxHeight / actualHeight
//                actualWidth = imgRatio * actualWidth
//                actualHeight = maxHeight
//            }
//            else if imgRatio > maxRatio {
//                //adjust height according to maxWidth
//                imgRatio = maxWidth / actualWidth
//                actualHeight = imgRatio * actualHeight
//                actualWidth = maxWidth
//            }
//            else {
//                actualHeight = maxHeight
//                actualWidth = maxWidth
//            }
//        }
//        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
//        UIGraphicsBeginImageContext(rect.size)
//        image.draw(in: rect)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
//        UIGraphicsEndImageContext()
//        return UIImage(data: imageData!) ?? UIImage()
//    }
