//
//  SegmentCategoryTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15-1-26.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class SegmentCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel_: UILabel!
    @IBOutlet weak var moneyLable_: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
