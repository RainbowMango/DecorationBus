//
//  UserInfoTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 16/1/10.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit
import Alamofire

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
    
    /*
    * 用户头像统一使用本地存储头像，如使用网络头像响应应使用NSURL(string: <#T##String#>)
    */
    func configureLogo(imagePath: String) -> Void {
        let url = NSURL(fileURLWithPath: imagePath, isDirectory: false)
        self.avatar.sd_setImageWithURL(url, placeholderImage: UIImage(named: "userDefaultAvatar"))
        //print("configureLogo：\(imagePath)")
        
        //设置头像圆角
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.cornerRadius  = self.avatar.frame.width / 2.0 //设置为图片宽度的一半出来为圆形
        self.avatar.layer.borderColor   = UIColor.whiteColor().CGColor
        self.avatar.layer.borderWidth   = 3.0
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

// MARK: - 用户类相关通知
public let USER_INFO_UPDATED = "UserInfomationUpdated"

class UserDataHandler {
    
    let userInfoPathInSandbox = "userinfo";
    
    //user default中字典key定义
    let UDH_USER_ID            = "userid"
    let UDH_NICK_NAME          = "nickname"
    let UDH_PHONE_NUMBER       = "phonenumber"
    let UDH_AVATAR_SANDBOX_URL = "sandboxavatarurl"
    let UDH_USER_SEX           = "usersex"
    
    func isLogin() -> Bool {
        if nil != UserDefaultHandler().getDictionaryForKey(USER_DEFAULT_KEY_USER_INFO) {
            return true
        }
        
        return false
    }
    
    func getUserInfoFromConf() -> UserInfo {
        let userInfo = UserInfo.sharedUserInfo
        let userConf = UserDefaultHandler().getDictionaryForKey(USER_DEFAULT_KEY_USER_INFO)
        
        if nil == userConf {
            print("Warning: getUserInfoFromConf(), No user info in conf!")
            return userInfo
        }
        
        userInfo.userid   = userConf![UDH_USER_ID]            as! String
        userInfo.nickname = userConf![UDH_NICK_NAME]          as! String
        userInfo.phone    = userConf![UDH_PHONE_NUMBER]       as! String
        userInfo.avatar   = userConf![UDH_AVATAR_SANDBOX_URL] as! String
        userInfo.sex      = userConf![UDH_USER_SEX]           as! String
        
        return userInfo
    }
    
    //从user default文件读取 user ID
    func getUserIDFromConf() -> String {
        let user = getUserInfoFromConf()
        
        return user.userid
    }
    
    func parseJsonData(jsonData: NSData) -> Array<UserInfo> {
        var userInfoArray = Array<UserInfo>()
        
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            let itemNum = jsonStr.objectForKey("total") as! Int
            let items = jsonStr.objectForKey("row") as! NSArray
            
            for item in items {
                let userInfo = UserInfo.sharedUserInfo
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
    
    /*
    * 从服务器缓存头像到本地
    * 使用场景：老用户退出登录后再次登录， 老用户删除应用再次安装应用并登录，老用户在新设备上登录
    */
    func syncAvatarFromRemoteToSandBox(remoteURL: String, phoneNumber: String) -> Bool {
        let url  = NSURL(string: remoteURL)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        
        return saveAvatarToSandBox(phoneNumber, image: image!)
    }
    
    //保存用户头像到沙盒
    func saveAvatarToSandBox(phoneNumber: String, image: UIImage) -> Bool {
        let docDir       = SandboxHandler().getDocumentDirectory()
        let userInfoPath = docDir + "/" + self.userInfoPathInSandbox
        let userAvatar   = userInfoPath + "/" + phoneNumber + ".png"
        
        guard SandboxHandler().createDirectory(userInfoPath) else {
            print("保存用户头像\(phoneNumber)到沙盒失败, 创建目录失败: \(userInfoPath)")
            return false
        }
        
        //缩放图片
        let scaledImage = ImageHandler().aspectSacleSize(image, targetSize: CGSizeMake(320.0, 320.0))
        
        let jpegData = UIImageJPEGRepresentation(scaledImage, 1)
        guard jpegData != nil else {
            print("保存用户头像\(phoneNumber)到沙盒失败, 图片转化到JPEG失败")
            return false
        }
        
        guard jpegData!.writeToFile(userAvatar, atomically: true) else {
            print("保存用户头像\(phoneNumber)到沙盒失败, 写入失败")
            return false
        }
        
        //print("保存用户头像成功: \(userAvatar)")
        
        return true
    }
    
    func removeAvatarFromSandbox(phoneNumber: String) -> Bool {
        let docDir       = SandboxHandler().getDocumentDirectory()
        let userInfoPath = docDir + "/" + self.userInfoPathInSandbox
        let userAvatar   = userInfoPath + "/" + phoneNumber + ".png"
        
        guard NSFileManager().fileExistsAtPath(userAvatar) else {
            print("removeAvatarFromSandbox(): No user avatar found! \(userAvatar)")
            return true
        }
        do {
            try NSFileManager().removeItemAtPath(userAvatar)
        }
        catch let error as NSError {
            print("removeAvatarFromSandbox(): Remove user avatar failed! \(userAvatar), \(error.localizedDescription)")
            return false
        }
        
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
    
    /*
    * 取得用户头像在沙盒中的位置
    */
    func getAvatarSandboxURL(phoneNumber: String) -> String? {
        let docDir       = SandboxHandler().getDocumentDirectory()
        let userInfoPath = docDir + "/" + self.userInfoPathInSandbox
        let userAvatar   = userInfoPath + "/" + phoneNumber + ".png"
        
        guard NSFileManager().fileExistsAtPath(userAvatar) else {
            print("Warning: getAvatarURL() 用户\(phoneNumber)头像不存在")
            return nil
        }
        
        return userAvatar
    }
    
    /**
     保存用户信息到沙盒
     
     - parameter info: 用户信息对象
     
     - returns: bool
     */
    func saveUserInfoToConf(info: UserInfo) -> Bool {
        var userConf = Dictionary<String, String>()
        
        guard !info.userid.isEmpty else {
            print("Warning: saveUserInfoToConf() user id is empty!")
            return false
        }
        userConf[UDH_USER_ID] = info.userid
        
        guard !info.nickname.isEmpty else {
            print("Warning: saveUserInfoToConf() nick name is empty!")
            return false
        }
        userConf[UDH_NICK_NAME] = info.nickname
        
        guard !info.phone.isEmpty else {
            print("Warning: saveUserInfoToConf() phone number is empty!")
            return false
        }
        userConf[UDH_PHONE_NUMBER] = info.phone
        
        guard !info.sex.isEmpty else {
            print("Warning: saveUserInfoToConf() user sex is empty!")
            return false
        }
        userConf[UDH_USER_SEX] = info.sex
      
        let avatar = getAvatarSandboxURL(info.phone)
        guard (avatar != nil) else {
            print("Warning: saveUserInfoToConf() Can't get avatar path in sandbox!")
            return false
        }
        userConf[UDH_AVATAR_SANDBOX_URL] = avatar
        
        UserDefaultHandler().setObjectForKey(userConf, key: USER_DEFAULT_KEY_USER_INFO)
        
        return true
    }
    
    /*
    * 删除本地用户信息，同时删除本地缓存的头像，用于退出登录
    */
    func removeUserInfoFromConf() -> Void {
        let userConfDic = UserDefaultHandler().getDictionaryForKey(USER_DEFAULT_KEY_USER_INFO)
        guard userConfDic != nil else {
            return
        }
        
        removeAvatarFromSandbox(userConfDic![UDH_PHONE_NUMBER] as! String)
        UserDefaultHandler().removeObjectForKey(USER_DEFAULT_KEY_USER_INFO)
    }
}
