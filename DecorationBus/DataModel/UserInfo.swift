//
//  UserInfo.swift
//  DecorationBus
//
//  Created by ruby on 16/6/7.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation
import Alamofire

/// 用户信息单例类
class UserInfo: NSObject {
    
    private static let sharedInstance = UserInfo()
    
    //user default中字典key定义
    private let UDH_USER_ID            = "userid"
    private let UDH_NICK_NAME          = "nickname"
    private let UDH_PHONE_NUMBER       = "phonenumber"
    private let UDH_AVATAR_SANDBOX_URL = "sandboxavatarurl"
    private let UDH_USER_SEX           = "usersex"
    
    private let userInfoPathInSandbox = "userinfo";
    private let newAvatarTempPathInSanbox = "newAvatar";
    
    var userid   : String = String(){//用户ID：YYYYMMDDHHMMSS+3位毫秒+5位随机数
        didSet {
            self.registed = true
        }
    }
    var nickname : String = String()
    var avatar   : String = String() //服务器端头像地址
    var passwd   : String = String()
    var email    : String = String()
    var phone    : String = String()
    var realname : String = String()
    var sex      : String = String()
    var job      : String = String()
    var address  : String = String()
    var registed : Bool   = false
    private var hasLogin: Bool  = false
    
    private var avatarInSandbox: String?  = nil
    private var newAvatarImage : UIImage? = nil
    private var newAvatarPath  : String?  = nil
    
    override private init() { //将构造函数设为私有，禁止外部创建对象
        super.init()
        loadInfoFromConf()
        //syncInfoFromRemoteByPhone("18605811967")
    }
    
    class var sharedUserInfo: UserInfo {
        return sharedInstance
    }

    /**
     从本地加载用户信息
     */
    private func loadInfoFromConf() -> Void {
        let userConf = UserDefaultHandler().getDictionaryForKey(USER_DEFAULT_KEY_USER_INFO)
        
        //本地没有用户信息，说明是未注册用户或者删除应用后重装
        if nil == userConf {
            return
        }
        
        for key in userConf!.keys {
            switch key {
            case UDH_USER_ID:
                self.userid = userConf![key] as! String
            case UDH_NICK_NAME:
                self.nickname = userConf![key] as! String
            case UDH_PHONE_NUMBER:
                self.phone = userConf![key] as! String
            case UDH_AVATAR_SANDBOX_URL:
                self.avatar = userConf![key] as! String
            case UDH_USER_SEX:
                self.sex = userConf![key] as! String
            default:
                print("Undefined key(\(key)) for user.")
            }
        }
        
        if self.userid.isEmpty || self.nickname.isEmpty || self.phone.isEmpty || self.avatar.isEmpty || self.sex.isEmpty {
            //如果本地用户信息不完整，从服务器同步用户信息。使用场景：版本升级后用户信息扩展
            //TODO: 需重新审视有务必要同步
            self.syncInfoFromRemoteByID(userid)
        }
        
        self.hasLogin = true
    }
    
    // MARK: - HTTP参数生成私有函数
    
    /**
     生成HTTP请求参数数据
     
     - returns: NSData
     */
    private func makeParmDataForUserID() -> NSData {
        self.userid = "20160609191522464ANkKx" //临时测试用
        return userid.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    }
    
    // MARK: - 私有函数
    
    /**
     将String路径转成URL
     
     - parameter stringPath: String路径
     
     - returns: NSURL
     */
    private func getURLBySting(stringPath: String) -> NSURL {
        return NSURL(fileURLWithPath: stringPath, isDirectory: false)
    }
    
    /**
     解析服务端返回的用户数据
     
     - parameter info: 用户信息
     
     - returns: bool
     */
    private func parseUserInfo(JSON: AnyObject) -> Bool {
        //检查是否查询到结果
        if let itemNum = JSON.objectForKey("total") as? Int {
            if 0 == itemNum {
                print("No user info found in json result")
                return false
            }
        }
        
        let items = JSON.objectForKey("row") as? NSArray
        if(nil == items) {
            print("用户协议不匹配，缺少<row>")
            return false
        }
        if items!.count != 1 {
            print("Warning: 查询到<\(items!.count)>条用户")
            return false
        }
        
        let item = items![0]
        
        self.userid   = item.objectForKey("userid") as! String
        self.nickname = item.objectForKey("nickname") as! String
        self.avatar   = item.objectForKey("avatar") as! String
        self.email    = item.objectForKey("email") as! String
        self.phone    = item.objectForKey("phone") as! String
        self.realname = item.objectForKey("realName") as! String
        self.sex      = item.objectForKey("sex") as! String
        self.job      = item.objectForKey("job") as! String
        self.address  = item.objectForKey("address") as! String
        
        return true
    }
    
