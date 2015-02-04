//
//  CategoryMinorAddViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-11-26.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class CategoryMinorAddViewController: UIViewController {

    @IBOutlet weak var newMinorCategoryTextField: UITextField!
    
    var primeCategorySelected: String = String() // 获取前个页面的大类名
    var parentView: CatagoryMinorManageViewController?
    var delegate: CategoryMinorAddViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initBarButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.delegate = parentView
        self.delegate?.CategoryMinorAddView(self.newMinorCategoryTextField.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBarButton() -> Void {
        let btn = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Bordered, target: self, action: "barButtonClicked")
        self.navigationItem.rightBarButtonItem = btn
    }

    func barButtonClicked() {
        println("barButtonClicked")
        if self.newMinorCategoryTextField.text.isEmpty {
            // 弹出Alert
            showAlert()
            return
        }
        
        CategoryHandler().addMinorCategory(self.primeCategorySelected, minorCategory: self.newMinorCategoryTextField.text)
        
        // 记录后返回到上层
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showAlert() -> Void {
        var alertView = UIAlertView(title: "空值", message: "请输入正确的子类名", delegate: self, cancelButtonTitle: "好的")
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
protocol CategoryMinorAddViewControllerDelegate {
    func CategoryMinorAddView(categoryAdded: String) -> Void
}
