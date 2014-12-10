//
//  SettingViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-11.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingTableView: UITableView!
    
    var settingItems = ["修改类别", "提交反馈", "关于装修管家"]
    var cellReuseIdentifier: String = "settingItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        // 设置tableView代理和数据源，否则无法显示，也可以在IB中连线
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
    }
    
    // 初始化软件
    @IBAction func deleteAllUserData(sender: AnyObject) {
        // 初始化类别列表
        let initCategoryClosure = { (action: UIAlertAction!) -> Void in
            println("initCategory")
            CategoryArchiver().initCategoryInUserDefault()
        }
        var initCategoryAction = UIAlertAction(title: "初始化类别表", style: UIAlertActionStyle.Destructive, handler: initCategoryClosure)
        
        // 清空订单
        let initOrdersClosure = { (action: UIAlertAction!) -> Void in
            println("initOrdersClosure")
            OrderArchiver().removeAllOrders()
        }
        var initOrderAction = UIAlertAction(title: "初始化订单", style: UIAlertActionStyle.Destructive, handler: initOrdersClosure)
        
        // 清空预算
        let initBudgetClosure = { (action: UIAlertAction!) -> Void in
            println("initBudgetClosure")
            BudgetArchiver().removeAllBudgets()
        }
        var initBudgetAction = UIAlertAction(title: "初始化预算", style: UIAlertActionStyle.Destructive, handler: initBudgetClosure)
        
        // 全部初始化
        let initAllClosure = { (action: UIAlertAction!) -> Void in
            println("initAllClosure")
            initCategoryClosure(action)
            initOrdersClosure(action)
            initBudgetClosure(action)
        }
        var initAllAction = UIAlertAction(title: "全部初始化", style: UIAlertActionStyle.Destructive, handler: initAllClosure)
        
        // 取消
        let cancelClosure = { (action: UIAlertAction!) -> Void in
            println("cancelColsure")
        }
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: cancelClosure)
        
        // 添加动作
        var alertController = UIAlertController(title: "提醒", message: "数据删除后不可恢复", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(cancelAction)
        alertController.addAction(initCategoryAction)
        alertController.addAction(initOrderAction)
        alertController.addAction(initBudgetAction)
        alertController.addAction(initAllAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showAlert() -> Void {
        var alertController = UIAlertController(title: "空值", message: "请输入正确的子类名", preferredStyle: UIAlertControllerStyle.Alert)
        var okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // 设置显示cell的数目
    // TODO：改方法会被调用两次，使显示的sell数目是预期的两倍
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("显示cell数目：\(self.settingItems.count)")
        return settingItems.count
    }

    // 设置每个cell的内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = self.settingItems[indexPath.row]
        
        return cell
    }
    
    // 设定选中时的动作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("选中cell with index\(indexPath.row)")
        
        switch indexPath.row {
        case 0:
            println("didSelectRowAtIndexPath: 转入类别管理view")
            performSegueWithIdentifier("CatagoryPrime", sender: self.view)
        case 1:
            println("didSelectRowAtIndexPath: 转入收集反馈view")
            performSegueWithIdentifier("feedback", sender: self.view)
        case 2:
            println("didSelectRowAtIndexPath: 转入关于我们view")
            performSegueWithIdentifier("aboutme", sender: self.view)
        default:
            println("不存在该cell index")
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
