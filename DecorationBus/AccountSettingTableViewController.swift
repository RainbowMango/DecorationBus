//
//  AccountSettingTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/6/4.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit
import DKImagePickerController

class AccountSettingTableViewController: UITableViewController {

    var userInfo     = UserInfo.sharedUserInfo
    private var didSelectBlock: ((assets: [DKAsset]) -> Void)?  //picker回调
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        
        setupImagePicker()
        
        tableView.tableFooterView = UIView() // 清除tableView中空白行
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: // 头像
            let cell = tableView.dequeueReusableCellWithIdentifier("account_setting_avatar_cell", forIndexPath: indexPath) as! AccountSettingAvatarTableViewCell
            cell.avatarImageView.image = UIImage(contentsOfFile: self.userInfo.avatar)
            return cell
        case 1: // 昵称
            let cell = tableView.dequeueReusableCellWithIdentifier("account_setting_default_cell", forIndexPath: indexPath) as! AccountSettingDefaultTableViewCell
            cell.titleLabel.text   = "昵称"
            cell.contentLable.text = self.userInfo.nickname
            return cell
        case 2:// 性别
            let cell = tableView.dequeueReusableCellWithIdentifier("account_setting_default_cell", forIndexPath: indexPath) as! AccountSettingDefaultTableViewCell
            cell.titleLabel.text   = "性别"
            cell.contentLable.text = self.userInfo.sex
            return cell
        case 3:// 手机号码
            let cell = tableView.dequeueReusableCellWithIdentifier("account_setting_default_cell", forIndexPath: indexPath) as! AccountSettingDefaultTableViewCell
            cell.titleLabel.text   = "手机号码"
            cell.contentLable.text = self.userInfo.phone
            return cell
            
        default:
            print("No defined cell!")
            return UITableViewCell()
        }
    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let alertVC = HCImagePickerHandler().makeAlertController(self, maxCount: 1, defaultAssets: nil, didSelectAssets: self.didSelectBlock)
            self.presentViewController(alertVC, animated: true, completion: nil)
            break
        case 1:
            showSimpleAlert(self, title: "客官别急", message: "个人信息修改功能还在开发中...")
            break
        case 2:
            showSimpleAlert(self, title: "客官别急", message: "个人信息修改功能还在开发中...")
            break
        case 3:
            showSimpleAlert(self, title: "客官别急", message: "个人信息修改功能还在开发中...")
            break
        default:
            return
        }
    }
    
    
    // MARK: - DKImagePickerController
    
    func setupImagePicker() -> Void {
        
        self.didSelectBlock = { (assets: [DKAsset]) in
            
            if assets.count != 1 {
                showSimpleAlert(self, title: "您真幸运", message: "一定是哪里出错了，头像只能是一张图片")
                return
            }
            
            //新选择的图片加入列表中
            for asset in assets {
                asset.fetchFullScreenImage(false, completeBlock: { (image, info) in
                    if nil == image {
                        showSimpleAlert(self, title: "您真幸运", message: "获取图片失败了")
                        return
                    }
                    UserInfo.sharedUserInfo.setNewAvatar(image!)
                })
                
            }
        }
    }
}
