//
//  CompanyTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15/11/22.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class CompanyCellData {
    var logoPath: String
    var name: String
    var commentsNum: Int
    var score: Int
    
    init() {
        logoPath = String()
        name = String()
        commentsNum = 0
        score = 0
    }
}

class CompanyTableViewCell: UITableViewCell {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var commentsNum: UILabel!
    @IBOutlet weak var scoreChart: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureViews(data: CompanyCellData) -> Void {
        //设置公司logo
        
        //设置公司名字
        configureName(data.name)
        
        //设置评价数
        configureCommentsNum(data.commentsNum)
        
        //设置评价图表
    }
    
    func configureLogo(imagePath: String) -> Void {
        self.logo.image = UIImage(contentsOfFile: imagePath)
    }
    
    func configureName(name: String) -> Void {
        self.name.text = name
    }
    
    func configureCommentsNum(num: Int) -> Void {
        self.commentsNum.text = "评价数: \(num)"
    }
    
    func configureScoreChart(score: Int) -> Void {
        //TODO
    }
}