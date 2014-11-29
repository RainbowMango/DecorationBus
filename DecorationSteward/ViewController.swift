//
//  ViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-10-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var totalPaid: UILabel!
    @IBOutlet weak var leftBudget: UILabel!
    @IBOutlet weak var totalBudget: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        initCategory()
        setSummaryData()
    }

    // 从userDefault中读取汇总数据
    func setSummaryData() {
        var budgetSum = BudgetArchiver().getBudgetsSum()
        var orderSum = OrderArchiver().getOrderSum()
        
        totalPaid!.text = "支出总额：\(orderSum)"
        leftBudget!.text = "预算余额：\(budgetSum - orderSum)"
        totalBudget!.text = "预算总额：\(budgetSum)"
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
    
    // tab bar 切换时重新加载数据
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        setSummaryData()
    }
}

