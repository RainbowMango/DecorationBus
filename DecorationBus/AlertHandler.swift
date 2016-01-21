//
//  AlertHandler.swift
//  DecorationBus
//
//  Created by ruby on 16/1/21.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

func showSimpleAlert(sender: AnyObject, title: String, message: String) -> Void {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let alertAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: nil)
    alert.addAction(alertAction)
    sender.presentViewController(alert, animated: true, completion: nil)
}