    /**
     根据用户ID向服务器请求用户信息
     
     - parameter userID:            用户ID
     - parameter completionHandler: 执行结果闭包
     */
    private func requestInfoFromRemoteByID(userID: String, completionHandler: ((successful: Bool) -> Void)?) -> Void {
        let param = ["filter": "id", "userid" : userID]
        
        Alamofire.request(.GET, REQUEST_USER_URL_STR, parameters: param)
            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    completionHandler?(successful: self.parseUserInfo(JSON))
                }
        }
    }
    
    /**
     上传头像到服务器，通过闭包返回执行结果
     
     - parameter completionHandler: 闭包函数，返回执行结果
     */
    private func updateRemoteAvatar(completionHandler: ((successful: Bool) -> Void)?) -> Void {
        Alamofire.upload(.POST,
                         REQUEST_UPDATE_ACCOUNT_AVATAR_URL_STR,
                         multipartFormData: { (multipartFormData) in
                            //添加用户ID
                            multipartFormData.appendBodyPart(data: self.makeParmDataForUserID(), name: "userID")
                            //添加图片
                            multipartFormData.appendBodyPart(fileURL: self.getURLBySting(self.newAvatarPath!), name: "newAvatar")
                            
        }) { (encodingResult) in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    debugPrint(response)
                    completionHandler?(successful: true)
                })
            case .Failure(let encodingError):
                completionHandler?(successful: false)
                showSimpleAlert(self, title: "提交失败", message: "错误代码\(encodingError)")
            }
        }
    }
    
    /**
     保存用户新头像到沙盒临时目录，方便HTTP上传
     
     - parameter image: 新头像
     
     - returns: bool
     */
    private func saveNewAvatarToSandBox(image: UIImage) -> Bool {
        let docDir       = SandboxHandler().getTmpDirectory()
        let userInfoPath = docDir + "/" + self.newAvatarTempPathInSanbox
        var userAvatar   = userInfoPath + "/newAvatar"
        
        guard SandboxHandler().createDirectory(userInfoPath) else {
            print("保存临时用户头像到沙盒失败, 创建目录失败: \(userInfoPath)")
            return false
        }

        //缩放图片
        let scaledImage = ImageHandler().aspectSacleSize(image, targetSize: CGSizeMake(320.0, 320.0))
        let imageData = ImageHandler().getImageBinary(scaledImage, compressionQuality: 1.0)
        if nil == imageData.data {
            return false
        }
        
        userAvatar = userAvatar + "." + imageData.mine!
        guard imageData.data!.writeToFile(userAvatar, atomically: true) else {
            print("保存用户头像到沙盒失败, 写入失败")
            return false
        }
        
        self.newAvatarPath = userAvatar
        
        return true
    }
    
    // MARK: - 公共函数区
    
    /**
     检查是否已登录
     
     - returns: bool
     */
    func isLogin() -> Bool {
        return self.hasLogin
    }
    
    /**
     根据用户ID同步用户信息到instance（注意：不会自动同步到本地）
     
     - parameter userID: 用户ID
     
     - returns: bool
     */
    func syncInfoFromRemoteByID(userID: String) -> Bool {
        self.requestInfoFromRemoteByID(userID) { (successful) in
            if(!successful) {
                //TODO
                print("sync user infomation from server failed!")
                return
            }
            
            print("sync user infomation from server successfull")
        }
        return true
    }
    
    /**
     根据用户手机号同步信息到instance(注意：这是个同步方法)
     使用场景：验证用户手机号时查询是否已经注册
     
     - parameter phone: 用户手机号
     */
    func syncInfoFromRemoteByPhone(phone: String) -> Void {
        let urlStr = REQUEST_USER_URL_STR + "?filter=phone&phonenumber=\(phone)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if(self.parseUserInfo(jsonStr)) {
                //TODO:同步用户信息到本地
            }
        }catch let error as NSError{
            print("网络异常--请求用户信息失败：" + error.localizedDescription)
        }
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
        
        self.avatarInSandbox = userAvatar
        
        return true
    }
    
    /**
     保存用户信息到userDefault
     
     - parameter info: 用户信息对象
     
     - returns: bool
     */
    func saveUserInfoToConf() -> Bool {
        var userConf = Dictionary<String, String>()
        
        guard !self.userid.isEmpty else {
            print("Warning: saveUserInfoToConf() user id is empty!")
            return false
        }
        userConf[UDH_USER_ID] = self.userid
        
        guard !self.nickname.isEmpty else {
            print("Warning: saveUserInfoToConf() nick name is empty!")
            return false
        }
        userConf[UDH_NICK_NAME] = self.nickname
        
        guard !self.phone.isEmpty else {
            print("Warning: saveUserInfoToConf() phone number is empty!")
            return false
        }
        userConf[UDH_PHONE_NUMBER] = self.phone
        
        guard !self.sex.isEmpty else {
            print("Warning: saveUserInfoToConf() user sex is empty!")
            return false
        }
        userConf[UDH_USER_SEX] = self.sex
        
        self.syncAvatarFromRemoteToSandBox(self.avatar, phoneNumber: self.phone)
        guard (self.avatarInSandbox != nil) else {
            print("Warning: saveUserInfoToConf() Can't get avatar path in sandbox!")
            return false
        }
        userConf[UDH_AVATAR_SANDBOX_URL] = self.avatarInSandbox
        
        UserDefaultHandler().setObjectForKey(userConf, key: USER_DEFAULT_KEY_USER_INFO)
        self.hasLogin = true
        
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
    
    func unLogin() -> Void {
        self.userid = String()
        self.nickname = String()
        self.avatar   = String()
        self.passwd   = String()
        self.email    = String()
        self.phone    = String()
        self.realname = String()
        self.sex      = String()
        self.job      = String()
        self.address  = String()
        self.registed = false
        self.hasLogin = false
        
        self.removeUserInfoFromConf()
    }
    
    /**
     更新用户头像.
     先更新服务器端头像，更新成功后从服务器端同步或更新本地数据
     
     - parameter newAvatar: 新头像
     
     - returns: bool
     */
    func setNewAvatar(newAvatar: UIImage) -> Bool {
        self.newAvatarImage = newAvatar
        
        if !saveNewAvatarToSandBox(newAvatar) {
            return false
        }
        
        //更新服务器端头像
        print("开始更新服务器端")
        self.updateRemoteAvatar { (successful) in
            if(successful) {
                print("结束更新服务器端：成功")
                self.newAvatarImage = nil
                //发送通知，通知到后同步服务器信息
                return
            }
            print("结束更新服务器端：失败")
        }
        
        return true
    }
}