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
private let countPages: Int = 5

class GalleryCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    let imageService = ImageService()
    var images = [ImageInGallery]()
    var dictIdImage = [Int: Data?]() // for caching
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            for i in 1...countPages {
                self?.imageService.getPhotos(page: i) { [weak self] images in
                    self?.images += images
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
        setupView()
        setupGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Helpers
    
    func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = inserts
        layout.minimumLineSpacing = inserts * 2
        collectionView.collectionViewLayout = layout
    }
    
    func setupGestureRecognizer() {
        let lpgr = UILongPressGestureRecognizer(target: self,
                                                action:#selector(self.handleLongPress))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.view.addGestureRecognizer(lpgr)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MiniPhotoCell else {return cell}
        guard let id = images[indexPath.row].id else {return cell}
        if let imageData = dictIdImage[id] {
            photoCell.photoImageView.image = UIImage(data: imageData!)
        }
        else {
            guard let imageLink = images[indexPath.row].url else {return cell}
            photoCell.photoImageView.kf.setImage(with: URL(string: imageLink))
            if let image = photoCell.photoImageView.image {
                DispatchQueue.global(qos: .background).async { [weak self] in
                    let imageData = image.jpegData(compressionQuality: 0.1) //resize(image)
                    self?.dictIdImage[id] = imageData
                }
            }
        }
        photoCell.cape.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0)
        return photoCell
    }
    
    // MARK: Pressure handling
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == UIGestureRecognizer.State.began else { return }
        
        let point = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let index = indexPath {
            let cell = self.collectionView.cellForItem(at: index) as! MiniPhotoCell
            cell.cape.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4)
            let alert = UIAlertController(title: "Удалить", message: "Вы уверены, что хотите удалить фотографию?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Да", style: .default, handler:{
                [index, weak collectionView, weak self] action in
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            ImageInDelailViewController, let index =
            collectionView.indexPathsForSelectedItems?.first {
            destination.imageinGallery = images[index.row]
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
//
