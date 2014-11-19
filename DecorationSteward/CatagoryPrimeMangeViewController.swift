//
//  CatagoryPrimeMangeViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-11.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class CatagoryPrimeMangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var primeCatagory = ["类别一","类别二","类别三"]
    
    @IBOutlet weak var primeCatagoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置tableView代理和数据源，否则无法显示，也可以在IB中连线
        self.primeCatagoryTableView.delegate = self
        self.primeCatagoryTableView.dataSource = self
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}