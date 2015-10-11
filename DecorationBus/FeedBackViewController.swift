//
//  FeedBackViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-11-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit
import MessageUI

class FeedBackViewController: UIViewController, MFMailComposeViewControllerDelegate,UIScrollViewDelegate,UITextViewDelegate
{
    @IBOutlet weak var feedbackScrollView_: UIScrollView!
    
    var deviceHeight:CGFloat = 0.0;
    var feedbackTextView_ = UITextView();
    var placeholderLabel_ = UILabel();
    //let feedbackScrollView_ = UIScrollView();
    let pointMessageView_ = PointMessageViewController();
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.initDeviceHeight();
        self.addFeedBackScrollview();
        self.addFeedbackTextView();
        self.addPlaceholderLabel();
        self.addPointMessageView();
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
    
    
    @IBAction func DoneButton(sender: AnyObject)
    {
        print("DoneButton() 用户反馈: \(feedbackTextView_.text)")
        
        // 发送邮件
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        
        mailController.setToRecipients(["qdurenhongcai@163.com"])
        mailController.setSubject("来自用户的珍贵反馈")
        mailController.setMessageBody(feedbackTextView_.text, isHTML: false)
        self.presentViewController(mailController, animated: true, completion: nil)
    }
    
    //添加消息弹出界面
    func addPointMessageView()
    {
        let viewSize:CGSize = self.view.frame.size;
        let viewHeight:CGFloat = viewSize.height;
        let viewWidth:CGFloat = viewSize.width;
        
        let pointMessageViewRect:CGRect = CGRectMake((viewWidth - 120) / 2,
            (viewHeight - 50) / 2,
            120,
            50);
        pointMessageView_.view.frame = pointMessageViewRect;
        
        self.view.addSubview(pointMessageView_.view);
        
    }
    
    //添加ScrollView
    func addFeedBackScrollview()
    {
        feedbackScrollView_.delegate = self;
        feedbackScrollView_.backgroundColor = UIColor.clearColor();
    }
    
    //添加TextView
    func addFeedbackTextView()
    {
        let viewSize:CGSize = self.view.frame.size;
        let viewHeight:CGFloat = viewSize.height;
        let viewWidth:CGFloat = viewSize.width;
        
        let feedbackTextViewRect:CGRect = CGRectMake(0, 0, viewWidth, 200);
        feedbackTextView_.frame = feedbackTextViewRect;
        feedbackTextView_.delegate = self;
        feedbackTextView_.backgroundColor = UIColor.clearColor();
        feedbackTextView_.font = UIFont.systemFontOfSize(16.0);
        
        feedbackScrollView_.addSubview(feedbackTextView_);
        feedbackTextView_.becomeFirstResponder();
    }
    
    //添加Label
    func addPlaceholderLabel()
    {
        let placeholderLabelRect:CGRect = CGRectMake(3, 0, 300, 38);
        placeholderLabel_.frame = placeholderLabelRect;
        placeholderLabel_.font = UIFont.systemFontOfSize(14.0);
        placeholderLabel_.backgroundColor = UIColor.clearColor();
        placeholderLabel_.textColor = UIColor.lightGrayColor();
        placeholderLabel_.text = "请输入您的反馈意见(字数200字以内)";
        
        feedbackScrollView_.addSubview(placeholderLabel_);
    }
    
    //MARK: -UITextView Delegate
    func textViewDidChange(textView: UITextView)
    {
        let newLength = textView.text.characters.count;
        if (newLength == 0)
        {
            placeholderLabel_.text = "请输入您的反馈意见(字数200字以内)"
        }else
        {
            placeholderLabel_.text = "";
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        let newLength = textView.text.characters.count;
        if (newLength>201)
        {
            return false;
        }
        return true;
    }
    
    //MARK: -UIScrollView Delegate
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView)
    {
        feedbackTextView_.resignFirstResponder();
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        switch(result.rawValue)
        {
        case 0:
            pointMessageView_.setMessageView(0, withMessage: "邮件发送取消")
            pointMessageView_.removeMessageView(0);
            break;
        case 1:
            pointMessageView_.setMessageView(0, withMessage: "邮件保存成功")
            pointMessageView_.removeMessageView(0);
            break;
        case 2:
            pointMessageView_.setMessageView(0, withMessage: "邮件发送成功")
            pointMessageView_.removeMessageView(0);
            break;
        case 3:
            pointMessageView_.setMessageView(0, withMessage: "邮件发送失败")
            pointMessageView_.removeMessageView(0);
            break;
        default:
            break;
        }
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
