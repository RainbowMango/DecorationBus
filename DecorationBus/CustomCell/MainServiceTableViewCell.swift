//
//  MainServiceTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15/10/30.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class MainServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
