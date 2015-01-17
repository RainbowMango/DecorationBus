//
//  MinorCategoryTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15-1-17.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class MinorCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryLabel_: UILabel!
    @IBOutlet weak var budgetLabel_: UILabel!
    @IBOutlet weak var spendLabel_: UILabel!
    @IBOutlet weak var remainLabel_: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
