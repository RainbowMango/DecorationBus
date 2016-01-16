//
//  RegViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/1/13.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class RegViewController: UIViewController {
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
        if(verCode?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) > 0) {
            SMSSDK.commitVerificationCode(verCode, phoneNumber: self.phoneNumberField.text, zone: "86", result: { (error) -> Void in
                if(error != nil) {
                    print("验证失败")
                    showSMSAlert(self, title: VERIFY_SMS_FAILED_TITLE, msg: VERIFY_SMS_FAILED_MSG)
                    return
                }
                
                //TODO: 验证成功，查询用户是否已经注册
                
            })
        }
    }
    
    func enableSendButton() -> Void {
        self.sendVerButton.layer.borderColor     = UIColor.blueColor().CGColor
        self.sendVerButton.enabled               = true
        self.sendVerButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
    }
    
    func disableSendButton() -> Void {
        self.sendVerButton.layer.borderColor     = UIColor.lightGrayColor().CGColor
        self.sendVerButton.enabled               = false
        self.sendVerButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
