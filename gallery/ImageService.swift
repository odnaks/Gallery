//
//  ImageService.swift
//  gallery
//
//  Created by Ksenia on 28.05.2020.
//  Copyright © 2020 Ksenia Lukoshkina. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ImageService {
    func getPhotos(page: Int, completion: @escaping ([ImageInGallery]) -> Void){
            let baseUrl = "https://picsum.photos/v2"
                    let path = "/list"
                    let parameters: Parameters = [
                        "page": String(page),
                        "limit": "10"
                    ]
                    let url = baseUrl+path
                    AF.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
                        switch repsonse.result {
                            case let .success(data):
                                let json = JSON(data)
                                var images:[ImageInGallery] = []
                                for item in json {
                                    let id: Int = item.1["id"].intValue
                                    let url: String = item.1["download_url"].stringValue
                                    let he: Int = item.1["height"].intValue
                                    let wi: Int = item.1["width"].intValue
                                    images.append(ImageInGallery(id: id, url: url, width: wi, height: he))
                                    
                                }
                                completion(images)
                            case .failure(_):
                                print ("error request")
                        }
            }
        }
}
