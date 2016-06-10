//
//  SettingViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-11-11.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {

    @IBOutlet weak var settingTableView: UITableView!
    
    var settingItems = ["修改类别", "提交反馈", "关于装修巴士", "退出登录"]
    var cellReuseIdentifier: String = "settingItemCell"
    var userInfo     = UserInfo.sharedUserInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        
        // 设置tableView代理和数据源，否则无法显示，也可以在IB中连线
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        self.settingTableView.estimatedRowHeight = 80 //预估高度要大于SB中最小高度，否则cell可能被压缩
        self.settingTableView.rowHeight = UITableViewAutomaticDimension // cell 高度自适应
        self.settingTableView.tableFooterView = UIView() // 清除tableView中空白行
    }
    
    override func viewWillAppear(animated: Bool) {
        self.settingTableView.reloadData() //重新加载，用户登录后可以看到登录信息
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
    
//    // 点击初始化按钮弹出提醒
//    @IBAction func deleteAllUserData(sender: AnyObject) {
//        let alertView = UIAlertView(title: "软件初始化", message: "这将删除所有数据和自定义类别，确定继续吗？", delegate: self, cancelButtonTitle: "取消")
//        alertView.addButtonWithTitle("确定")
//        alertView.show()
//    }
//    
//    // AlerView动作
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        switch alertView.buttonTitleAtIndex(buttonIndex)! {
//        case "确定":
//            //CategoryArchiver().initCategoryInUserDefault()
//            //OrderArchiver().removeAllOrders()
//            //BudgetArchiver().removeAllBudgets()
//            CategoryHandler().copyFileToSandbox()
//            OrderDataModel.deleteAll()
//            BudgetDataModel.deleteAll()
//        case "取消":
//            print("用户取消")
//        default:
//            print("未定义动作：\(alertView.buttonTitleAtIndex(buttonIndex))")
//        }
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    // 设置显示cell的数目
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return settingItems.count
        default:
            print("未定义的section")
        }
        
        return 0
    }

    // 设置每个cell的内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("userInfoCell", forIndexPath: indexPath) as! UserInfoTableViewCell
            cell.configureViews(UserInfo.sharedUserInfo)
            
            return cell
        case 1:
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
            cell.textLabel!.text = self.settingItems[indexPath.row]
            return cell
        default:
            print("未定义的cell")
        }
        
        return UITableViewCell()
    }
    
    // 设定选中时的动作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.settingTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(0 == indexPath.section) {
            switch indexPath.row {
            case 0:
                if(UserInfo.sharedUserInfo.isLogin()) {
                    performSegueWithIdentifier("account_setting_segue", sender: self)
                }
                else {
                    performSegueWithIdentifier("segueRegister", sender: self)
                }
            default:
                print("未定义的cell点击行为 section: \(indexPath.section), row: \(indexPath.row)")
            }
        }
        
        if(1 == indexPath.section) {
            switch indexPath.row {
            case 0:
                print("didSelectRowAtIndexPath: 转入类别管理view")
                performSegueWithIdentifier("CatagoryPrime", sender: self.view)
            case 1:
                print("didSelectRowAtIndexPath: 转入收集反馈view")
                performSegueWithIdentifier("feedback", sender: self.view)
            case 2:
                print("didSelectRowAtIndexPath: 转入关于我们view")
                performSegueWithIdentifier("aboutme", sender: self.view)
            case 3:
                print("didSelectRowAtIndexPath: 退出登录")
                UserDataHandler().removeUserInfoFromConf()
                self.userInfo = UserInfo.sharedUserInfo
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            default:
                print("不存在该cell index")
            }
        }
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CatagoryPrime" {
            var destination = segue.destinationViewController as CatagoryPrimeMangeViewController
        }
    }
*/
    
    func requestUserInformation(userID: String) -> UserInfo{
        let urlStr = REQUEST_USER_URL_STR + "?filter=id&userid=\(userID)"
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
        
        return UserInfo.sharedUserInfo
    }
}
