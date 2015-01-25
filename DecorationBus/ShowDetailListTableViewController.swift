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
        
        func updateIndicatorImage(inout cell: PrimeCategoryTableViewCell) -> Void {
            var currentCell = tableViewCellArray_[indexPath.row]
            
            if currentCell["cellType"] != "prime" {
                return
            }
            
            if currentCell["isAttached"] == "true" {
                cell.launchIndicatorImageView_.image = UIImage(named: "arrow_down.png")
            }
            else {
                cell.launchIndicatorImageView_.image = UIImage(named: "arrow_right.png")
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
                    break
                }
            }
            
            // 更新指示图标
            if tableViewCellArray_[indexPath.row]["isAttached"] == "true" {
                cell.launchIndicatorImageView_.image = UIImage(named: "arrow_down.png")
            }
            else {
                cell.launchIndicatorImageView_.image = UIImage(named: "arrow_right.png")
            }
        }
        
        func configMinorCell(inout cell: MinorCategoryTableViewCell, primeCategory: String, minorCategory: String) -> Void {
            for item in minorCategoryDetailList_ {
                if item.primeCategory_ == primeCategory && item.minorCategory_ == minorCategory {
                    cell.categoryLabel_.text  = minorCategory
                    cell.budgetLabel_.text = "\(item.budgetMoney_)"
                    cell.spendLabel_.text  = "\(item.orderMoney_)"
                    cell.remainLabel_.text = "\(item.budgetMoney_ - item.orderMoney_)"
                }
            }
        }
        
        if tableViewCellArray_[indexPath.row]["cellType"] == "prime" { //展示prime cell
            var cell = tableView.dequeueReusableCellWithIdentifier("PrimeCategoryTableViewCell", forIndexPath: indexPath) as PrimeCategoryTableViewCell
            
            // 配置cell
            configPrimeCell(&cell, tableViewCellArray_[indexPath.row]["primeCategory"]!)
            
            return cell
        }
        else if tableViewCellArray_[indexPath.row]["cellType"] == "minor" { // 展示minor cell
            var cell = tableView.dequeueReusableCellWithIdentifier("MinorCategoryTableViewCell", forIndexPath: indexPath) as MinorCategoryTableViewCell
            
            // 配置cell
            let primeCategory = tableViewCellArray_[indexPath.row]["primeCategory"]
            let minorCategory = tableViewCellArray_[indexPath.row]["minorCategory"]
            configMinorCell(&cell, primeCategory!, minorCategory!)
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 获取NSIndexPath列表
        func getindexPathArray(basePath: NSIndexPath, count: Int) -> [NSIndexPath] {
            var indexPathArray = Array<NSIndexPath>()
            var startRow = basePath.row + 1
            
            for var i = 0; i < count; i++ {
                var newPath = NSIndexPath(forRow: startRow + i, inSection: basePath.section)
                indexPathArray.append(newPath)
            }
            
            return indexPathArray
        }
        
        //增加特定主类目下所有子类目cell
        func addMinorCells(primeCategory: String, baseIndexPath: NSIndexPath) -> Void {
            var dic = ["cellType":"minor", "isAttached":"false", "primeCategory":primeCategory]
            var addCount = 0

            //添加子类目cell到列表
            for minorItem in minorCategoryDetailList_ {
                if minorItem.primeCategory_ == primeCategory {
                    dic["minorCategory"] = minorItem.minorCategory_
                    tableViewCellArray_.insert(dic, atIndex: baseIndexPath.row + 1)
                    addCount++
                }
            }
            
            // 动态增加cell
            var indexPaths  = getindexPathArray(indexPath, addCount)
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Middle)
            self.tableView.endUpdates()
        }
        
        //删除特定主类目下所有子类目cell
        func removeMinorCells(primeCategory: String) ->Void {
            var removeIndexArray = Array<Int>()
            
            //获得将要删除的下标列表
            for (index, value) in enumerate(tableViewCellArray_) {
                if value["cellType"] == "minor" && value["primeCategory"] == primeCategory{
                    removeIndexArray.insert(index, atIndex: 0)
                }
            }
            
            //从cell列表中删除
            for removeIndex in removeIndexArray {
                tableViewCellArray_.removeAtIndex(removeIndex)
            }
            
            //从table view中删除
            var indexPaths = getindexPathArray(indexPath, removeIndexArray.count)
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Middle)
            tableView.endUpdates()
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var selectedPrimeCategory = tableViewCellArray_[indexPath.row]["primeCategory"]
        var selectedMinorCategory = tableViewCellArray_[indexPath.row]["minorCategory"]
        
        if tableViewCellArray_[indexPath.row]["cellType"] == "prime" {
            if tableViewCellArray_[indexPath.row]["isAttached"] == "false" { // 展开
                // 改变状态
                tableViewCellArray_[indexPath.row].updateValue("true", forKey: "isAttached")

                // 添加下拉cell
                addMinorCells(selectedPrimeCategory!, indexPath)
            }
            else if tableViewCellArray_[indexPath.row]["isAttached"] == "true" { // 收起
                // 改变状态
                tableViewCellArray_[indexPath.row].updateValue("false", forKey: "isAttached")
                
                // 删除下拉cell
                removeMinorCells(selectedPrimeCategory!)
            }
        }
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
