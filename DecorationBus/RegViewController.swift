//
//  RegViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/1/13.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class RegViewController: UIViewController {
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var verificationCodeField: UITextField!
    @IBOutlet weak var hintLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendVerificationCode(sender: AnyObject) {
        let phoneNumber = self.phoneNumberField.text
        if(11 == phoneNumber?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)) {
            SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: phoneNumber!, zone: "86", customIdentifier: nil, result: { (error) -> Void in
                if(error != nil) {
                    print("获取验证码成功")
                }
                else{
                    print("获取验证码失败")
                }
            })

        }
    }

    @IBAction func verifyPhoneNumber(sender: AnyObject) {
        let verCode = self.verificationCodeField.text
        if(verCode?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) > 0) {
            SMSSDK.commitVerificationCode(verCode, phoneNumber: self.phoneNumberField.text, zone: "86", result: { (error) -> Void in
                if(error != nil) {
                    print("验证成功")
                }
                else{
                    print("验证失败")
                }
            })
        }
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
