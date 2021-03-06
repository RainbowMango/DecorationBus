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
    @IBOutlet weak var footView_: UIView!
    
    var orders_: Array<OrderRecord>!
    var budgets_: Array<BudgetRecord>!
    var primeCategoryDetailList_ = Array<PrimeCategoryDetail>()
    var minorCategoryDetailList_ = Array<MinorCategoryDetail>()
    var tableViewCellArray_ = Array<Dictionary<String, String>>() // table view cell 列表
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = headerView_
        self.tableView.tableFooterView = footView_
        
        setViewColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        orders_ = OrderDataModel.getAll()
        budgets_ = BudgetDataModel.getAll()
        primeCategoryDetailList_ = Array<PrimeCategoryDetail>()
        minorCategoryDetailList_ = Array<MinorCategoryDetail>()
        
        print("更新类别列表")
        for order in orders_ {
            let newItem = MinorCategoryDetail()
            newItem.primeCategory_ = order.primeCategory_
            newItem.minorCategory_ = order.minorCategory_
            newItem.orderMoney_    = order.money_
            
            MinorCategoryDetail.mergeToDetailList(&minorCategoryDetailList_, newItem: newItem)
        }
        for budget in budgets_ {
            let newItem = MinorCategoryDetail()
            newItem.primeCategory_ = budget.primeCategory_
            newItem.minorCategory_ = budget.minorCategory_
            newItem.budgetMoney_   = budget.money_
            
            MinorCategoryDetail.mergeToDetailList(&minorCategoryDetailList_, newItem: newItem)
        }
        
        primeCategoryDetailList_ = PrimeCategoryDetail.getPrimeCategoryDetailList(minorCategoryDetailList_)
        
        print("orders_.count = \(orders_.count)")
        print("budgets_.count = \(budgets_.count)")
        print("minorCategoryDetailList_.count = \(minorCategoryDetailList_.count)")
        print("primeCategoryDetailList_.count = \(primeCategoryDetailList_.count)")
        
        //初始化cell数组
        initCellArray()
        
        //刷新tableView
        self.tableView.reloadData()
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
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
                    cell.primeCategoryImageView_.image = UIImage(named: CategoryHandler().getIcon(primeCategory))
                    cell.categoryLabel_.text  = primeCategory
                    cell.budgetSumLabel_.text = "\(item.budgetMoney_)"
                    cell.spendSumLabel_.text  = "\(item.orderMoney_)"
                    cell.remainSumLabel_.text = "\(item.budgetMoney_ - item.orderMoney_)"
                    
                    // 余额为负显示红色，否则为绿色
                    if (item.budgetMoney_ - item.orderMoney_) >= 0 {
                        cell.remainSumLabel_.textColor = UIColor.greenColor()
                    }
                    else {
                        cell.remainSumLabel_.textColor = UIColor.redColor()
                    }
                    
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
                    
                    // 余额为负显示红色，否则为绿色
                    if (item.budgetMoney_ - item.orderMoney_) >= 0 {
                        cell.remainLabel_.textColor = UIColor.greenColor()
                    }
                    else {
                        cell.remainLabel_.textColor = UIColor.redColor()
                    }
                }
            }
        }
        
        if tableViewCellArray_[indexPath.row]["cellType"] == "prime" { //展示prime cell
            var cell = tableView.dequeueReusableCellWithIdentifier("PrimeCategoryTableViewCell", forIndexPath: indexPath) as! PrimeCategoryTableViewCell
            
            // 配置cell
            configPrimeCell(&cell, primeCategory: tableViewCellArray_[indexPath.row]["primeCategory"]!)
            
            return cell
        }
        else if tableViewCellArray_[indexPath.row]["cellType"] == "minor" { // 展示minor cell
            var cell = tableView.dequeueReusableCellWithIdentifier("MinorCategoryTableViewCell", forIndexPath: indexPath) as! MinorCategoryTableViewCell
            
            // 配置cell
            let primeCategory = tableViewCellArray_[indexPath.row]["primeCategory"]
            let minorCategory = tableViewCellArray_[indexPath.row]["minorCategory"]
            configMinorCell(&cell, primeCategory: primeCategory!, minorCategory: minorCategory!)
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 获取NSIndexPath列表
        func getindexPathArray(basePath: NSIndexPath, count: Int) -> [NSIndexPath] {
            var indexPathArray = Array<NSIndexPath>()
            let startRow = basePath.row + 1
            
            for i in 0..<count {
                let newPath = NSIndexPath(forRow: startRow + i, inSection: basePath.section)
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
                    addCount += 1
                }
            }
            
            // 动态增加cell
            let indexPaths  = getindexPathArray(indexPath, count: addCount)
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Middle)
            self.tableView.endUpdates()
        }
        
        //删除特定主类目下所有子类目cell
        func removeMinorCells(primeCategory: String) ->Void {
            var removeIndexArray = Array<Int>()
            
            //获得将要删除的下标列表
            for (index, value) in tableViewCellArray_.enumerate() {
                if value["cellType"] == "minor" && value["primeCategory"] == primeCategory{
                    removeIndexArray.insert(index, atIndex: 0)
                }
            }
            
            //从cell列表中删除
            for removeIndex in removeIndexArray {
                tableViewCellArray_.removeAtIndex(removeIndex)
            }
            
            //从table view中删除
            let indexPaths = getindexPathArray(indexPath, count: removeIndexArray.count)
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Middle)
            tableView.endUpdates()
        }
        
        //self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedPrimeCategory = tableViewCellArray_[indexPath.row]["primeCategory"]
        //var selectedMinorCategory = tableViewCellArray_[indexPath.row]["minorCategory"]
        
        if tableViewCellArray_[indexPath.row]["cellType"] == "prime" {
            if tableViewCellArray_[indexPath.row]["isAttached"] == "false" { // 展开
                // 改变状态
                tableViewCellArray_[indexPath.row].updateValue("true", forKey: "isAttached")

                // 添加下拉cell
                addMinorCells(selectedPrimeCategory!, baseIndexPath: indexPath)
            }
            else if tableViewCellArray_[indexPath.row]["isAttached"] == "true" { // 收起
                // 改变状态
                tableViewCellArray_[indexPath.row].updateValue("false", forKey: "isAttached")
                
                // 删除下拉cell
                removeMinorCells(selectedPrimeCategory!)
            }
        }
        else if tableViewCellArray_[indexPath.row]["cellType"] == "minor" {
            performSegueWithIdentifier("showDetailSegue", sender: self.view)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailSegue" {
            // 获得选中cell元素
            let selectedIndex: NSIndexPath = tableView.indexPathForSelectedRow!
            var selectedItem = tableViewCellArray_[selectedIndex.row]
            let selectedPrimeCategory = selectedItem["primeCategory"]
            let selectedMinorCategory = selectedItem["minorCategory"]
            
            let destinationView = segue.destinationViewController as! ShowDetailTableViewController
            destinationView.setValue(selectedPrimeCategory, forKey: "primeCategorySelected_")
            destinationView.setValue(selectedMinorCategory, forKey: "minorCategorySelected_")
            print("传递主类别:\(selectedPrimeCategory), 子类别: \(selectedMinorCategory)到下一个view")
        }
    }
}
