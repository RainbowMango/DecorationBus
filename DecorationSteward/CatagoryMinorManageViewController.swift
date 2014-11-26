//
//  CatagoryMinorManageViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-11.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class CatagoryMinorManageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var minorCategoryTableView: UITableView!
    
    var primeCategorySelected: String = String() // 前个页面选中的大类名，本界面据此显示响应小类名
    var minorCategorys: Array<String> = Array<String>()
    var cellReuseIdentifier: String = "minorCategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.minorCategorys = CategoryArchiver().getMinorCategoryByPrime(self.primeCategorySelected)
        println("Get minor categorys: \(self.minorCategorys)")
        
        self.minorCategoryTableView.dataSource = self
        self.minorCategoryTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source protocol
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.minorCategorys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = self.minorCategorys[indexPath.row]
        
        return cell
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
