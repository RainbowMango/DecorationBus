//
//  CompanyTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15/11/22.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class CompanyCellData {
    var id: UInt
    var name: String
    var logoPath: String
    var commentsNum: UInt
    var score: UInt
    
    init() {
        logoPath = String()
        name = String()
        commentsNum = 0
        score = 0
        id = 0
    }
}

class CompanyTableViewCell: UITableViewCell {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
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

    func configureViews(data: CompanyCellData) -> Void {
        //设置公司logo
        configureLogo(data.logoPath)
        
        //设置公司名字
        configureName(data.name)
        
        //设置评价数
        configureCommentsNum(data.commentsNum)
        
        //设置评价图表
        configureScoreChart(data.score)
    }
    
    func configureLogo(imagePath: String) -> Void {
        //使用SDWebImage可以自动缓存图片，浏览更流畅
        let url = NSURL(string: imagePath)
        self.logo.sd_setImageWithURL(url, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
    }
    
    func configureName(name: String) -> Void {
        self.name.text = name
    }
    
    func configureCommentsNum(num: UInt) -> Void {
        self.commentsNum.text = "评价数: \(num)"
    }
    
    func configureScoreChart(score: UInt) -> Void {
        self.scoreChart.theme = ColorScheme().getScoreChartTheme()
        self.scoreChart.progressTotal = 100
        self.scoreChart.progressCounter = score
    }
}
