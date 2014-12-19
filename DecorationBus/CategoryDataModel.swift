//
//  CategoryDataModel.swift
//  DecorationBus
//
//  Created by ruby on 14-11-22.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation

class CategoryDataModel: NSCoding {
    var categoryDic: Dictionary<String, Array<String>> = [
        "装修服务": ["设计费", "施工费", "监理费", "管理费", "环境检测费", "其他"],
        "水电工程": ["电线", "电线管", "布线箱", "电工配件", "水管", "水管配件", "开关插座", "其他"],
        "厨房工程": ["整体橱柜", "橱柜配件", "集成吊顶", "吊顶配件", "水槽", "龙头", "厨房挂件", "油烟机", "燃气灶", "热水器", "其他"],
        "卫浴工程": ["浴缸", "马桶", "花洒", "淋浴房", "地漏", "浴室柜", "集成吊顶", "五金挂件", "龙头", "其他"],
        "灯具照明": ["吊灯", "吸顶灯", "射灯", "台灯", "灯带", "其他"],
        "地面墙面": ["地板", "瓷砖", "踢脚线", "墙纸", "油漆", "乳胶漆", "防水涂料", "腻子粉", "其他"],
        "门窗工程": ["室内房门", "入户门", "门套线条", "移门", "窗户", "拉手", "铰链", "合页", "门吸", "锁具", "其他"],
        "成品家具": ["沙发", "茶几", "电视柜", "床", "床垫", "床头柜", "餐桌", "餐椅", "餐边柜", "书柜", "书桌", "电脑椅", "儿童床", "儿童桌", "其他"],
        "摆件配饰": ["床上用品", "花瓶", "装饰画", "窗帘"]
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