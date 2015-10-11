//
//  CategoryPrimeAddViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-11-27.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class CategoryPrimeAddViewController: UIViewController {
    
    @IBOutlet weak var newPrimeCategoryTextField: UITextField!
    
    var parentView: CatagoryPrimeMangeViewController?
    var delegate: CategoryPrimeAddViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initBarButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.delegate = parentView
        self.delegate?.CategoryPrimeAddView(self.newPrimeCategoryTextField.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBarButton() -> Void {
        let btn = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Bordered, target: self, action: "barButtonClicked")
        self.navigationItem.rightBarButtonItem = btn
    }
    
    //新增大类
    //TODO：新增大类时，同时也要增加子类
    func barButtonClicked() {
        print("barButtonClicked")
        if self.newPrimeCategoryTextField.text.isEmpty {
            // 弹出Alert
            showAlert()
            return
        }
        
        CategoryHandler().addPrimeCategory(self.newPrimeCategoryTextField.text)
        
        // 记录后返回到上层
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showAlert() -> Void {
        let alertView = UIAlertView(title: "空值", message: "请输入正确的大类名", delegate: self, cancelButtonTitle: "好的")
        alertView.show()
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

// 定义代理，用于向前个view传值
protocol CategoryPrimeAddViewControllerDelegate {
    func CategoryPrimeAddView(categoryAdded: String) -> Void
}
