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
    
    var budgetArray_ = Array<NSManagedObject>()
    var orderArray_  = Array<NSManagedObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segment_.addTarget(self, action: "segmentChangeHandler", forControlEvents: UIControlEvents.ValueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        budgetArray_ = BudgetDataModel.getBudgets(primeCategorySelected_, minorCategory: minorCategorySelected_)
        orderArray_ = OrderDataModel.getOrders(primeCategorySelected_, minorCategory: minorCategorySelected_)
        self.navigationItem.title = primeCategorySelected_
        segment_.setTitle("预算(\(budgetArray_.count))", forSegmentAtIndex: 0)
        segment_.setTitle("支出(\(orderArray_.count))", forSegmentAtIndex: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SegmentCategoryTableViewCell", forIndexPath: indexPath) as SegmentCategoryTableViewCell

        var cellData: NSManagedObject!
        if (segment_.selectedSegmentIndex == 0) {
            cellData = budgetArray_[indexPath.row]
        } else {
            cellData = orderArray_[indexPath.row]
        }
        
        cell.categoryLabel_.text = (cellData.valueForKey("minorCategory")  as String)
        cell.moneyLable_.text    = (cellData.valueForKey("money") as Float).description

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
