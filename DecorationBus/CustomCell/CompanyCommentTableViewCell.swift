//
//  CompanyCommentTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15/12/12.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class CompanyComment {
    var avatar   : String
    var nickname : String
    var date     : String
    var comment  : String
    var score    : UInt
    
    init() {
        avatar   = String()
        nickname = String()
        date     = String()
        comment  = String()
        score    = 0
    }
}

class CompanyCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureViews(data: CompanyComment) {
        //设置用户头像
        configureAvatar(data.avatar)
        
        //设置用户昵称
        configureNickname(data.nickname)
        
        //设置评论日期
        configureDate(data.date)
        
        //设置评论
        //configureComment(data.comment)
        
        //设置分数
        //configureScore(data.score)
    }
    
    func configureAvatar(imagePath: String) -> Void {
        let url = NSURL(string: imagePath)
        self.avatar.sd_setImageWithURL(url, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
    }
    
    func configureNickname(nickname: String) -> Void {
        self.nickname.text = nickname
    }
    
    func configureDate(date: String) -> Void {
        self.date.text = date
    }
    
//    func configureComment(comment: String) -> Void {
//        self.comments.text = comment
//    }
//    
//    func configureScore(score: UInt) -> Void {
//        //自定义主题
//        let newTheme = MDRadialProgressTheme()
//        newTheme.completedColor = UIColor.greenColor()
//        newTheme.incompletedColor = UIColor.grayColor()
//        newTheme.centerColor = UIColor.clearColor()
//        newTheme.sliceDividerHidden = true
//        newTheme.labelColor = UIColor.blackColor()
//        newTheme.labelShadowColor = UIColor.whiteColor()
//        
//        self.scoreChart.theme = newTheme
//        self.scoreChart.progressTotal = 100
//        self.scoreChart.progressCounter = score
//    }
}
