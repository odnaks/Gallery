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



struct myStr {
    var url: String
    var wid: Int
    var hei: Int
    
    init(url: String, wid: Int, hei: Int) {
        self.url = url
        self.wid = wid
        self.hei = hei
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
//    var zoomImage = UIImage(named: "graph")
    
    
    func getPhotos(completion: @escaping ([myStr]) -> Void){
        let baseUrl = "https://picsum.photos/v2"      //"https://api.vk.com/method"
                let path = "/list"  //"/friends.get"
                let parameters: Parameters = [
                    "page": "1",
                    "limit": "1"
                ]
                // https://api.vk.com/method/friends.get?access_token=1ea08d690aa26a541771c17b304c1be12c79e522e13d0575b0c623c728f8d51679af9ab6f2c65edaa8438&user_id=566604693&v=5.00
                let url = baseUrl+path
                
                AF.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
                    switch repsonse.result {
                        case let .success(data):
                            let json = JSON(data)
        //                    var users:[User] = []
                            var urls:[myStr] = []
                            for item in json {
                
                                let id: Int = item.1["id"].intValue
                                let url: String = item.1["download_url"].stringValue
                                let he: Int = item.1["height"].intValue
                                let wi: Int = item.1["width"].intValue
//                                self.image1?.kf.setImage(with: URL(string: url))
//                                self.imageviewM = self.image1
        //                        let strUrl: String = item.1["photo_200_orig"].stringValue
        //                        let firstName: String = item.1["first_name"].stringValue
        //                        let lastName: String = item.1["last_name"].stringValue
        //                        let id: String = item.1["id"].stringValue
        //                        users.append(User(photoLink: strUrl, firstName: firstName, lastName: lastName, id: id))
                                var st = myStr(url: url, wid: wi, hei: he)
        
                                urls.append(st)
//                                print(id)
//                                print("==========")
                                
                            }
                            completion(urls)
                        case .failure(_):
                            print ("error request")
                    }
        }
    }

    private func setMinZoomScaleForImageSize(_ imageSize: CGSize) {
        let widthScale = view.frame.width / imageSize.width
        let heightScale = view.frame.height / imageSize.height
        let minScale = min(widthScale, heightScale)

        // Scale the image down to fit in the view
        imageScrollView.minimumZoomScale = minScale
        imageScrollView.zoomScale = minScale
        imageScrollView.delegate = self as? UIScrollViewDelegate
        imageScrollView.bounds = self.view.bounds
        
        // Set the image frame size after scaling down
        let imageWidth = imageSize.width * minScale
        let imageHeight = imageSize.height * minScale
        let newImageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageView.frame = newImageFrame

        centerImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var urls: [String] = []
        getPhotos{ [weak self] urls in
            print(urls[0])
            let url = urls[0].url
            let width = urls[0].wid
            let height = urls[0].hei
            self?.imageView.kf.setImage(with: URL(string: url))
            self?.setMinZoomScaleForImageSize(CGSize(width: width, height: height))
        }
        
//        imageviewM = image1
//        imageView.image = zoomImage
        // Do any additional setup after loading the view.
    }

    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        imageScrollView.bounds = self.view.bounds
//        imageScrollView.minimumZoomScale = 0.1
//        imageScrollView.maximumZoomScale = 4.0
//        imageScrollView.zoomScale = 1.0
        
        imageScrollView.delegate = self as? UIScrollViewDelegate
    }
        
//        let widthScale = view.frame.width / imageView.bounds.width
//        let heightScale = view.frame.height / imageView.bounds.height
//        let minScale = min(widthScale, heightScale)
//        imageScrollView.minimumZoomScale = minScale
        
//        imageScrollView.contentInset.left = 0
//        imageScrollView.contentInset.right = 0
        
        
//        let ratio = zoomImage.bounds.
//        let ratio = zoomImage.size.width / zoomImage.size.height
//        let newHeight = view.frame.width / ratio
//        constraintHeight.constant = newHeight
//        view.layoutIfNeeded()
//
    
    
    private func centerImage() {
        print("centerImage")
        let imageViewSize = imageView.frame.size//view.frame.size
        let scrollViewSize = view.frame.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

//        print(verticalPadding)
//        print(horizontalPadding)
        imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
//
//    private func zoomRectangle(scale: CGFloat, center: CGPoint) -> CGRect {
//        var zoomRect = CGRect.zero
//        zoomRect.size.height = imageView.frame.size.height / scale
//        zoomRect.size.width  = imageView.frame.size.width  / scale
//        zoomRect.origin.x = center.x - (center.x * imageScrollView.zoomScale)
//        zoomRect.origin.y = center.y - (center.y * imageScrollView.zoomScale)
//
//        return zoomRect
//    }
//
//    @IBAction func doubleTapImage(_ sender: UITapGestureRecognizer) {
//
//        print("taptap")
//        if imageScrollView.zoomScale == imageScrollView.minimumZoomScale {
//            imageScrollView.zoom(to: zoomRectangle(scale: imageScrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
//        } else {
//            imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
//        }
//    }

}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("1")
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("2")
        centerImage()
    }
}
