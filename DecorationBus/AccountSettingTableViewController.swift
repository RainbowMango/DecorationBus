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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
