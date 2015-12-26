//
//  ArtistCommentTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 15/12/26.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class ArtistComment {
    var avatar      : String
    var nickname    : String
    var date        : String
    var comment     : String
    var score       : UInt
    var thumbnails  : Array<String>
    var originimages: Array<String>
    
    init() {
        avatar          = String()
        nickname        = String()
        date            = String()
        comment         = String()
        score           = 0
        thumbnails      = Array<String>()
        originimages    = Array<String>()
    }
}

class ArtistCommentTableViewCell: UITableViewCell {
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
    
    var imageViews = Array<UIImageView>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViews.append(self.image1)
        imageViews.append(self.image2)
        imageViews.append(self.image3)
        imageViews.append(self.image4)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureViews(data: ArtistComment) {
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
        configureImages(data.thumbnails)
    }
    
    func configureAvatar(imagePath: String) -> Void {
        let url = NSURL(string: imagePath)
        self.avatar.sd_setImageWithURL(url, placeholderImage: UIImage(named: "userDefaultAvatar"))
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
        
        //如果没有图片，清空imageview，避免cell重用残留
        if(images.isEmpty) {
            for(var i = 0; i < self.imageSection.subviews.count; i++) {
                let imageView = self.imageSection.subviews[i].subviews[0] as! UIImageView
                imageView.image = UIImage()
            }
        }
        
        for(var i = 0; i < images.count; i++) {
            let imageURL = NSURL(string: images[i])
            let imageView = self.imageSection.subviews[i].subviews[0] as! UIImageView
            imageView.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
        }
    }
    
    func removeImagesGesture() {
        for view in self.imageViews {
            
            guard let currentGestures = view.gestureRecognizers else {
                continue
            }
            for gesture in currentGestures {
                view.removeGestureRecognizer(gesture)
            }
        }
    }
    
    func configureImageGesture(index: Int, target: AnyObject?, action: Selector, tag: Int) {
        let recognizer01 = UITapGestureRecognizer(target: target, action: action)
        self.imageViews[index].tag = tag
        self.imageViews[index].addGestureRecognizer(recognizer01)
    }
}
