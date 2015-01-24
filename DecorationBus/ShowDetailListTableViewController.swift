//
//  ShowDetailListTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-1-13.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class ShowDetailListTableViewController: UITableViewController {
    @IBOutlet weak var headerView_: UIView!
    
    var orders_ = OrderDataModel().getAllOrders()
    var budgets_ = BudgetDataModel().getAllBudgets()
    var primeCategoryDetailList_ = Array<PrimeCategoryDetail>()
    var minorCategoryDetailList_ = Array<MinorCategoryDetail>()
    var tableViewCellArray_ = Array<Dictionary<String, String>>() // table view cell 列表
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        orders_ = OrderDataModel().getAllOrders()
        budgets_ = BudgetDataModel().getAllBudgets()
        primeCategoryDetailList_ = Array<PrimeCategoryDetail>()
        minorCategoryDetailList_ = Array<MinorCategoryDetail>()
        
        println("更新类别列表")
        for order in orders_ {
            var newItem = MinorCategoryDetail()
            newItem.primeCategory_ = order.valueForKey("primeCategory") as String
            newItem.minorCategory_ = order.valueForKey("minorCategory") as String
            newItem.orderMoney_    = order.valueForKey("money")         as Float
            
            MinorCategoryDetail.mergeToDetailList(&minorCategoryDetailList_, newItem: newItem)
        }
        for budget in budgets_ {
            var newItem = MinorCategoryDetail()
            newItem.primeCategory_ = budget.valueForKey("primeCategory") as String
            newItem.minorCategory_ = budget.valueForKey("minorCategory") as String
            newItem.budgetMoney_   = budget.valueForKey("money")         as Float
            MinorCategoryDetail.mergeToDetailList(&minorCategoryDetailList_, newItem: newItem)
        }
        
        primeCategoryDetailList_ = PrimeCategoryDetail.getPrimeCategoryDetailList(minorCategoryDetailList_)
        
        println("orders_.count = \(orders_.count)")
        println("budgets_.count = \(budgets_.count)")
        println("minorCategoryDetailList_.count = \(minorCategoryDetailList_.count)")
        println("primeCategoryDetailList_.count = \(primeCategoryDetailList_.count)")
        
        //初始化cell数组
        initCellArray()
        
        //刷新tableView
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //将prime类别表转至cell array
    func initCellArray() {
        tableViewCellArray_.removeAll(keepCapacity: true)
        for item in primeCategoryDetailList_ {
            var dic = ["cellType":"prime", "isAttached":"false"]
            dic["primeCategory"] = item.primeCategory_
            dic["minorCategory"] = ""
            tableViewCellArray_.append(dic)
        }
    }
    
    func configPrimeCell(inout cell: PrimeCategoryTableViewCell, primeCategory: String) -> Void
    {
        for item in primeCategoryDetailList_ {
            if item.primeCategory_ == primeCategory {
                cell.categoryLabel_.text  = primeCategory
                cell.budgetSumLabel_.text = "\(item.budgetMoney_)"
                cell.spendSumLabel_.text  = "\(item.orderMoney_)"
                cell.remainSumLabel_.text = "\(item.budgetMoney_ - item.orderMoney_)"
            }
        }
    }
    
    func configMinorCell(inout cell: MinorCategoryTableViewCell, primeCategory: String, minorCategory: String) -> Void {
        for item in minorCategoryDetailList_ {
            if item.primeCategory_ == primeCategory && item.minorCategory_ == minorCategory {
                cell.categoryLabel_.text  = primeCategory
                cell.budgetLabel_.text = "\(item.budgetMoney_)"
                cell.spendLabel_.text  = "\(item.orderMoney_)"
                cell.remainLabel_.text = "\(item.budgetMoney_ - item.orderMoney_)"
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCellArray_.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableViewCellArray_[indexPath.row]["cellType"] == "prime" { //展示prime cell
            var cell = tableView.dequeueReusableCellWithIdentifier("PrimeCategoryTableViewCell", forIndexPath: indexPath) as PrimeCategoryTableViewCell
            
            // 配置cell
            configPrimeCell(&cell, primeCategory: tableViewCellArray_[indexPath.row]["primeCategory"]!)
            
            return cell
        }
        else if tableViewCellArray_[indexPath.row]["cellType"] == "minor" { // 展示minor cell
            var cell = tableView.dequeueReusableCellWithIdentifier("MinorCategoryTableViewCell", forIndexPath: indexPath) as MinorCategoryTableViewCell
            
            // 配置cell
            let primeCategory = tableViewCellArray_[indexPath.row]["primeCategory"]
            let minorCategory = tableViewCellArray_[indexPath.row]["minorCategory"]
            configMinorCell(&cell, primeCategory: primeCategory!, minorCategory: minorCategory!)
            return cell
        }
        
        return UITableViewCell()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Table view delegate
    
    // 设置表头
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerView_
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
