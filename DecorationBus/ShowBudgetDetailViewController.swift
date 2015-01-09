//
//  ShowBudgetDetailViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-11-29.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class ShowBudgetDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var detailTableView: UITableView!
    
    var cellReuseIdentifier: String = "budgetDetailCell"
    var money_: Float  = 0.0
    var primeCategory_ = ""
    var minorCategory_ = ""
    var shop_          = ""
    var phone_         = ""
    var address_       = ""
    var comments_      = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Init functions
    
    // 初始化table view
    func initTableView() {
        self.detailTableView.dataSource = self
        self.detailTableView.delegate = self
    }
    
    // MARK: -TableView data source
    
    // 每个section显示行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    // 设置cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        switch indexPath.row {
        case 0:
            cell.textLabel!.text = "金额： \(money_)"
        case 1:
            cell.textLabel!.text = "类别： \(primeCategory_)-\(minorCategory_)"
        case 2:
            cell.textLabel!.text = "商家： \(shop_)"
        case 3:
            cell.textLabel!.text = "电话： \(phone_)"
        case 4:
            cell.textLabel!.text = "地址： \(address_)"
        case 5:
            cell.textLabel!.text = "备注： \(comments_)"
        default:
            cell.textLabel!.text = ""
        }
        
        return cell
    }
    
    // 设置section数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
