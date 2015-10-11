//
//  ShowDetailTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-1-25.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit
import CoreData

class ShowDetailTableViewController: UITableViewController {

    @IBOutlet weak var segment_: UISegmentedControl!
    
    var primeCategorySelected_: String = String() // 选中的主类别
    var minorCategorySelected_: String = String() // 选中的子类别
    
    var budgetArray_ = Array<BudgetRecord>()
    var orderArray_  = Array<OrderRecord>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segment_.addTarget(self, action: "segmentChangeHandler", forControlEvents: UIControlEvents.ValueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        budgetArray_ = BudgetDataModel.getRecordsByCategory(primeCategorySelected_, minorCategory: minorCategorySelected_)
        orderArray_ = OrderDataModel.getRecordsByCategory(primeCategorySelected_, minorCategory: minorCategorySelected_)
        self.navigationItem.title = primeCategorySelected_
        reloadSegmentTitle()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*设置segment标题*/
    func reloadSegmentTitle() {
        segment_.setTitle("预算(\(budgetArray_.count))", forSegmentAtIndex: 0)
        segment_.setTitle("支出(\(orderArray_.count))", forSegmentAtIndex: 1)
    }
    
    // 标签栏变化时刷新table view
    func segmentChangeHandler() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segment_.selectedSegmentIndex {
        case 0:
            return budgetArray_.count
        case 1:
            return orderArray_.count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SegmentCategoryTableViewCell", forIndexPath: indexPath) as! SegmentCategoryTableViewCell

        var cellData: NSManagedObject!
        if (segment_.selectedSegmentIndex == 0) {
            let record = budgetArray_[indexPath.row]
            cell.categoryLabel_.text = record.minorCategory_
            cell.moneyLable_.text    = record.money_.description
        } else {
            let record = orderArray_[indexPath.row]
            cell.categoryLabel_.text = record.minorCategory_
            cell.moneyLable_.text    = record.money_.description
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch segment_.selectedSegmentIndex {
        case 0:
            performSegueWithIdentifier("modifyBudgetSegue", sender: self.view)
        case 1:
            performSegueWithIdentifier("modifyOrderSegue", sender: self.view)
        default:
            return
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            switch segment_.selectedSegmentIndex {
            case 0: // 删除预算
                let uniqueID = budgetArray_[indexPath.row].id_
                BudgetDataModel.removeRecord(uniqueID)
                budgetArray_.removeAtIndex(indexPath.row)
            case 1: // 删除订单
                let uniqueID = orderArray_[indexPath.row].id_
                OrderDataModel.removeRecord(uniqueID)
                orderArray_.removeAtIndex(indexPath.row)
            default:
                return
            }
            
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // 跟新segment标题
            reloadSegmentTitle()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "modifyBudgetSegue" {
            // 获得选中cell元素
            let selectedIndex: NSIndexPath = tableView.indexPathForSelectedRow!
            let selectedItem = budgetArray_[selectedIndex.row]
            
            let destinationView = segue.destinationViewController as! RecordBudgetViewController
            destinationView.setValue(selectedItem, forKey: "budget_")
            destinationView.setValue(true, forKey: "modifyFlag_")
        }
        else if segue.identifier == "modifyOrderSegue" {
            // 获得选中cell元素
            let selectedIndex: NSIndexPath = tableView.indexPathForSelectedRow!
            let selectedItem = orderArray_[selectedIndex.row]
            
            let destinationView = segue.destinationViewController as! RecordPayViewController
            destinationView.setValue(selectedItem, forKey: "order_")
            destinationView.setValue(true, forKey: "modifyFlag_")
        }
    }


}
