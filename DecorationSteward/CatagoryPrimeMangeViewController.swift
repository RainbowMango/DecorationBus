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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置tableView代理和数据源，否则无法显示，也可以在IB中连线
        self.primeCatagoryTableView.delegate = self
        self.primeCatagoryTableView.dataSource = self
        
        // 动态获取类别
        var categoryDic = CategoryArchiver().getCategoryFromUserDefault()
        self.primeCatagory = Array(categoryDic.keys)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
