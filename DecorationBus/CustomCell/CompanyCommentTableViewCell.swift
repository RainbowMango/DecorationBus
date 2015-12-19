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
    var images   : Array<String>
    
    init() {
        avatar   = String()
        nickname = String()
        date     = String()
        comment  = String()
        score    = 0
        images   = Array<String>()
    }
}

var j = 0
class CompanyCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var scoreChart: MDRadialProgressView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var imageSection: UIView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
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
        configureComment(data.comment)
        
        //设置分数
        configureScore(data.score)
        
        //设置图片
        configureImages(data.images)
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
    
    func configureComment(comment: String) -> Void {
        self.comment.text = comment
    }
    
    func configureScore(score: UInt) -> Void {
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
    
    func configureImages(var images: Array<String>) -> Void {
//        if(i % 2 == 0) {
//            let imageURL = NSURL(string: "http://decorationbus.sinaapp.com/server/images/banner/ser01.jpg")
//            self.image1.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
//        }
        j++
        images.append("http://decorationbus.sinaapp.com/server/images/banner/ser01.jpg")
        images.append("http://decorationbus.sinaapp.com/server/images/banner/ser02.jpg")
        images.append("http://decorationbus.sinaapp.com/server/images/banner/ser03.jpg")
        images.append("http://decorationbus.sinaapp.com/server/images/banner/ser04.jpg")
        if(j % 2 == 0) {
            return
        }
        for(var i = 0; i < images.count; i++) {
            let imageURL = NSURL(string: images[i])
            let imageView = self.imageSection.subviews[i].subviews[0] as! UIImageView
            imageView.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
        }
        return
        //如果没有图片则隐藏图片区
        if(images.isEmpty) {
            //self.imageSection.hidden = true
            //self.imageSection.frame = CGRect.zero
        }
        
        if(images.count > 0) {
            let imageURL = NSURL(string: images[0])
            self.image1.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
        }
        
        if(images.count > 1) {
            let imageURL = NSURL(string: images[1])
            self.image2.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
        }
        
        if(images.count > 2) {
            let imageURL = NSURL(string: images[2])
            self.image2.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
        }
        
        
        if(images.count > 3) {
            let imageURL = NSURL(string: images[3])
            self.image2.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
        }
    }
}
