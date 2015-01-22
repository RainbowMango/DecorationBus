//
//  MinorCategoryDetailDataModel.swift
//  DecorationBus
//
//  Created by ruby on 15-1-22.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import Foundation

class MinorCategoryDetail {
    var primeCategory_: String = ""
    var minorCategory_: String = ""
    var budgetMoney_  : Float  = 0.0
    var orderMoney_   : Float  = 0.0
    
    class func mergeToDetailList(inout list: Array<MinorCategoryDetail>, newItem: MinorCategoryDetail) -> Void{
        for (index, value) in enumerate(list) {
            if value.primeCategory_ == newItem.primeCategory_ && value.minorCategory_ == newItem.minorCategory_ {
                list[index].orderMoney_  += newItem.orderMoney_
                list[index].budgetMoney_ += newItem.budgetMoney_
                return
            }
        }
        list.append(newItem)
    }
}