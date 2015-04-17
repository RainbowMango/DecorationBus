//
//  PointMessageViewController.swift
//  DecorationBus
//
//  Created by duan on 14/12/1.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

let DeviceSystemVersion =  (UIDevice.currentDevice().systemVersion as  NSString).floatValue

class PointMessageViewController: UIViewController
{
    let boxView      =  UIView();
    var loadLabel    =  UILabel();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        self.addBoxView();
    }
    
    func addBoxView()
    {
        //背景界面
        boxView.backgroundColor = UIColor(red: 100.0/255.0,
            green: 100.0/255.0,
            blue: 100.0/255.0,
            alpha: 1.0);
        boxView.layer.cornerRadius = 4.0;
        boxView.alpha = 0.0;
        
        //状态文字
        loadLabel.backgroundColor = UIColor.clearColor();
        loadLabel.textColor       = UIColor.whiteColor();
        loadLabel.textAlignment   = NSTextAlignment.Center;
        loadLabel.font            = UIFont.systemFontOfSize(12.0);
        loadLabel.numberOfLines   = 2;
        loadLabel.text            = "努力加载中...";
        loadLabel.alpha           = 0.0;
        
        self.view.addSubview(boxView);
        self.view.addSubview(loadLabel);
    }
    
    func setMessageView(sender:AnyObject, withMessage message:NSString)
    {
        let viewSize:CGSize = self.view.frame.size;
        let viewHeight:CGFloat = viewSize.height;
        let viewWidth:CGFloat = viewSize.width;
        
        let labelAttributes = NSAttributedString(string:message as String);
        let attributes = [NSFontAttributeName: [UIFont.systemFontOfSize(12.0)]]
        let labelFont:UIFont = loadLabel.font;
        let labelRect:CGRect = message.boundingRectWithSize(CGSizeMake(250, CGFloat.max),
            options: (NSStringDrawingOptions.UsesLineFragmentOrigin),
            attributes: nil,
            context: nil)
        //let labelRect:CGRect = message.boun
        
        let boxViewRect:CGRect = CGRectMake((viewWidth / 2) - (250 / 2),
            (viewHeight / 2) - (95 / 2),
            250,
            labelRect.size.height+20);
        boxView.frame =  boxViewRect;
        boxView.alpha = 1.0;
        
        let loadLabelRect:CGRect = CGRectMake((viewWidth / 2) - (250 / 2),
            (viewHeight - 43 ) / 2 - 26,
            250,
            labelRect.size.height+20);
        loadLabel.text = message as String;
        loadLabel.frame = loadLabelRect;
        loadLabel.alpha = 1.0;
    }
    
    func removeMessageView(sender:AnyObject)
    {
        UIView.animateWithDuration(2.5, animations:
            {
                self.loadLabel.alpha = 0.0;
                self.boxView.alpha = 0.0;
        })
    }
}
