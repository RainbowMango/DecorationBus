//
//  ViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-10-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var totalPaid: UILabel!
    @IBOutlet weak var leftBudget: UILabel!
    @IBOutlet weak var totalBudget: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCategory()
        getSummaryData()
    }

    // 从userDefault中读取汇总数据
    func getSummaryData() {
        var userDefault: NSUserDefaults = NSUserDefaults()
        var summaryData: String?
        
        summaryData = userDefault.stringForKey("totalPaid")
        if(nil == summaryData) {
            totalPaid!.text = "支出总额：0.00"
        }
        else {
            totalPaid!.text = "支出总额：\(summaryData)"
        }
        
        summaryData = userDefault.stringForKey("leftBudget")
        if(nil == summaryData) {
            leftBudget!.text = "预算余额：0.00"
        }
        else {
            leftBudget!.text = "预算余额：\(summaryData)"
        }
        
        summaryData = userDefault.stringForKey("totalBudget")
        if(nil == summaryData) {
            totalBudget!.text = "预算总额：0.00"
        }
        else {
            totalBudget!.text = "预算总额：\(summaryData)"
        }
    }
    
    // 初始化类别列表，
    func initCategory() {
        var categoryDic = CategoryArchiver().getCategoryFromUserDefault()
        if categoryDic.isEmpty {
            CategoryArchiver().initCategoryInUserDefault()
            println("initCategory() count: \(categoryDic.count)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

