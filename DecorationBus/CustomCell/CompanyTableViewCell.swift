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
        //检查本地是否有缓存
        
        //下载图片
        let url = NSURL(string: imagePath)
        let request = NSURLRequest(URL: url!)
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            self.logo.image = UIImage(data: data)
        }catch let error as NSError {
            print("网络异常，下载图片失败: " + error.localizedDescription)
            self.logo.image = UIImage(named: "companyDefaultLogo.png")
        }
    }
    
    func configureName(name: String) -> Void {
        self.name.text = name
    }
    
    func configureCommentsNum(num: UInt) -> Void {
        self.commentsNum.text = "评价数: \(num)"
    }
    
    func configureScoreChart(score: UInt) -> Void {
        //自定义主题
        let newTheme = MDRadialProgressTheme()
        newTheme.completedColor = UIColor.greenColor()
        newTheme.incompletedColor = UIColor.grayColor()
        newTheme.centerColor = UIColor.clearColor()
        newTheme.sliceDividerHidden = true
        newTheme.labelColor = UIColor.blackColor()
        newTheme.labelShadowColor = UIColor.whiteColor()
        
        self.scoreChart.theme = newTheme
        self.scoreChart.progressTotal = 100
        self.scoreChart.progressCounter = score
    }
}
