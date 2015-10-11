//
//  PrimeCategoryDetailDataModel.swift
//  DecorationBus
//
//  Created by ruby on 15-1-22.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import Foundation

class PrimeCategoryDetail {
    var primeCategory_: String = ""
    var budgetMoney_  : Float  = 0.0
    var orderMoney_   : Float  = 0.0
    
    init (minorItem: MinorCategoryDetail) {
        primeCategory_ = minorItem.primeCategory_
        budgetMoney_   = minorItem.budgetMoney_
        orderMoney_    = minorItem.orderMoney_
    }
    class func mergeToDetailList(inout list: Array<PrimeCategoryDetail>, newItem: MinorCategoryDetail) -> Void{
        for (index, value) in list.enumerate() {
            if value.primeCategory_ == newItem.primeCategory_ {
                list[index].orderMoney_  += newItem.orderMoney_
                list[index].budgetMoney_ += newItem.budgetMoney_
                return
            }
        }
        
        list.append(PrimeCategoryDetail(minorItem: newItem))
    }
    
    // 根据小类别列表获得大类别汇总列表
    class func getPrimeCategoryDetailList(minorList: Array<MinorCategoryDetail>) -> Array<PrimeCategoryDetail> {
        var primeList = Array<PrimeCategoryDetail>()
        
        for minorItem in minorList {
            mergeToDetailList(&primeList, newItem: minorItem)
        }
        
        return primeList
    }
}