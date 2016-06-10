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
    var avatar   : String = String()
    var passwd   : String = String()
    var email    : String = String()
    var phone    : String = String()
    var realname : String = String()
    var sex      : String = String()
    var job      : String = String()
    var address  : String = String()
    var registed : Bool   = false
    private var hasLogin: Bool  = false
    
    private var newAvatarImage : UIImage? = nil
    private var newAvatarPath  : String?  = nil
    
    override private init() { //将构造函数设为私有，禁止外部创建对象
        super.init()
        loadInfoFromConf()
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
            self.syncInfoFromRemote(userid)
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
     根据用户ID向服务器请求用户信息
     
     - parameter userID:            用户ID
     - parameter completionHandler: 执行结果闭包
     */
    private func requestInfoFromRemote(userID: String, completionHandler: ((successful: Bool) -> Void)?) -> Void {
        let param = ["filter": "id", "userid" : userID]
        
        Alamofire.request(.GET, REQUEST_USER_URL_STR, parameters: param)
            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    //检查是否查询到结果
                    if let itemNum = JSON.objectForKey("total") as? Int {
                        if 0 == itemNum {
                            completionHandler?(successful: false)
                            return
                        }
                    }
                    
                    let items = JSON.objectForKey("row") as? NSArray
                    if(nil == items) {
                        print("用户协议不匹配，缺少<row>")
                        completionHandler?(successful: false)
                        return
                    }
                    if items!.count != 1 {
                        print("Warning: 查询到<\(items!.count)>条用户拥有相同的ID(\(userID))")
                        completionHandler?(successful: false)
                        return
                    }
                    
                    let item = items![0]
                    
                    //TODO：为安全起见，建议下面也需要做检查，防止协议变化导致崩溃
                    self.userid   = item.objectForKey("userid") as! String
                    self.nickname = item.objectForKey("nickname") as! String
                    self.avatar   = item.objectForKey("avatar") as! String
                    self.email    = item.objectForKey("email") as! String
                    self.phone    = item.objectForKey("phone") as! String
                    self.realname = item.objectForKey("realName") as! String
                    self.sex      = item.objectForKey("sex") as! String
                    self.job      = item.objectForKey("job") as! String
                    self.address  = item.objectForKey("address") as! String
                    
                    completionHandler?(successful: true)
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
    func syncInfoFromRemote(userID: String) -> Bool {
        self.requestInfoFromRemote(userID) { (successful) in
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