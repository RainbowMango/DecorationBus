//
//  UserInfoTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 16/1/10.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class UserInfo {
    var userid   : String {//用户ID：YYYYMMDDHHMMSSMS
        didSet {
            self.registed = true
        }
    }
    var nickname : String
    var avatar   : String
    var passwd   : String
    var email    : String
    var phone    : String
    var realname : String
    var sex      : String
    var job      : String
    var address  : String
    var registed : Bool
    
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
        registed = false
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
        let url = NSURL(string: imagePath)
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

class UserDataHandler {
    func parseJsonData(jsonData: NSData) -> Array<UserInfo> {
        var userInfoArray = Array<UserInfo>()
        
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            let itemNum = jsonStr.objectForKey("total") as! Int
            let items = jsonStr.objectForKey("row") as! NSArray
            
            for item in items {
                let userInfo = UserInfo()
                userInfo.userid   = item.objectForKey("userid") as! String
                userInfo.nickname = item.objectForKey("nickname") as! String
                userInfo.avatar   = item.objectForKey("avatar") as! String
                userInfo.email    = item.objectForKey("email") as! String
                userInfo.phone    = item.objectForKey("phone") as! String
                userInfo.realname = item.objectForKey("realName") as! String
                userInfo.sex      = item.objectForKey("sex") as! String
                userInfo.job      = item.objectForKey("job") as! String
                userInfo.address  = item.objectForKey("address") as! String
                
                userInfoArray.append(userInfo)
            }
            
            //服务端返回的JSON有误时仅打印一条信息
            if(itemNum != userInfoArray.count) {
                print("Warning: items number mismatch in json!")
            }
            
            return userInfoArray
        }catch let error as NSError {
            print("解析JSON数据失败: " + error.localizedDescription)
        }
        
        return userInfoArray
    }
}
