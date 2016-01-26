//
//  AlertHandler.swift
//  DecorationBus
//
//  Created by ruby on 16/1/21.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

/*UIAlertController问题记录（IOS8，Xcode7.2）：
* 同一个view controller内先弹出UIAlertController再弹出UIImagePickerController时会报如下warning
* Warning: Attempt to present <UIAlertController: 0x7fb40c3d0d20>  on <DecorationBus.RegViewController: 0x7fb40a00fc00> which is already presenting (null)
* Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior (<UIAlertController: 0x7fb40c3d0d20>)
*
* 目前已知的workaround是同一个函数体内不能有多个alert controller。显示alert时使用dispatch_async.
*/
func showSimpleAlert(sender: AnyObject, title: String, message: String) -> Void {
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(alertAction)
        sender.presentViewController(alert, animated: true, completion: nil)
    }
//    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//    let alertAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: nil)
//    alert.addAction(alertAction)
//    sender.presentViewController(alert, animated: true, completion: nil)
}