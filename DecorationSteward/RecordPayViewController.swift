//
//  RecordPayViewController.swift
//  DecorationSteward
//  
//  记录支出View Controller
//
//  Created by ruby on 14-11-9.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class RecordPayViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var payNavigationItem: UINavigationItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var shopTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addrTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    var categoryPickerView: UIPickerView!
    
    var orders: Array<OrderItem> = Array<OrderItem>()
    var categorys: Dictionary<String, Array<String>> = Dictionary<String, Array<String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        // 设置空间的代理到本Controller，也可以在IB中连线
        self.moneyTextField.delegate = self
        self.categoryTextField.delegate = self
        self.shopTextField.delegate = self
        self.phoneTextField.delegate = self
        self.addrTextField.delegate = self
        self.commentTextView.delegate = self
        
        // 从userDefault中读取所有的order
        self.orders = OrderArchiver().getOrdesFromUserDefault()
        
        // 从userDefault中读取所有的类别
        self.categorys["A"] = ["A-01", "A-02", "A-03", "A-04", "A-05"]
        self.categorys["B"] = ["B-01", "B-02", "B-03", "B-04", "B-05"]
        self.categorys["C"] = ["C-01", "C-02", "C-03", "C-04", "C-05"]
        self.categorys["D"] = ["D-01", "D-02", "D-03", "D-04", "D-05"]
    }

    func initView() {
        // 设置Navigation right bar item
        self.rightBarButton.title = "完成"
        
        // 设置textFiled tag以便于区分
        self.categoryTextField.tag = 100
        
        // 设置textView边框
        self.commentTextView.layer.borderWidth = 1
        self.commentTextView.layer.borderColor = UIColor.grayColor().CGColor
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // 用户完成表单输入
    @IBAction func finishRecord(sender: AnyObject) {
        println("finishRecord() 用户完成输入")
        
        // 取得表单信息
        var orderItem = OrderItem()
        orderItem.money = self.moneyTextField.text
        orderItem.category = self.categoryTextField.text
        orderItem.shop = self.shopTextField.text
        orderItem.phone = self.phoneTextField.text
        orderItem.addr = self.addrTextField.text
        orderItem.comment = self.commentTextView.text
        
        orders.append(orderItem)
        
        // 将订单信息写入UserDefaults
        OrderArchiver().saveOrdersToUserDefault(self.orders)
        
        println("金额：\(orderItem.money)")
        println("类别：\(orderItem.category)")
        println("商家：\(orderItem.shop)")
        println("电话：\(orderItem.phone)")
        println("地址：\(orderItem.addr)")
        println("备注：\(orderItem.comment)")
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(0 == component) {
            return self.categorys.count;
        }
        else if(1 == component) {
            return self.categorys.count
        }
    
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "Hello"
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 100 {
            popView(self)
            return false
        }
        
        return true
    }
}
