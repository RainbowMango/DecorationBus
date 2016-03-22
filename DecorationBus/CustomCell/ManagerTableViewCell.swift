//
//  ManagerTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15/12/29.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit
import MDRadialProgress

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
    
    func configureViews(data: ManagerCellData) -> Void {
        //设置头像
        configureLogo(data.avatar)
        
        //设置名字
        configureName(data.name)
        
        //设置公司
        configureCompany(data.companyName)
        
        //设置评价数
        configureCommentsNum(data.commentsNum)
        
        //设置评价图表
        configureScoreChart(data.score)
    }
    
    func configureLogo(imagePath: String) -> Void {
        //使用SDWebImage可以自动缓存图片，浏览更流畅
        let url = NSURL(string: imagePath)
        self.avatar.sd_setImageWithURL(url, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
    }
    
    func configureName(name: String) -> Void {
        self.name.text = name
    }
    
    func configureCompany(company: String) -> Void {
        self.company.text = "所属公司: \(company)"
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
