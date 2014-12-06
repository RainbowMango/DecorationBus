//
//  CatagoryPrimeMangeViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-11.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class CatagoryPrimeMangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var primeCatagory: Array<String>!
    var primeCategorySelected: String = String()
    
    @IBOutlet weak var primeCatagoryTableView: UITableView!
    @IBOutlet weak var addPrimeCategoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewColor()
        
        // 设置tableView代理和数据源，否则无法显示，也可以在IB中连线
        self.primeCatagoryTableView.delegate = self
        self.primeCatagoryTableView.dataSource = self
        
        getPrimeCategory()
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.addPrimeCategoryButton.backgroundColor = ColorScheme().buttonBackgroundColor
        self.addPrimeCategoryButton.titleLabel?.textColor = ColorScheme().buttonTextColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPrimeCategory() -> Void {
        var categoryDic = CategoryArchiver().getCategoryFromUserDefault()
        self.primeCatagory = Array(categoryDic.keys)
    }
    
    // 导航返回时重新加载数据
    func reloadData() -> Void {
        getPrimeCategory()
        self.primeCatagoryTableView.reloadData()
    }
    
    // 设置显示cell的数目
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("显示cell数目：\(self.primeCatagory.count)")
        return self.primeCatagory.count
    }
    
    // 设置每个cell的内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel.text = self.primeCatagory[indexPath.row]
        
        return cell
    }
    
    // 设定选中时的动作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath() \(self.primeCatagory[indexPath.row])")
        
        self.primeCategorySelected = self.primeCatagory[indexPath.row]
        performSegueWithIdentifier("toMinorCategory", sender: self.view)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 滑动删cell
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            println("Delete \(self.primeCatagory[indexPath.row])")
            CategoryArchiver().deletePrimeCategory(self.primeCatagory[indexPath.row])
            self.primeCatagory.removeAtIndex(indexPath.row)
            primeCatagoryTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - Navigation

    // 向下个页面传值标准做法
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMinorCategory" {
            println("将要转入toMinorCategory页面")
            
            var destinationView: CatagoryMinorManageViewController = segue.destinationViewController as CatagoryMinorManageViewController
            destinationView.setValue(self.primeCategorySelected, forKey: "primeCategorySelected")
        }
    }
}
