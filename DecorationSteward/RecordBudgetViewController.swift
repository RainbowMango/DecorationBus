//
//  RecordBudgetViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-24.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class RecordBudgetViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate/*, UIPickerViewDelegate, UIPickerViewDataSource*/ {

    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var shopTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addrTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBarButton()
        initTextFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
}
