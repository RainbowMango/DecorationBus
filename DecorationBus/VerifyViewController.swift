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

    var phoneNumber = String() //存储用户手机号码，防止用户输入验证码时误修改手机号，导致用户体验下降
    
    let phoneNumberFieldTag = 110
    let verificationCodeFieldTag = 120
    
    override func viewDidLoad() {
        //设置发送验证码button的初始边框
        self.sendVerButton.layer.borderWidth = 0.5
        self.disableSendButton()
        
        super.viewDidLoad()

        //设置输入框
        self.phoneNumberField.tag           = self.phoneNumberFieldTag
        self.phoneNumberField.delegate      = self
        self.verificationCodeField.tag      = self.verificationCodeFieldTag
        self.verificationCodeField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendVerificationCode(sender: AnyObject) {
        self.phoneNumber = self.phoneNumberField.text!
        print("开始向\(phoneNumber)发送验证码！")
        disableSendButton()
        
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
        if(verCode?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) > 0) {
            SMSSDK.commitVerificationCode(verCode, phoneNumber: self.phoneNumberField.text, zone: "86", result: { (error) -> Void in
                if(error != nil) {
                    showSimpleAlert(self, title: VERIFY_SMS_FAILED_TITLE, message: VERIFY_SMS_FAILED_MSG)
                    return
                }
                
                let user = self.requestUserInformation(self.phoneNumber)
                if(user.registed) {//老用户，记录登录状态
                    //TODO: 更新conf中用户信息，如果本地没有头像，需要从服务器导入
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else if(!user.registed) { // 新用户，引导注册
                    self.performSegueWithIdentifier("segueNewUserInfo", sender: self)
                }
                
            })
        }
        
        self.performSegueWithIdentifier("segueNewUserInfo", sender: self)
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
    
    // MARK: - UITextFieldDelegate
    
    /*
    * 监测输入
    */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let fieldLength = (textField.text?.characters.count)! - range.length + string.characters.count
        print("当前字符数为:\(fieldLength)")
        
        switch textField.tag {
        case self.phoneNumberFieldTag:
            guard fieldLength <= 11 else {
                return false
            }
            
            if(fieldLength == 11) {
                enableSendButton()
            }
        case self.verificationCodeFieldTag:
            if(fieldLength >= 4) {
                //TODO 激活验证按钮
            }
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
            //destVC.verifiedPhoneNumber = self.phoneNumber
            destVC.userInfo.phone = "18605811857"  //测试阶段hardcode
        default:
            print("Undefined segue: \(segue.identifier)")
        }
    }

}
