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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAvatarButtonPressed(sender: AnyObject) {
        print("用户开始设置头像")
        let alertVC = UIAlertController(title: "设置头像", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // 检测是否支持拍照（模拟器不支持会引起crash, 真机中访问控制相机被禁后也会crash）
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraSheet = UIAlertAction(title: actionSheetTitleCamera, style: UIAlertActionStyle.Default) { (action) -> Void in
                print("用户点击相机")
                
                if(!DeviceLimitHandler().allowCamera()) {
                    //用户隐私设置禁用相机，弹出alert
                    let alertView = UIAlertView(title: nil, message: "请在“设置-隐私-相机”选项中允许“装修巴士”访问您的相机。", delegate: self, cancelButtonTitle: "确定")
                    alertView.show()
                    return
                }
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeLow // 获取低质量图片已经足够使用，避免内存使用过多引起内存警告
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            alertVC.addAction(cameraSheet)
        }
        
        // 检测是否支持图库
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let photoLibrarySheet = UIAlertAction(title: actionSheetTitlePhotoLibrary, style: UIAlertActionStyle.Default) { (action) -> Void in
                print("用户点击照片库")
                
                if(!DeviceLimitHandler().allowPhotoLibrary()) {
                    //用户隐私设置禁用相册，弹出alert
                    let alertView = UIAlertView(title: nil, message: "请在“设置-隐私-照片”选项中允许“装修巴士”访问您的相机。", delegate: self, cancelButtonTitle: "确定")
                    alertView.show()
                    return
                }
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeLow // 获取低质量图片已经足够使用，避免内存使用过多引起内存警告
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            alertVC.addAction(photoLibrarySheet)
        }
        
        let cancelSheet = UIAlertAction(title: actionSheetTitleCancel, style: UIAlertActionStyle.Cancel) { (action) -> Void in
            print("用户点击取消")
        }
        alertVC.addAction(cancelSheet)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
    }

    @IBAction func doneButtonPressed(sender: AnyObject) {
        //检查数据是否完整
        if(!isAvatarSet) {
            showSimpleAlert(self, title: NO_AVATAR_ERR_TITLE, message: NO_AVATAR_ERR_MSG)
            return
        }
        
        let nickNameLength = self.nickNameTextField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if(nickNameLength < MIN_NICKNAME_LEN) {
            showSimpleAlert(self, title: NICKNAME_MIN_LEN_ERR_TITLE, message: NICKNAME_MIN_LEN_ERR_MSG)
            return
        }
        if(nickNameLength > MAX_NICKNAME_LEN) {
            showSimpleAlert(self, title: NICKNAME_MAX_LEN_ERR_TITLE, message: NICKNAME_MAX_LEN_ERR_MSG)
            return
        }
        
        if(self.sexTextField.text!.isEmpty) {
            showSimpleAlert(self, title: SEX_LEN_ERR_TITLE, message: SEX_LEN_ERR_MSG)
            return
        }
        
        showSimpleAlert(self, title: "恭喜", message: "注册完成！")
        
        let avatarImage = self.avatar.backgroundImageForState(UIControlState.Normal)!
        addUserToServer(UIImage(named: "Album.png")!, name: self.nickNameTextField.text!, sex: self.sexTextField.text!)
    }
    
    func addUserToServer(img: UIImage, name: String, sex: String) -> Void {
        if(nil == UIImagePNGRepresentation(img)) {
            showSimpleAlert(self, title: "图片类型不匹配", message: "请使用PNG格式头像！")
            return
        }
        let imageData = UIImagePNGRepresentation(img)!
        
        let request = NSMutableURLRequest(URL: NSURL(string: REQUEST_ADD_USER_USR_STR)!)
        request.HTTPMethod="POST"//设置请求方式
        let boundary:String="AaB03x"
        let contentType:String="multipart/form-data;boundary="+boundary
        request.addValue(contentType, forHTTPHeaderField:"Content-Type")
        
        let body=NSMutableData()
        
        // 添加图片
        body.appendData(NSString(format:"\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!) // 添加分界线
        body.appendData(NSString(format:"Content-Disposition:form-data;name=\"useravatar\";filename=\"Albumxxx.png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type:image/png\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(imageData)
        body.appendData(NSString(format:"\r\n--\(boundary)--").dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody=body
        let que=NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: que, completionHandler: {
        (response, data, error) ->Void in
        
        if (error != nil){
        print(error)
        }else{
        //Handle data in NSData type
            //showSimpleAlert(self, title: "成功", message: "注册完成")
            print("图片上传成功，注册完成！")
            let info = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(info)
            
            
//        var tr:String=NSString(data:data,encoding:NSUTF8StringEncoding)!
//        println(tr)
//        //在主线程中更新UI风火轮才停止
//        dispatch_sync(dispatch_get_main_queue(), {
//        self.av.stopAnimating()
//        //self.lb.hidden=true
            }
        })


    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil) // 首先释放picker以节省内存
        
        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        self.avatar.setBackgroundImage(image, forState: UIControlState.Normal)
        self.isAvatarSet = true
        
        //保存图片到沙盒，方便图片上传
        UserDataHandler().saveUserAvatarToSandBox("18605811857.png", image: image)
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
            
            presentViewController(alertVC, animated: true, completion: nil)
            
            return false
        default:
            return true
        }
    }
}
