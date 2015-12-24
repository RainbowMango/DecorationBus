//
//  ArtistTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15/12/24.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class ArtistCellData {
    var id: UInt
    var name: String
    var avatar: String
    var commentsNum: UInt
    var score: UInt
    
    init() {
        avatar = String()
        name = String()
        commentsNum = 0
        score = 0
        id = 0
    }
}

class ArtistTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
