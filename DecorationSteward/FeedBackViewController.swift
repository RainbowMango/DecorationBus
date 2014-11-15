//
//  FeedBackViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController {

    @IBOutlet weak var feedbackTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func DoneButton(sender: AnyObject) {
        println("DoneButton() 用户反馈: \(self.feedbackTextView.text)")
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
