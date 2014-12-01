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
    //TODO: 改配色方案无效
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
    }
    
    // 初始化软件
    @IBAction func deleteAllUserData(sender: AnyObject) {
        //TODO：弹出Alert提示用户
        println("软件初始化")
        
        // 清除自定义类别表
        CategoryArchiver().initCategoryInUserDefault()
        
        // 清除预算
        BudgetArchiver().removeAllBudgets()
        
        // 清除订单
        OrderArchiver().removeAllOrders()
    }
    
    // 设置显示cell的数目
    // TODO：改方法会被调用两次，使显示的sell数目是预期的两倍
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("显示cell数目：\(self.settingItems.count)")
        return settingItems.count
    }

    // 设置每个cell的内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
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
