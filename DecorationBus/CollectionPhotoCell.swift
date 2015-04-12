//
//  CollectionPhotoCell.swift
//  DecorationBus
//
//  Created by ruby on 15-4-12.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class CollectionPhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImageView.image = nil
    }
}
