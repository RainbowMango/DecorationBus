//
//  AccountSettingTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/6/4.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class AccountSettingTableViewController: UITableViewController {

    var userInfo     = UserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()

        userInfo = UserDataHandler().getUserInfoFromConf()
        
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
            showSimpleAlert(self, title: "客官别急", message: "个人信息修改功能还在开发中...")
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

}
