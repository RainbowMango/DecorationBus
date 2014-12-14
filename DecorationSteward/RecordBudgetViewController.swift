//
//  RecordBudgetViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-24.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class RecordBudgetViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var shopTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addrTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    var categoryPickerView: UIPickerView!
    
    var budgets: Array<BudgetItem> = Array<BudgetItem>()
    var categorys: Dictionary<String, Array<String>> = Dictionary<String, Array<String>>()
    var firstCategoryArray: Array<String>!
    var secondCategoryArray: Array<String>!
    var firstSelectedString: String!
    var secondSelectedString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()

        initBarButton()
        initTextFields()
        
        initView()
        
        // 从userDefault中读取所有的budgets
        self.budgets = BudgetArchiver().getBudgetsFromUserDefault()
        
        // 从userDefault中读取所有的类别
        self.categorys = CategoryArchiver().getCategoryFromUserDefault()
        
        // 设置类别滚动轴
        self.firstCategoryArray = Array(self.categorys.keys)
        self.secondCategoryArray = self.categorys[self.firstCategoryArray[0]]
        self.firstSelectedString = self.firstCategoryArray[0]
        self.secondSelectedString = self.secondCategoryArray[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
    }
    
    func initView() {
        // 设置textFiled tag以便于区分
        self.categoryTextField.tag = 100
        
        //设置pickerView
        var toolbar: UIToolbar = UIToolbar()
        self.categoryPickerView = UIPickerView()
        
        var doneBarButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "inView:")
        var toolbarArray = [doneBarButton]
        toolbar.setItems(toolbarArray, animated: true)
        self.categoryPickerView.addSubview(toolbar)
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        self.categoryPickerView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 216)
        self.view.addSubview(self.categoryPickerView)
    }
    
    func initBarButton() -> Void {
        let btn = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Bordered, target: self, action: "barButtonClicked")
        self.navigationItem.rightBarButtonItem = btn
    }
    
    func initTextFields() -> Void {
        self.moneyTextField.delegate = self
        self.categoryTextField.delegate = self
        self.shopTextField.delegate = self
        self.phoneTextField.delegate = self
        self.addrTextField.delegate = self
        self.commentTextView.delegate = self
    }
    
    func barButtonClicked() ->Void {
        println("barButtonClicked()")
        
        // 取得表单信息
        var budgetItem = BudgetItem()
        budgetItem.money = (self.moneyTextField.text as NSString).floatValue
        budgetItem.category = self.categoryTextField.text
        budgetItem.shop = self.shopTextField.text
        budgetItem.phone = self.phoneTextField.text
        budgetItem.addr = self.addrTextField.text
        budgetItem.comment = self.commentTextView.text
        
        // 数据稽核
        if budgetItem.money.isZero {
            var alertView = UIAlertView(title: "空值", message: "请输入正确的金额", delegate: self, cancelButtonTitle: "好的")
            alertView.show()
            
            return
        }
        if budgetItem.category.isEmpty {
            var alertView = UIAlertView(title: "空值", message: "请选择一个类别", delegate: self, cancelButtonTitle: "好的")
            alertView.show()
            
            return
        }
        
        self.budgets.append(budgetItem)
        
        // 将订单信息写入UserDefaults
        BudgetArchiver().saveBudgetsToUserDefault(self.budgets)
        
        println("金额：\(budgetItem.money)")
        println("类别：\(budgetItem.category)")
        println("商家：\(budgetItem.shop)")
        println("电话：\(budgetItem.phone)")
        println("地址：\(budgetItem.addr)")
        println("备注：\(budgetItem.comment)")
        
        // 记录后返回到上层
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateCategoryField(firstCategory: String, secondCategory: String) {
        self.categoryTextField.text = firstCategory + "-" + secondCategory
    }
    
    // 用户完成textField输入后收起键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        println("textFieldShouldReturn() 用户点击‘Done’收起键盘")
        return true
    }
    
    // 手势控制-点击空白处收起键盘
    @IBAction func tapGesture(sender: AnyObject) {
        self.view.endEditing(true)
        inView(self)
    }
    
    // 用户首次开始输输入时清空原内容
    func textViewDidBeginEditing(textView: UITextView) {
        if self.commentTextView.text == "点击输入备注" {
            self.commentTextView.text = nil
        }
    }
    
    func popView(sender: AnyObject) {
        func popAnimation() {
            self.categoryPickerView.frame = CGRectMake(0, self.view.frame.height - 226, self.view.frame.width, 216)
        }
        
        UIView.animateWithDuration(0.3, animations: popAnimation)
    }
    
    func inView(sender: AnyObject) {
        func inAnimation() {
            self.categoryPickerView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 216)
        }
        UIView.animateWithDuration(0.3, animations: inAnimation)
    }
    
    // MARK: pickerView dataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(0 == component) {
            return self.firstCategoryArray.count;
        }
        else if(1 == component) {
            return self.secondCategoryArray.count
        }
        
        return 0
    }
    
    //MARK: pickerView Delegete
    
    // 设置每列显示值
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if 0 == component {
            return self.firstCategoryArray[row]
        }
        else if 1 == component {
            return self.secondCategoryArray[row]
        }
        
        return nil
    }
    
    // pickerView联动
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if 0 == component {
            self.secondCategoryArray = self.categorys[self.firstCategoryArray[row]]
            self.categoryPickerView.selectedRowInComponent(1)
            self.categoryPickerView.reloadComponent(1)
            self.categoryPickerView.selectRow(0, inComponent: 1, animated: true)
            self.firstSelectedString = self.firstCategoryArray[row]
            self.secondSelectedString = self.secondCategoryArray[0]
        }
        else if 1 == component {
            self.secondSelectedString = self.secondCategoryArray[row]
        }
        
        updateCategoryField(self.firstSelectedString, secondCategory: self.secondSelectedString)
    }
    
    
    //MARK: -textFieldDelegate
    
    // 点击textField弹出PickerView
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 100 {
            self.view.endEditing(true)
            popView(self)
            return false
        }
        
        return true
    }
}
