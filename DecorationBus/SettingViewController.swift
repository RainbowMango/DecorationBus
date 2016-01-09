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
    
    var settingItems = ["修改类别", "提交反馈", "关于装修巴士"]
    var cellReuseIdentifier: String = "settingItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        // 设置tableView代理和数据源，否则无法显示，也可以在IB中连线
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        self.settingTableView.tableFooterView = UIView() // 清除tableView中空白行
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
        return 1
    }
    // 设置显示cell的数目
    // TODO：改方法会被调用两次，使显示的sell数目是预期的两倍
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("显示cell数目：\(self.settingItems.count)")
        return settingItems.count
    }

    // 设置每个cell的内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) 
        cell.textLabel!.text = self.settingItems[indexPath.row]
        
        return cell
    }
    
    // 设定选中时的动作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("选中cell with index\(indexPath.row)")
        
        self.settingTableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        default:
            print("不存在该cell index")
        }
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CatagoryPrime" {
            var destination = segue.destinationViewController as CatagoryPrimeMangeViewController
        }
    }
*/
}
