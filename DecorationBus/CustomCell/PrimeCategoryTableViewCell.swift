//
//  PrimeCategoryTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15-1-13.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class PrimeCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var launchIndicatorImageView_: UIImageView!
    @IBOutlet weak var primeCategoryImageView_: UIImageView!
    @IBOutlet weak var categoryLabel_: UILabel!
    @IBOutlet weak var budgetSumLabel_: UILabel!
    @IBOutlet weak var spendSumLabel_: UILabel!
    @IBOutlet weak var remainSumLabel_: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
