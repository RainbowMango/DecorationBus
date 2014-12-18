//
//  AboutMeViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

let IosAppVersion:NSString =  (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as NSString);//[[[NSBundle mainBundle]

class AboutMeViewController: UIViewController
{
    var deviceHeight:CGFloat = 0.0;
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.addLogoView();
        self.addCopyrightView();
    }
    
    func initDeviceHeight()
    {
        if (DeviceSystemVersion>7.0)
        {
            deviceHeight = 60.0;
        }else
        {
            deviceHeight = 0.0;
        }
    }
    
    func addLogoView()
    {
        let viewSize:CGSize = self.view.frame.size;
        let viewHeight:CGFloat = viewSize.height;
        let viewWidth:CGFloat = viewSize.width;
        
        let logoImageView:UIImageView = UIImageView();
        let logoImageViewRect:CGRect = CGRectMake((viewWidth-110)/2, 44+deviceHeight+80, 110, 110);
        logoImageView.frame = logoImageViewRect;
        logoImageView.layer.cornerRadius = 10.0;
        logoImageView.layer.masksToBounds = true;
        logoImageView.image = UIImage(named:"Icon-76@3x");
        
        let logoLabel:UILabel = UILabel();
        let logoLabelRect:CGRect = CGRectMake(0, 44+deviceHeight+80+20+110, viewWidth, 20);
        logoLabel.frame = logoLabelRect;
        logoLabel.textAlignment = NSTextAlignment.Center;
        logoLabel.font = UIFont.systemFontOfSize(14.0);
        logoLabel.backgroundColor = UIColor.clearColor();
        logoLabel.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0);
        logoLabel.text = "当前版本: "+IosAppVersion;
        
        self.view.addSubview(logoImageView);
        self.view.addSubview(logoLabel);
    }
    
    func addCopyrightView()
    {
        let viewSize:CGSize = self.view.frame.size;
        let viewHeight:CGFloat = viewSize.height;
        let viewWidth:CGFloat = viewSize.width;
        
        let emailLabel:UILabel = UILabel();
        let emailLabelRect:CGRect = CGRectMake(0, viewHeight - 80 - 30, viewWidth, 20);
        emailLabel.frame = emailLabelRect;
        emailLabel.textAlignment = NSTextAlignment.Center;
        emailLabel.font = UIFont.systemFontOfSize(12.0);
        emailLabel.backgroundColor = UIColor.clearColor();
        emailLabel.textColor = UIColor(red: 88.0/255.0, green: 88.0/255.0, blue: 88.0/255.0, alpha: 1.0);
        emailLabel.text = "联系邮箱: qdurenhongcai@163.com";
        
        let copyrightLabel:UILabel = UILabel();
        let copyrightLabelRect:CGRect = CGRectMake(0, viewHeight - 80, viewWidth, 20);
        copyrightLabel.frame = copyrightLabelRect;
        copyrightLabel.textAlignment = NSTextAlignment.Center;
        copyrightLabel.font = UIFont.systemFontOfSize(12.0);
        copyrightLabel.backgroundColor = UIColor.clearColor();
        copyrightLabel.textColor = UIColor(red: 15.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1.0);
        copyrightLabel.text = "Copyright ©｜装修助手,版权所有";
        
        self.view.addSubview(emailLabel);
        self.view.addSubview(copyrightLabel);
    }
    
    
}
