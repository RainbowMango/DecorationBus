//
//  ShowBudgetListViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-24.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class ShowBudgetListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var deTailTableView: UITableView!
    
    var cellReuseIdentifier: String = "budgetCell"
    var budgets: Array<BudgetItem> = BudgetArchiver().getBudgetsFromUserDefault()
    
    override func viewDidLoad() {
        println("viewDidLoad() \(self)")
        super.viewDidLoad()
        setViewColor()
        
        initTableView()
        
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("viewWillAppear: \(self)")
        reloadData()
        self.deTailTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
    }
    
    // MARK: Init functions
    
    // 初始化table view
    func initTableView() {
        self.deTailTableView.dataSource = self
        self.deTailTableView.delegate = self
    }
    
    func reloadData() -> Void {
        budgets = BudgetArchiver().getBudgetsFromUserDefault()
    }
    
    // MARK: -TableView data source
    
    // 每个section显示行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("显示行数: \(self.budgets.count)")
        return self.budgets.count
    }
    
    // 设置cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = self.budgets[indexPath.row].category + "   \(self.budgets[indexPath.row].money)"
        
        return cell
    }
    
    // 设置section数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // 设定选中时的动作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath() \(indexPath.row)")
        
        //performSegueWithIdentifier("toShowDetailBudget", sender: self.view)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 添加滑动按钮
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        // 添加删除按钮
        let deleteClosure = { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.budgets.removeAtIndex(indexPath.row)
            self.deTailTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            BudgetArchiver().saveBudgetsToUserDefault(self.budgets)
        }
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除", handler: deleteClosure)
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    // MARK: - Navigation
    
    // 向下个页面传值标准做法
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShowDetailBudget" {
            println("将要转入toShowDetailBudget页面")
            
            // 获得选中cell元素
            var selectedIndex: NSIndexPath = self.deTailTableView.indexPathForSelectedRow()!
            var budgetItem = self.budgets[selectedIndex.row]
            
            var destinationView: ShowBudgetDetailViewController = segue.destinationViewController as ShowBudgetDetailViewController
            destinationView.setValue(budgetItem, forKey: "budgetItem")
        }
    }
}