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

let REG_SUCCESS = 0
let REG_FAILED  = 1

class RegistAck {
    var status: Int
    var info  : String
    var userID: String
    
    init() {
        status = REG_FAILED
        info   = String()
        userID = String()
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
    
    let userInfoPathInSandbox = "userinfo";
    
    func isLogin() -> Bool {
        if let userid = UserDefaultHandler().getStringConf(USER_DEFAULT_KEY_LOGIN_USER_ID) {
            return true
        }
        
        return false
    }
    
    //从user default文件读取 user ID
    func getUserIDFromConf() -> String {
        if let userid = UserDefaultHandler().getStringConf(USER_DEFAULT_KEY_LOGIN_USER_ID) {
            return userid
        }
        
        return String()
    }
    
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
    
    func parseRegAck(jsonData: NSData) -> RegistAck {
        let ack = RegistAck()
        
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            ack.status = jsonStr.objectForKey("status") as! Int
            ack.info   = jsonStr.objectForKey("info")   as! String
            ack.userID = jsonStr.objectForKey("userID") as! String
            
            return ack
        }catch let error as NSError {
            print("解析JSON数据失败: parseRegAck" + error.localizedDescription)
        }
        
        return ack
    }
    
    //保存用户头像到沙盒
    func saveUserAvatarToSandBox(imageName: String, image: UIImage) -> Bool {
        let docDir       = SandboxHandler().getDocumentDirectory()
        let userInfoPath = docDir + "/" + self.userInfoPathInSandbox
        let userAvatar   = userInfoPath + "/" + imageName
        
        guard SandboxHandler().createDirectory(userInfoPath) else {
            print("保存用户头像\(imageName)到沙盒失败, 创建目录失败: \(userInfoPath)")
            return false
        }
        
        let jpegData = UIImageJPEGRepresentation(image, 0.01)
        guard jpegData != nil else {
            print("保存用户头像\(imageName)到沙盒失败, 图片转化到JPEG失败")
            return false
        }
        
        guard jpegData!.writeToFile(userAvatar, atomically: true) else {
            print("保存用户头像\(imageName)到沙盒失败, 写入失败")
            return false
        }
        
        print("保存用户头像成功: \(userAvatar)")
        
        return true
    }
    
    //从沙盒中获取用户头像
    func getAvatarFromSandbox(imageName: String) -> UIImage? {
        let docDir       = SandboxHandler().getDocumentDirectory()
        let userInfoPath = docDir + "/" + self.userInfoPathInSandbox
        let userAvatar   = userInfoPath + "/" + imageName
        
        guard NSFileManager().fileExistsAtPath(userAvatar) else {
            print("用户头像不存在: \(userAvatar)")
            return nil
        }
        
        return UIImage(contentsOfFile: userAvatar)
    }
    
}
