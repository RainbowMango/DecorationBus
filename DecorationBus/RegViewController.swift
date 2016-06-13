//
//  RegViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/1/17.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class RegViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var avatar: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    
    // 定义照片源字符串，方便创建actionSheet和处理代理
    let actionSheetTitleCancel = "取消"
    let actionSheetTitleCamera = "拍照"
    let actionSheetTitlePhotoLibrary = "照片库"
    
    // 控件tag定义
    let sexFieldTag = 110
    
    var isAvatarSet = false
    
    //常量设置（Note: 1个汉字为3个字节）
    let MIN_NICKNAME_LEN = 4
    let MAX_NICKNAME_LEN = 15
    let SEX_LEN          = 3
    let NO_AVATAR_ERR_TITLE = "请上传头像"
    let NO_AVATAR_ERR_MSG   = "点击图片就可以上传头像啦"
    let NICKNAME_MIN_LEN_ERR_TITLE = "名字太短了"
    let NICKNAME_MIN_LEN_ERR_MSG = "昵称长度至少需要4个英文字符，或者2个汉字"
    let NICKNAME_MAX_LEN_ERR_TITLE = "名字太长了"
    let NICKNAME_MAX_LEN_ERR_MSG = "昵称长度最多15个英文字符，或者5个汉字"
    let SEX_LEN_ERR_TITLE          = "请设置性别"
    let SEX_LEN_ERR_MSG            = "请设置性别"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sexTextField.delegate = self
        
        //设置控件tag
        self.sexTextField.tag = self.sexFieldTag
        
        //设置头像圆角
        self.avatar.layer.masksToBounds = true
        self.avatar.layer.cornerRadius  = self.avatar.frame.width / 2.0 //设置为图片宽度的一半出来为圆形
        self.avatar.layer.borderColor   = UIColor.whiteColor().CGColor
        self.avatar.layer.borderWidth   = 3.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addAvatarButtonPressed(sender: AnyObject) {
        let alertVC = UIAlertController(title: "设置头像", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        // 检测是否支持拍照（模拟器不支持会引起crash, 真机中访问控制相机被禁后也会crash）
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraSheet = UIAlertAction(title: actionSheetTitleCamera, style: UIAlertActionStyle.Default) { (action) -> Void in
                if(!DeviceLimitHandler().allowCamera()) {
                    DeviceLimitHandler().showAlertForCameraRestriction(self)
                    return
                }
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium // 获取低质量图片已经足够使用，避免内存使用过多引起内存警告
                
                /*
                * 调用相机时会产生一条log, 应该是IOS8.1的一个bug：
                  Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
                */
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            alertVC.addAction(cameraSheet)
        }
        
        // 检测是否支持图库
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let photoLibrarySheet = UIAlertAction(title: actionSheetTitlePhotoLibrary, style: UIAlertActionStyle.Default) { (action) -> Void in
                if(!DeviceLimitHandler().allowPhotoLibrary()) {
                    DeviceLimitHandler().showAlertForPhotoRestriction(self)
                    return
                }
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium // 获取低质量图片已经足够使用，避免内存使用过多引起内存警告
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            alertVC.addAction(photoLibrarySheet)
        }
        
        let cancelSheet = UIAlertAction(title: actionSheetTitleCancel, style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        alertVC.addAction(cancelSheet)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
    }

    func isNickNameValid() -> Bool {
        let nickNameLength = self.nickNameTextField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if(nickNameLength < MIN_NICKNAME_LEN) {
            showSimpleAlert(self, title: NICKNAME_MIN_LEN_ERR_TITLE, message: NICKNAME_MIN_LEN_ERR_MSG)
            return false;
        }
        
        if(nickNameLength > MAX_NICKNAME_LEN) {
            showSimpleAlert(self, title: NICKNAME_MAX_LEN_ERR_TITLE, message: NICKNAME_MAX_LEN_ERR_MSG)
            return false;
        }
        
        return true;
    }
    
    func isSexValid() -> Bool {
        if(self.sexTextField.text!.isEmpty) {
            showSimpleAlert(self, title: SEX_LEN_ERR_TITLE, message: SEX_LEN_ERR_MSG)
            return false
        }
        
        return true
    }
    @IBAction func doneButtonPressed(sender: AnyObject) {
        guard isNickNameValid() else {
            return
        }
        
        guard isSexValid() else {
            return
        }
        
        UserInfo.sharedUserInfo.registeringNickName    = self.nickNameTextField.text!
        UserInfo.sharedUserInfo.registeringSex         = self.sexTextField.text!
        
        UserInfo.sharedUserInfo.register { (successful, info) in
            if(!successful) {
                showSimpleAlert(self, title: "注册失败", message: info!)
                return
            }
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

    // MARK: - UIImagePickerControllerDelegate
    
    //读取用户选择的图片并保存到沙盒
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil) // 首先释放picker以节省内存
        
        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        self.avatar.setBackgroundImage(image, forState: UIControlState.Normal)
        
        UserInfo.sharedUserInfo.registeringAvatarImage = image
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        switch textField.tag {
        case sexFieldTag:
            let alertVC = UIAlertController(title: "请选择性别", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let alertMaleAction = UIAlertAction(title: "男", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.sexTextField.text = "男"
            })
            let alertFemaleAction = UIAlertAction(title: "女", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.sexTextField.text = "女"
            })
            
            let alertCancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            
            alertVC.addAction(alertMaleAction)
            alertVC.addAction(alertFemaleAction)
            alertVC.addAction(alertCancelAction)
            
            self.nickNameTextField.resignFirstResponder() //取消用户名激活状态
            presentViewController(alertVC, animated: true, completion: nil)
            
            return false
        default:
            return true
        }
    }
}
