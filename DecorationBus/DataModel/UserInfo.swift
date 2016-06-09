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
    
    private var newAvatarImage : UIImage? = nil
    private var newAvatarPath  : String?  = nil
    
    override private init() { //将构造函数设为私有，禁止外部创建对象
    }
    
    class var sharedUserInfo: UserInfo {
        return sharedInstance
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
    
    /**
     将String路径转成URL
     
     - parameter stringPath: String路径
     
     - returns: NSURL
     */
    private func getURLBySting(stringPath: String) -> NSURL {
        return NSURL(fileURLWithPath: stringPath, isDirectory: false)
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