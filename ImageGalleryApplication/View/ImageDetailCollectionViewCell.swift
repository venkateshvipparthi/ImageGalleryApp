//
//  ImageDetailCollectionViewCell.swift
//  ImageGalleryApplication
//
//  Created by Admin on 03/05/2022.
//

import UIKit

class ImageDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgDesc: UILabel!
    @IBOutlet weak var imageCollectionCell: UIImageView!
    
    override func prepareForReuse() {
        self.imageCollectionCell.image = nil
    }
    
    func setData(_ photoDetail: ImageDetail) {
        imgDesc.text = photoDetail.title
    }
}
