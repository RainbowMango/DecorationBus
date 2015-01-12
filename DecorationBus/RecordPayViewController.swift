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

//class RecordPayViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
//    let CategoryTextFieldTag = 100
//    let commentTextViewPlaceholder = "点击输入备注"
//    
//    @IBOutlet weak var payNavigationItem: UINavigationItem!
//    @IBOutlet weak var rightBarButton: UIBarButtonItem!
//    
//    @IBOutlet weak var moneyTextField: UITextField!
//    @IBOutlet weak var categoryTextField: UITextField!
//    @IBOutlet weak var shopTextField: UITextField!
//    @IBOutlet weak var phoneTextField: UITextField!
//    @IBOutlet weak var addrTextField: UITextField!
//    @IBOutlet weak var commentTextView: UITextView!
//    
//    var categoryPickerView: UIPickerView!
//    
//    var categorys: Dictionary<String, Array<String>> = Dictionary<String, Array<String>>()
//    var firstCategoryArray: Array<String>!
//    var secondCategoryArray: Array<String>!
//    var firstSelectedString: String!
//    var secondSelectedString: String!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setViewColor()
//        addPickerView()
//        // 设置Navigation right bar item
//        self.rightBarButton.title = "完成"
//        
//        // 设置textFiled tag以便于区分
//        self.categoryTextField.tag = CategoryTextFieldTag
//        
//        // 设置空间的代理到本Controller，也可以在IB中连线
//        self.moneyTextField.delegate = self
//        self.categoryTextField.delegate = self
//        self.shopTextField.delegate = self
//        self.phoneTextField.delegate = self
//        self.addrTextField.delegate = self
//        self.commentTextView.delegate = self
//        
//        // 从userDefault中读取所有的类别
//        self.categorys = CategoryArchiver().getCategoryFromUserDefault()
//        
//        // 设置类别滚动轴
//        self.firstCategoryArray = Array(self.categorys.keys)
//        self.secondCategoryArray = self.categorys[self.firstCategoryArray[0]]
//        self.firstSelectedString = self.firstCategoryArray[0]
//        self.secondSelectedString = self.secondCategoryArray[0]
//    }
//    
//    // view配色方案
//    func setViewColor() -> Void {
//        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func addPickerView() -> Void {
//        self.categoryPickerView = UIPickerView(frame: CGRectMake(0, self.view.frame.height, self.view.frame.width, 216))
//        self.categoryPickerView.backgroundColor = ColorScheme().pickerViewBackgroundColor
//        
//        self.categoryPickerView.delegate = self
//        self.categoryPickerView.dataSource = self
//        
//        self.view.addSubview(self.categoryPickerView)
//    }
//    
//    func clickCancelButtonItem(sender: AnyObject) {
//        println("点击取消按钮")
//    }
//    
//    func clickOkButtonItem(sender: AnyObject) {
//        println("点击确定按钮")
//    }
//    
//    // 更新输入框内容
//    func updateCategoryField(firstCategory: String, secondCategory: String) {
//        self.categoryTextField.text = firstCategory + "-" + secondCategory
//    }
//    
//    // 用户完成textField输入后收起键盘
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        println("textFieldShouldReturn() 用户点击‘Done’收起键盘")
//        return true
//    }
//
//    // 手势控制-点击空白处收起键盘
//    @IBAction func tapGesture(sender: AnyObject) {
//        self.view.endEditing(true)
//        inPickerView(self)
//    }
//    
//    // 用户完成表单输入
//    @IBAction func finishRecord(sender: AnyObject) {
//        println("finishRecord() 用户完成输入")
//        
//        // 取得表单信息
//        var orderItem = OrderItem()
//        orderItem.money = (self.moneyTextField.text as NSString).floatValue
//        orderItem.category = self.categoryTextField.text
//        orderItem.shop = self.shopTextField.text
//        orderItem.phone = self.phoneTextField.text
//        orderItem.addr = self.addrTextField.text
//        
//        // 如果用户没有输入备注，则忽略备注项，使用默认值
//        if self.commentTextView.text != self.commentTextViewPlaceholder
//        {
//            orderItem.comment = self.commentTextView.text
//        }
//        
//        // 数据稽核
//        if orderItem.money.isZero {
//            var alertView = UIAlertView(title: "空值", message: "请输入正确的金额", delegate: self, cancelButtonTitle: "好的")
//            alertView.show()
//            
//            return
//        }
//        if orderItem.category.isEmpty {
//            var alertView = UIAlertView(title: "空值", message: "请选择一个类别", delegate: self, cancelButtonTitle: "好的")
//            alertView.show()
//            
//            return
//        }
//        
//        println("金额：\(orderItem.money)")
//        println("类别：\(orderItem.category)")
//        println("商家：\(orderItem.shop)")
//        println("电话：\(orderItem.phone)")
//        println("地址：\(orderItem.addr)")
//        println("备注：\(orderItem.comment)")
//        
//        // 将订单信息写入coreData
//        let appDelegate = UIApplication.sharedApplication().delegate  as? AppDelegate
//        let managedObjectContext = appDelegate?.managedObjectContext
//        let entity = NSEntityDescription.entityForName("Order", inManagedObjectContext: managedObjectContext!)
//        let order = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
//        order.setValue((self.moneyTextField.text as NSString).floatValue, forKey: "money")
//        order.setValue(self.categoryTextField.text, forKey: "primeCategory")
//        order.setValue(self.categoryTextField.text, forKey: "minorCategory")
//        order.setValue(self.shopTextField.text as NSString, forKey: "shop")
//        order.setValue(self.phoneTextField.text, forKey: "phone")
//        order.setValue(self.addrTextField.text, forKey: "address")
//        order.setValue(self.commentTextView.text, forKey: "comments")
//        var error: NSError?
//        if false == managedObjectContext!.save(&error) {
//            println("写入失败: \(error), \(error!.userInfo)")
//        }
//        
//        // 记录后返回到上层
//        self.navigationController?.popViewControllerAnimated(true)
//    }
//    
//    func popPickerView(sender: AnyObject) {
//        func popAnimation() {
//            self.categoryPickerView.frame = CGRectMake(0, self.view.frame.height - 226, self.view.frame.width, 216)
//        }
//        
//        UIView.animateWithDuration(0.3, animations: popAnimation)
//    }
//    
//    func inPickerView(sender: AnyObject) {
//        func inAnimation() {
//            self.categoryPickerView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 216)
//        }
//        UIView.animateWithDuration(0.3, animations: inAnimation)
//    }
//    
//    // MARK: pickerView dataSource
//    
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//        return 2
//    }
//    
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if(0 == component) {
//            return self.firstCategoryArray.count;
//        }
//        else if(1 == component) {
//            return self.secondCategoryArray.count
//        }
//    
//        return 0
//    }
//    
//    //MARK: pickerView Delegete
//    
//    // 设置每列显示值
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//        if 0 == component {
//            return self.firstCategoryArray[row]
//        }
//        else if 1 == component {
//            return self.secondCategoryArray[row]
//        }
//        
//        return nil
//    }
//    
//    // pickerView联动
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if 0 == component {
//            self.secondCategoryArray = self.categorys[self.firstCategoryArray[row]]
//            self.categoryPickerView.selectedRowInComponent(1)
//            self.categoryPickerView.reloadComponent(1)
//            self.categoryPickerView.selectRow(0, inComponent: 1, animated: true)
//            self.firstSelectedString = self.firstCategoryArray[row]
//            self.secondSelectedString = self.secondCategoryArray[0]
//        }
//        else if 1 == component {
//            self.secondSelectedString = self.secondCategoryArray[row]
//        }
//        
//        updateCategoryField(self.firstSelectedString, secondCategory: self.secondSelectedString)
//    }
//    
//    
//    //MARK: -textFieldDelegate
//    
//    // 点击textField弹出PickerView
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        // 如果是类别输入框则弹出picker, 且自动更新输入框
//        if textField.tag == CategoryTextFieldTag {
//            self.view.endEditing(true)
//            popPickerView(self)
//            updateCategoryField(self.firstSelectedString, secondCategory: self.secondSelectedString)
//            return false
//        }
//        
//        inPickerView(self) // pickerView可能还未收起，显式收起
//        
//        return true
//    }
//    
//    // 真正开始编辑时恢复视图到初始位置
//    func textFieldDidBeginEditing(textField: UITextField) {
//        KeyboardAccessory().moveUpViewIfNeeded(textField, view: self.view)
//    }
//    
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        return true
//    }
//    
//    // 结束编辑时恢复视图到初始位置
//    func textFieldDidEndEditing(textField: UITextField) {
//        KeyboardAccessory().restoreViewPositionIfNeeded(self.view)
//    }
//    
//    //MARK: -UITextViewDelegate
//    
//    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        return true
//    }
//    
//    // 用户首次开始输输入时清空原内容
//    func textViewDidBeginEditing(textView: UITextView) {
//        KeyboardAccessory().moveUpViewIfNeeded(textView, view: self.view)
//        
//        // 用户开始输入时，如果内容是placeholder，则清除
//        if self.commentTextView.text == self.commentTextViewPlaceholder {
//            self.commentTextView.text = ""
//            self.commentTextView.textColor = UIColor.blackColor()
//        }
//    }
//    
//    func textViewShouldEndEditing(textView: UITextView) -> Bool {
//        return true
//    }
//    
//    func textViewDidEndEditing(textView: UITextView) {
//        KeyboardAccessory().restoreViewPositionIfNeeded(self.view)
//        
//        // 用户结束输入时，如果内容为空，则将填入placeholder
//        if self.commentTextView.text.isEmpty {
//            self.commentTextView.text = self.commentTextViewPlaceholder
//            self.commentTextView.textColor = UIColor.lightGrayColor()
//        }
//    }
//}


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
    
    /// MARK: Actions
    
    func submit(_: UIBarButtonItem!) {
        
        let message = self.form.formValues().description
        
        let alert: UIAlertView = UIAlertView(title: "Form output", message: message, delegate: nil, cancelButtonTitle: "OK")
        
        alert.show()
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
        row.cellConfiguration = ["valueLabel.text" : "点击选择类别"]
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

