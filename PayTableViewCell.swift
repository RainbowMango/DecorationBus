//
//  PayTableViewCell.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-1.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class PayTableViewCell: UITableViewCell {

    @IBOutlet weak var payCellTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func payCellEditingDidEnd(sender: UITextField) {
        println("收到支出:\(payCellTextField.text), 暂时存储，待全部输入后存入数据库")
    }
    
    @IBAction func TextFieldDidEndOnExit(sender: UITextField) {
    }
}
