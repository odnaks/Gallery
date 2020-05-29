//
//  ViewController.swift
//  gallery
//
//  Created by 18450686 on 27.05.2020.
//  Copyright © 2020 Ksenia Lukoshkina. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

class ImageInDelailViewController: UIViewController {
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageinGallery: ImageInGallery?
    
    private func setMinZoomScaleForImageSize(_ imageSize: CGSize) {
        let widthScale = view.frame.width / imageSize.width
        let heightScale = view.frame.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        imageScrollView.minimumZoomScale = minScale
        imageScrollView.zoomScale = minScale
        imageScrollView.delegate = self as UIScrollViewDelegate
        imageScrollView.bounds = self.view.bounds
        
        let imageWidth = imageSize.width * minScale
        let imageHeight = imageSize.height * minScale
        let newImageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageView.frame = newImageFrame
        
        centerImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        guard let image = imageinGallery, let url = image.url else {return}
        self.imageView.kf.setImage(with: URL(string: url))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imageScrollView.delegate = self as UIScrollViewDelegate
        guard let image = imageinGallery, let width = image.width,
            let height = image.height else {return}
        self.setMinZoomScaleForImageSize(CGSize(width: width, height: height))
    }
    
    private func centerImage() {
        let imageViewSize = imageView.frame.size //view.frame.size
        let scrollViewSize = view.frame.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}

extension ImageInDelailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
