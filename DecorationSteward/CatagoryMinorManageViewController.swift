//
//  CatagoryMinorManageViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-11.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class CatagoryMinorManageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var minorCategoryTableView: UITableView = UITableView()
    
    var primeCategorySelected: String = String() // 前个页面选中的大类名，本界面据此显示响应小类名
    var minorCategorys: Array<String> = Array<String>()
    var cellReuseIdentifier: String = "minorCategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTableView()
        
        getMinorCategory()
    }
    
    func addTableView() {
        let tableViewFrame = CGRectMake(0, 60, self.view.frame.width, self.view.frame.height)
        self.minorCategoryTableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
        
        self.minorCategoryTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        
        self.minorCategoryTableView.dataSource = self
        self.minorCategoryTableView.delegate = self
        
        self.view.addSubview(self.minorCategoryTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMinorCategory() -> Void {
        self.minorCategorys = CategoryArchiver().getMinorCategoryByPrime(self.primeCategorySelected)
    }
    
    // 导航返回时重新加载数据
    func reloadData() -> Void {
        getMinorCategory()
        self.minorCategoryTableView.reloadData()
    }
    
    // MARK: - Table view data source protocol
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.minorCategorys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = self.minorCategorys[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 滑动删除子类
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            println("Delete \(self.minorCategorys[indexPath.row])")
            CategoryArchiver().deleteMinorCategory(self.primeCategorySelected, minor: self.minorCategorys[indexPath.row])
            self.minorCategorys.removeAtIndex(indexPath.row)
            minorCategoryTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

    // MARK: - Navigation

    // 向下个页面传值标准做法
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addMinorCategory" {
            println("将要转入addMinorCategory页面")
    
            var destinationView: CategoryMinorAddViewController = segue.destinationViewController as CategoryMinorAddViewController
            destinationView.setValue(self.primeCategorySelected, forKey: "primeCategorySelected")
        }
    }
}
