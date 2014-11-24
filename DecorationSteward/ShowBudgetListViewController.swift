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
        
        initTableView()
        
        budgets = BudgetArchiver().getBudgetsFromUserDefault()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Init functions
    
    // 初始化table view
    func initTableView() {
        self.deTailTableView.dataSource = self
        self.deTailTableView.delegate = self
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
        cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        cell.textLabel.text = self.budgets[indexPath.row].category + "   " + self.budgets[indexPath.row].money
        
        return cell
    }
    
    // 设置section数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}