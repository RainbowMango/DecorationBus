//
//  ManagerTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15/12/29.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class ManagerCellData {
    var id: UInt
    var name: String
    var avatar: String
    var companyName: String
    var commentsNum: UInt
    var score: UInt
    
    init() {
        avatar = String()
        name = String()
        companyName = String()
        commentsNum = 0
        score = 0
        id = 0
    }
}

class ManagerTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var commentsNum: UILabel!
    @IBOutlet weak var scoreChart: MDRadialProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
