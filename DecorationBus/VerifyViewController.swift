//
//  VerifyViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/1/13.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var verView: UIView!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var verificationCodeField: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var sendVerButton: UIButton!

    override func viewDidLoad() {
        //设置发送验证码button的初始边框
        self.sendVerButton.layer.borderWidth = 0.5
        self.enableSendButton()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendVerificationCode(sender: AnyObject) {
        let phoneNumber = self.phoneNumberField.text
        print("开始向\(phoneNumber)发送验证码！")
        disableSendButton()
        
        if(11 == phoneNumber?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)) {
            SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: phoneNumber!, zone: "86", customIdentifier: nil, result: { (error) -> Void in
                if(error == nil) {
                    print("获取验证码成功")
                }
                else{
                    let errorCode = error.code
                    let errorString = getSMSErrorInfo(errorCode)
                    print("获取验证码失败, code:\(errorCode), info: " + errorString)
                    let alertVC = UIAlertController(title: "验证码获取失败", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                        print("Alert Action: 取消")
                    })
                    alertVC.addAction(alertAction)
                    self.presentViewController(alertVC, animated: true, completion: nil)
                }
            })

        }
    }

    @IBAction func verifyPhoneNumber(sender: AnyObject) {
        let verCode = self.verificationCodeField.text
//        if(verCode?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) > 0) {
//            SMSSDK.commitVerificationCode(verCode, phoneNumber: self.phoneNumberField.text, zone: "86", result: { (error) -> Void in
//                if(error != nil) {
//                    print("验证失败")
//                    showSMSAlert(self, title: VERIFY_SMS_FAILED_TITLE, msg: VERIFY_SMS_FAILED_MSG)
//                    return
//                }
//                
//                let user = self.requestUserInformation(self.phoneNumberField.text!)
//                if(user.registed) {//老用户，记录登录状态
//                    UserDefaultHandler().setStringConf(USER_DEFAULT_KEY_LOGIN_USER_ID, value: user.userid)
//                    self.navigationController?.popViewControllerAnimated(true)
//                }
//                else if(!user.registed) { // 新用户，引导注册
//                    self.performSegueWithIdentifier("segueNewUserInfo", sender: self)
//                }
//                
//            })
//        }
        
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
            print("网络异常--请求项目经理信息失败：" + error.localizedDescription)
        }
        
        return UserInfo()
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "segueNewUserInfo":
            print("跳转到segueNewUserInfo")
            //let destVC = segue.destinationViewController
        default:
            print("Undefined segue: \(segue.identifier)")
        }
    }

}
