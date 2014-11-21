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

class RecordPayViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate {

    @IBOutlet weak var payNavigationItem: UINavigationItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var shopTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addrTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    var orders: Array<OrderItem> = Array<OrderItem>()
    
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
    }

    func initView() {
        // 设置Navigation right bar item
        self.rightBarButton.title = "完成"
        
        // 设置textView边框
        self.commentTextView.layer.borderWidth = 1
        self.commentTextView.layer.borderColor = UIColor.grayColor().CGColor
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
}
