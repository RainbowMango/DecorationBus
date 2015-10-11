//
//  BudgetArchiver.swift
//  DecorationBus
//
//  Created by ruby on 14-11-24.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation

class BudgetArchiver {
    var userDefault: NSUserDefaults = NSUserDefaults()
    var budgetKey: String = "budgets"
    
    // 序列化获取budgets
    func getBudgetsFromUserDefault() -> Array<BudgetItem> {
        let encodedBudgets: NSData? = userDefault.objectForKey(budgetKey) as? NSData
        if nil == encodedBudgets {
            return Array<BudgetItem>()
        }
        
        let budgets = NSKeyedUnarchiver.unarchiveObjectWithData(encodedBudgets!) as! Array<BudgetItem>
        print("getBudgetsFromUserDefault() count = \(budgets.count)")
        
        return budgets
    }
    
    // 序列化存储budgets
    func saveBudgetsToUserDefault(budgets: Array<BudgetItem>) -> Void {
        let archivedBudgets = NSKeyedArchiver.archivedDataWithRootObject(budgets)
        userDefault.setObject(archivedBudgets, forKey: budgetKey)
        userDefault.synchronize()
        print("saveBudgetsToUserDefault() count = \(budgets.count)")
    }
    
    func removeAllBudgets() -> Void {
        var currentBudgets = getBudgetsFromUserDefault()
        currentBudgets.removeAll(keepCapacity: true)
        saveBudgetsToUserDefault(currentBudgets)
    }
    
    // 累加所有预算
    func getBudgetsSum() -> Float {
        let budgets = getBudgetsFromUserDefault()
        var total: Float = 0.00
        
        for budget in budgets {
            total = total + budget.money
        }
        
        return total
    }
}