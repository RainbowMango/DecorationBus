//
//  ModifyBudgetModel.swift
//  DecorationSteward
//
//  Created by ruby on 14-10-31.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation

class ModifyBudgetModel: NSObject{
    var budget: Float
    var category: String
    var brand: String
    var shopPhone: String
    var shopAddress: String
    var comments: String
    
    init(budget: Float, category: String, brand: String, shopPhone: String, shopAddress: String, comments: String){
        self.budget = budget
        self.category = category
        self.brand = brand
        self.shopPhone = shopPhone
        self.shopAddress = shopAddress
        self.comments = comments
        
        super.init()
    }
}