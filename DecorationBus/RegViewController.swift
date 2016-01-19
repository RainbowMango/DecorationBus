//
//  RegViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/1/17.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class RegViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var avatar: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!

    // 定义照片源字符串，方便创建actionSheet和处理代理
    let actionSheetTitleCancel = "取消"
    let actionSheetTitleCamera = "拍照"
    let actionSheetTitlePhotoLibrary = "照片库"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            }
            alertVC.addAction(photoLibrarySheet)
        }
        
        let cancelSheet = UIAlertAction(title: actionSheetTitleCancel, style: UIAlertActionStyle.Cancel) { (action) -> Void in
            print("用户点击取消")
        }
        alertVC.addAction(cancelSheet)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
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
        
        //TODO: 上传图片
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
