//
//  ImageEntity.swift
//  ImageGalleryApplication
//
//  Created by Admin on 03/05/2022.
//

import Foundation

struct ImageEntity: Codable {
    let photos: Photos
    let stat: String
}


struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}


struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}
