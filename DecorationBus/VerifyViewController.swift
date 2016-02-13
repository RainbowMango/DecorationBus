//
//  VerifyViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/1/13.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var verView: UIView!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var verificationCodeField: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var sendVerButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!

    var phoneNumber = String() //存储用户手机号码，防止用户输入验证码时误修改手机号，导致用户体验下降
    
    let phoneNumberFieldTag = 110
    let verificationCodeFieldTag = 120
    
    var hintTimer = NSTimer()
    var timerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置发送验证码button的初始边框
        self.sendVerButton.layer.borderWidth = 0.5
        self.disableSendButton()
        
        self.hintLabel.hidden     = true
        self.verifyButton.enabled = false

        //设置输入框
        self.phoneNumberField.tag           = self.phoneNumberFieldTag
        self.phoneNumberField.delegate      = self
        self.verificationCodeField.tag      = self.verificationCodeFieldTag
        self.verificationCodeField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hintTimer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendVerificationCode(sender: AnyObject) {
        self.phoneNumber = self.phoneNumberField.text!
        print("开始向\(phoneNumber)发送验证码！")
        disableSendButton()
        startHint()
        
        if(11 == self.phoneNumber.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)) {
            SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: phoneNumber, zone: "86", customIdentifier: nil, result: { (error) -> Void in
                if(error == nil) {
                    showSimpleHint(self.view, title: "发送成功", message: "请耐心接收短信")
                }
                else{
                    let errorString = getSMSErrorInfo(error.code)
                    showSimpleAlert(self, title: "验证码获取失败", message: errorString)
                }
            })

        }
    }

    @IBAction func verifyPhoneNumber(sender: AnyObject) {
        let verCode = self.verificationCodeField.text
        stopHint()
        if(verCode?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) < 4) {
            showSimpleAlert(self, title: VERIFY_SMS_FAILED_TITLE, message: VERIFY_SMS_FAILED_MSG)
            return
        }
        
        //测试账号，以提供给App Store审核时使用
        if(self.phoneNumber == "18605811857" && verCode == "1857") {
            let user = self.requestUserInformation(self.phoneNumber)
            UserDataHandler().syncAvatarFromRemoteToSandBox(user.avatar, phoneNumber: user.phone)
            user.avatar = UserDataHandler().getAvatarSandboxURL(user.phone)!
            UserDataHandler().saveUserInfoToConf(user)
            
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        
        if(verCode?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) > 0) {
            SMSSDK.commitVerificationCode(verCode, phoneNumber: self.phoneNumberField.text, zone: "86", result: { (error) -> Void in
                if(error != nil) {
                    showSimpleAlert(self, title: VERIFY_SMS_FAILED_TITLE, message: VERIFY_SMS_FAILED_MSG)
                    return
                }
                
                let user = self.requestUserInformation(self.phoneNumber)
                if(user.registed) {//老用户，记录登录状态
                    UserDataHandler().syncAvatarFromRemoteToSandBox(user.avatar, phoneNumber: user.phone)
                    user.avatar = UserDataHandler().getAvatarSandboxURL(user.phone)!
                    UserDataHandler().saveUserInfoToConf(user)
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else if(!user.registed) { // 新用户，引导注册
                    self.performSegueWithIdentifier("segueNewUserInfo", sender: self)
                }
                
            })
        }
    }
    
    func enableSendButton() -> Void {
        self.sendVerButton.layer.borderColor     = ColorScheme().buttonEnableColor.CGColor
        self.sendVerButton.enabled               = true
        self.sendVerButton.setTitleColor(ColorScheme().buttonEnableColor, forState: UIControlState.Normal)
    }
    
    func disableSendButton() -> Void {
        self.sendVerButton.layer.borderColor     = ColorScheme().buttonDisableColor.CGColor
        self.sendVerButton.enabled               = false
        self.sendVerButton.setTitleColor(ColorScheme().buttonDisableColor, forState: UIControlState.Disabled)
    }
    
    func requestUserInformation(phoneNumber: String) -> UserInfo{
        let urlStr = REQUEST_USER_URL_STR + "?filter=phone&phonenumber=\(phoneNumber)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let users = UserDataHandler().parseJsonData(data)
            if(users.count > 0) {
                return users[0]
            }
        }catch let error as NSError{
            print("网络异常--请求用户信息失败：" + error.localizedDescription)
        }
        
        return UserInfo()
    }
    
    /*
    * 启动计时器并显示等待秒数
    */
    func startHint() {
        self.hintTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateHintTime", userInfo: nil, repeats: true)
        self.hintLabel.hidden = false
        self.timerCount = 0
    }
    
    /*
    * 停止计时器
    */
    func stopHint() {
        self.hintTimer.invalidate()
        self.hintLabel.hidden = true
        self.timerCount = 0
    }
    
    func updateHintTime() {
        //60秒还未收到短信验证码，提示用户重试
        if(timerCount >= 60) {
            hintTimer.invalidate()
            print("计时器已经超时")
            return
        }
        
        print("计时时间已到\(self.timerCount)")
        self.timerCount++
        self.hintLabel.text = "还需要等待\(60 - timerCount)秒"
    }
    
    // MARK: - UITextFieldDelegate
    
    /*
    * 监测输入
    */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let fieldLength = (textField.text?.characters.count)! - range.length + string.characters.count
        print("当前字符数为:\(fieldLength)")
        
        switch textField.tag {
        case self.phoneNumberFieldTag:
            guard fieldLength <= 11 else { //不允许输入超过11位
                return false
            }
            
            if(fieldLength == 11) {
                enableSendButton()
            }
            else {
                disableSendButton()
            }
            
        case self.verificationCodeFieldTag:
            if(fieldLength >= 4) {
                self.verifyButton.enabled = true
            }
            
            guard fieldLength < 10 else {return false}
            
        default:
            print("未处理的UITextFiled, tag= \(textField.tag)")
            
        }
        
        return true
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "segueNewUserInfo":
            let destVC = segue.destinationViewController as! RegViewController
            destVC.userInfo.phone = self.phoneNumber
        default:
            print("Undefined segue: \(segue.identifier)")
        }
    }

}
