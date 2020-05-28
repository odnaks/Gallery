//
//  imageInGallery.swift
//  gallery
//
//  Created by Ksenia on 28.05.2020.
//  Copyright © 2020 Ksenia Lukoshkina. All rights reserved.
//

import Foundation

struct ImageInGallery {
    let id: Int?
    let url: String?
    let width: Int?
    let height: Int?
    init(id: Int, url: String, width: Int, height: Int) {
        self.id = id
        self.url = url
        self.width = width
        self.height = height
    }
}
