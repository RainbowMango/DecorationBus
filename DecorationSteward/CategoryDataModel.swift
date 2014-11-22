//
//  CategoryDataModel.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-22.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation

class CategoryDataModel: NSCoding {
    var categoryDic: Dictionary<String, Array<String>> = ["A": ["A-01", "A-02", "A-03", "A-04", "A-05"],
                                                          "B": ["B-01", "B-02", "B-03", "B-04", "B-05"],
                                                          "C": ["C-01", "C-02", "C-03", "C-04", "C-05"],
                                                          "D": ["D-01", "D-02", "D-03", "D-04", "D-05"]
                                                         ]
    init() {
    }
    
    required init(coder aDecoder: NSCoder) {
        self.categoryDic = aDecoder.decodeObjectForKey("categoryDic") as Dictionary<String, Array<String>>
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.categoryDic, forKey: "categoryDic")
    }
}