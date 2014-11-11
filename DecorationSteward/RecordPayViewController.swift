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
    
    @IBOutlet weak var payTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addrTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var catagoryPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置空间的代理到本Controller，也可以在IB中连线
        self.payTextField.delegate = self
        self.brandTextField.delegate = self
        self.phoneTextField.delegate = self
        self.addrTextField.delegate = self
        self.commentTextView.delegate = self
        self.catagoryPickerView.delegate = self
        
        // 设置Navigation right bar item
        self.rightBarButton.title = "完成"
        
        // Do any additional setup after loading the view.
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

    // 用户首次开始输输入时清空原内容
    func textViewDidBeginEditing(textView: UITextView) {
        if self.commentTextView.text == "<点击输入备注>" {
            self.commentTextView.text = nil
        }
    }
    
    // 用户完成表单输入
    @IBAction func finishRecord(sender: AnyObject) {
        println("finishRecord() 用户完成输入")
        
        // 取得表单信息
        println("已花费：\(self.payTextField.text)")
        println("品牌：\(self.brandTextField.text)")
        println("商家电话：\(self.phoneTextField.text)")
        println("商家地址：\(self.addrTextField.text)")
        println("备注：\(self.commentTextView.text)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
