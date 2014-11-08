//
//  ViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-10-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var paid: UILabel!

    @IBOutlet weak var paying: UILabel!

    @IBOutlet weak var total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paid!.text = "支出总额：12000.00"
        
        paying.text = "预算余额：12690.00"
        
        total.text = "预算总额：24690.00"
        
        // Do any additional setup after loading the view, typically from a nib.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func record(sender: UIButton) {
        paid!.text = "支出总额：12000.00"
        paying!.text = "预算余额：12690.00"
        total!.text = "预算总额：24690.00"
    }

}

