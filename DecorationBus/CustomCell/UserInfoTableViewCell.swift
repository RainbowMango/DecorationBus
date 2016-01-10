//
//  UserInfoTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 16/1/10.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class UserInfo {
    var userid   : String //用户ID：YYYYMMDDHHMMSSMS
    var nickname : String
    var avatar   : String
    var passwd   : String
    var email    : String
    var phone    : String
    var realname : String
    var sex      : String
    var job      : String
    var address  : String
    
    init() {
        userid   = String()
        nickname = String()
        avatar   = String()
        passwd   = String()
        email    = String()
        phone    = String()
        realname = String()
        sex      = String()
        job      = String()
        address  = String()
    }
}

class UserInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hint: UILabel!

    let unloginHint = "您还没登录哦~"
    let loginHint   = "您的个人信息将会严格保密"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureViews(data: UserInfo) -> Void {
        //设置头像
        configureLogo(data.avatar)
        
        //设置名字
        configureName(data.nickname)
        
        //设置提示信息
        if(data.userid.isEmpty) {
            configureHint(unloginHint)
        }
        else {
            configureHint(loginHint)
        }
        
    }
    
    func configureLogo(imagePath: String) -> Void {
        //使用SDWebImage可以自动缓存图片，浏览更流畅
        let url = NSURL(string: imagePath)
        self.avatar.sd_setImageWithURL(url, placeholderImage: UIImage(named: "companyDefaultLogo.png"))
    }
    
    func configureName(name: String) -> Void {
        self.name.text = name
    }
    
    func configureHint(hint: String) -> Void {
        self.hint.text = hint
    }
}
