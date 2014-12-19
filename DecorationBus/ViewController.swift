//
//  ViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-10-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITabBarControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var totalPaid: UILabel!
    @IBOutlet weak var leftBudget: UILabel!
    @IBOutlet weak var totalBudget: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        self.tabBarController?.delegate = self
        self.navigationController?.delegate = self
        initCategory()
        setSummaryData()
    }

    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
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
    
    // 导航回来时刷新数据
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        setSummaryData()
    }
}

