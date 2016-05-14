//
//  ImageCollectionViewCell.swift
//  DecorationBus
//
//  Created by ruby on 16/3/24.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "ImageCollectionViewCell"
    
    //static let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
    
    func configure(imageName: String) {
        //let image = UIImage(named: imageName)
        //imageView.image = image
        imageView.image = UIImage(named: imageName)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func configureWithImage(image: UIImage?) -> Void {
        guard image != nil else {
            print("无法配置cell，image 为nil")
            return
        }
        
        imageView.image = image
    }
}

class ImageCollectionViewCellData {
    var thumbnails  : String
    var originimages: String
    
    init() {
        thumbnails      = String()
        originimages    = String()
    }
    
    init(thumb: String, orig: String) {
        thumbnails      = thumb
        originimages    = orig
    }
}