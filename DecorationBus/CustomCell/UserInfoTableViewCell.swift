//
//  UserInfoTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 16/1/10.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit
import Alamofire

class UserInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hint: UILabel!

    let unloginHint = "您还没登录哦~"
    let loginHint   = "您的个人信息将会严格保密"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //设置头像圆角
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.cornerRadius  = self.avatar.frame.width / 2.0 //设置为图片宽度的一半出来为圆形
        self.avatar.layer.borderColor   = UIColor.whiteColor().CGColor
        self.avatar.layer.borderWidth   = 3.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureViews(data: UserInfo) -> Void {
        //设置头像
        configureLogo(data.avatarInSandbox)
        
        //设置名字
        configureName(data.nickname)
        
        //设置提示信息
        if(!data.isLogin()) {
            configureHint(unloginHint)
        }
        else {
            configureHint(loginHint)
        }
    }
    
    /*
    * 用户头像统一使用本地存储头像，如使用网络头像响应应使用NSURL(string: <#T##String#>)
    */
    func configureLogo(imagePath: String) -> Void {
        let url = NSURL(fileURLWithPath: imagePath, isDirectory: false)
        self.avatar.sd_setImageWithURL(url, placeholderImage: UIImage(named: "userDefaultAvatar"))
    }
    
    func configureName(name: String) -> Void {
        if(name.isEmpty) {
            self.name.text = "游客"
        }
        else {
            self.name.text = name
        }
    }
    
    func configureHint(hint: String) -> Void {
        self.hint.text = hint
    }
}
