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

class ImageInDelailViewController: UIViewController {
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    func getPhotos(completion: @escaping ([myStr]) -> Void){
        let baseUrl = "https://picsum.photos/v2"      //"https://api.vk.com/method"
                let path = "/list"  //"/friends.get"
                let parameters: Parameters = [
                    "page": "1",
                    "limit": "1"
                ]
                let url = baseUrl+path
                
                AF.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
                    switch repsonse.result {
                        case let .success(data):
                            let json = JSON(data)
                            var urls:[myStr] = []
                            for item in json {
                
                                let id: Int = item.1["id"].intValue
                                let url: String = item.1["download_url"].stringValue
                                let he: Int = item.1["height"].intValue
                                let wi: Int = item.1["width"].intValue
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

        imageScrollView.minimumZoomScale = minScale
        imageScrollView.zoomScale = minScale
        imageScrollView.delegate = self as? UIScrollViewDelegate
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
        
        getPhotos{ [weak self] urls in
            print(urls[0])
            let url = urls[0].url
            let width = urls[0].wid
            let height = urls[0].hei
            self?.imageView.kf.setImage(with: URL(string: url))
            self?.setMinZoomScaleForImageSize(CGSize(width: width, height: height))
        }
    }

    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        imageScrollView.bounds = self.view.bounds
//        imageScrollView.minimumZoomScale = 0.1
//        imageScrollView.maximumZoomScale = 4.0
//        imageScrollView.zoomScale = 1.0
        
        imageScrollView.delegate = self as? UIScrollViewDelegate
    }
        
    
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
}

extension ImageInDelailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("1")
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("2")
        centerImage()
    }
}
