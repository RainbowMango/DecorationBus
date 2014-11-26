//
//  CategoryMinorAddViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-26.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class CategoryMinorAddViewController: UIViewController {

    @IBOutlet weak var newMinorCategoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initBarButton()
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
