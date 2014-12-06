//
//  SpinnerViewController.swift
//  SwiftStart
//
//  Created by duan on 14/12/1.
//  Copyright (c) 2014年 duan. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController
{
    let spinner      =  UIActivityIndicatorView();
    let boxView      =  UIView();
    var spinnerLabel =  UILabel();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        self.addSpinnerView();
    }
    
    func addSpinnerView()
    {
        //菊花
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White;
        spinner.alpha = 0.0;
        
        //背景界面
        boxView.backgroundColor = UIColor(red: 100.0/255.0,
            green: 100.0/255.0,
            blue: 100.0/255.0,
            alpha: 1.0);
        boxView.layer.cornerRadius = 4.0;
        boxView.alpha = 0.0;
        
        //状态文字
        spinnerLabel.backgroundColor = UIColor.clearColor();
        spinnerLabel.textColor       = UIColor.whiteColor();
        spinnerLabel.textAlignment   = NSTextAlignment.Center;
        spinnerLabel.font            = UIFont.systemFontOfSize(12.0);
        spinnerLabel.text            = "努力加载中..."
        spinnerLabel.alpha           = 0.0;
        
        self.view.addSubview(boxView);
        self.view.addSubview(spinner);
        self.view.addSubview(spinnerLabel);
    }
    
    func startSpinnerView(sender:AnyObject)
    {
        let viewSize:CGSize = self.view.frame.size;
        let viewHeight:CGFloat = viewSize.height;
        let viewWidth:CGFloat = viewSize.width;
        
        spinner.startAnimating();
        let spinnerRect:CGRect = CGRectMake((viewWidth / 2) - (37 / 2),
            (viewHeight / 2) - (37 / 2) - 15,
            37,
            37);
        spinner.frame = spinnerRect;
        spinner.alpha = 0.0;
        
        let boxViewRect:CGRect = CGRectMake((viewWidth / 2) - (120 / 2),
            (viewHeight / 2) - (50 / 2) - 10,
            120,
            50);
        boxView.frame =  boxViewRect;
        boxView.alpha = 0.0;
        
        let spinnerLabelRect:CGRect = CGRectMake((viewWidth / 2) - (150 / 2),
            (viewHeight - 43 ) / 2 + 5,
            150,
            43);
        spinnerLabel.frame = spinnerLabelRect;
        spinnerLabel.alpha = 0.0;
        
        UIView.animateWithDuration(0.35, animations: {
            self.spinner.alpha = 1.0;
            self.boxView.alpha = 1.0;
            self.spinnerLabel.alpha = 1.0;})
        
    }
    
    func stopSpinnerView(sender:AnyObject)
    {
        spinner.stopAnimating();
        
        UIView.animateWithDuration(0.35, animations:
            {
                self.spinner.alpha = 0.0;
                self.boxView.alpha = 0.0;
                self.spinnerLabel.alpha = 0.0;
            })
    }
    
}
