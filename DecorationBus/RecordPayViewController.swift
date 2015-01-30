//
//  RecordPayViewController.swift
//  DecorationBus
//  
//  记录支出View Controller
//
//  Created by ruby on 14-11-9.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit
import CoreData

class RecordPayViewController: FormViewController, FormViewControllerDelegate {
    
    struct Static {
        static let moneyTag = "money"
        static let categories = "categories"
        static let shopTag = "shop"
        static let phoneTag = "phone"
        static let addrTag = "address"
        static let commentsTag = "comments"
        static let button = "button"
    }
    var categorys_: Dictionary<String, Array<String>>!
    
    var order_: OrderRecord = OrderRecord()
    
    var toBeModifyItem_: NSManagedObject!
    var modifyFlag_ = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 从userDefault中读取所有的类别
        categorys_ = CategoryArchiver().getCategoryFromUserDefault()
        
        // 加载表单
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Bordered, target: self, action: "submit:")
    }
    
//    // 实现改方法后会导致表单无法正常上下滑动以致键盘遮挡控件
//    override func viewWillAppear(animated: Bool) {
//        if(modifyFlag_) {
//            var prime = toBeModifyItem_.valueForKey("primeCategory") as String
//            var minor = toBeModifyItem_.valueForKey("minorCategory") as String
//            var money = toBeModifyItem_.valueForKey("money")         as Float
//            var shop  = toBeModifyItem_.valueForKey("shop")          as String
//            var phone  = toBeModifyItem_.valueForKey("phone")        as String
//            var address = toBeModifyItem_.valueForKey("address")     as String
//            var comments = toBeModifyItem_.valueForKey("comments")   as String
//            var category = [prime, minor]
//            
//            //TODO: 设置初始值，暂未生效
//            self.setValue(money.description, forTag: Static.moneyTag)
//            self.setValue([prime, minor], forTag: Static.categories)
//            self.setValue(shop, forTag: Static.shopTag)
//            self.setValue(phone, forTag: Static.phoneTag)
//            self.setValue(address, forTag: Static.addrTag)
//            self.setValue(comments, forTag: Static.commentsTag)
//        }
//    }
    
    override func viewDidAppear(animated: Bool) {
        if(modifyFlag_) {
            var id    = toBeModifyItem_.valueForKey("id")            as String
            var prime = toBeModifyItem_.valueForKey("primeCategory") as String
            var minor = toBeModifyItem_.valueForKey("minorCategory") as String
            var money = toBeModifyItem_.valueForKey("money")         as Float
            var shop  = toBeModifyItem_.valueForKey("shop")          as String
            var phone  = toBeModifyItem_.valueForKey("phone")        as String
            var address = toBeModifyItem_.valueForKey("address")     as String
            var comments = toBeModifyItem_.valueForKey("comments")   as String
            var category = [prime, minor]
            
            order_.id_ = id
            
            self.setValue(money.description, forTag: Static.moneyTag)
            self.setValue([prime, minor], forTag: Static.categories)
            self.setValue(shop, forTag: Static.shopTag)
            self.setValue(phone, forTag: Static.phoneTag)
            self.setValue(address, forTag: Static.addrTag)
            self.setValue(comments, forTag: Static.commentsTag)
        }
    }
    
    /// MARK: Actions
    
    func submit(_: UIBarButtonItem!) {
        //取得表单信息
        var money:      Float  = 0.0
        if let val = self.form.sections[0].rows[0].value {
            money = (val as NSString).floatValue
        }
        else {
            var alertView = UIAlertView(title: "空值", message: "请输入正确的金额", delegate: self, cancelButtonTitle: "好的")
            alertView.show()
            return
        }
        
        var primeCategory: String = ""
        var minorCategory: String = ""
        if let val = self.form.sections[0].rows[1].value as? Array<String> {
            primeCategory = val[0]
            minorCategory = val[1]
        }
        else {
            var alertView = UIAlertView(title: "空值", message: "请选择一个类别", delegate: self, cancelButtonTitle: "好的")
            alertView.show()
            return
        }
        
        var shop:       String = ""
        if let val = self.form.sections[1].rows[0].value {
            shop = val as String
        }
        
        var phone:      String = ""
        if let val = self.form.sections[1].rows[1].value {
            phone = val as String
        }
        
        var address:    String = ""
        if let val = self.form.sections[1].rows[2].value {
            address = val as String
        }
        
        var comments:   String = ""
        if let val = self.form.sections[1].rows[3].value {
            comments = val as String
        }
        
        order_.money_           = money
        order_.primeCategory_   = primeCategory
        order_.minorCategory_   = minorCategory
        order_.shop_            = shop
        order_.phone_           = phone
        order_.addr_            = address
        order_.comments_        = comments
        
        println(order_.description())
        
        // 如果是修改记录不重新生成ID，直接修改，否则生成ID并保存
        if modifyFlag_ {
            OrderDataModel.updateRecord(order_)
        }else {
            order_.makeUniqueID()
            OrderDataModel.saveRecord(order_)
        }
        

        // 记录后返回到上层
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /// MARK: Private interface
    
    private func loadForm() {
        
        let form = FormDescriptor()
        
        form.title = "记录支出"
        
        let section1 = FormSectionDescriptor()
        
        // 金额表单
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.moneyTag, rowType: .Number, title: "金额")
        row.cellConfiguration = ["textField.placeholder" : "0.00", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        section1.headerTitle = "必填项目"
        
        // 类别表单
        row = FormRowDescriptor(tag: Static.categories, rowType: FormRowType.TwoComponentPicker, title: "类别")
        //row.cellConfiguration = ["valueLabel.text" : "点击选择类别"]
        row.pickerDatasourceWithTwoComponent = categorys_
        section1.addRow(row)
        
        let section2 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.shopTag, rowType: .Name, title: "商家")
        row.cellConfiguration = ["textField.placeholder" : "商家或品牌", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.phoneTag, rowType: .Phone, title: "电话")
        row.cellConfiguration = ["textField.placeholder" : "商家电话", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.addrTag, rowType: .Name, title: "地址")
        row.cellConfiguration = ["textField.placeholder" : "商家地址", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.commentsTag, rowType: .MultilineText, title: "备注")
        section2.addRow(row)
        section2.headerTitle = "选填项目(提醒：记录越详细后期使用越方便~)"
        
        
        let section3 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.button, rowType: .Button, title: "Dismiss")
        section3.addRow(row)
        
        form.sections = [section1, section2, section3]
        
        self.form = form
    }
    
    /// MARK: FormViewControllerDelegate
    
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
        if rowDescriptor.tag == Static.button {
            self.view.endEditing(true)
        }
    }
}

