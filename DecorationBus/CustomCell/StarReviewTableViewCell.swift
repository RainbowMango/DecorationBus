//
//  StarReviewTableViewCell.swift
//  DecorationBus
//
//  Created by ruby on 16/3/26.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit
import StarReview

class StarReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var starView: StarReview!
    
    var score            = 0 // 根据星星数量计算得出的分数
    let defaultStarCount = 5 // 默认的星星数量
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /**
     配置cell入口
     
     - parameter key: 评论项目名称
     */
    func configure(key: String) -> Void {
        self.itemName.text = key
        configureStarView()
    }
    
    /**
     配置星星view，防止cell重用时有残留，重新设置view
     注：务必清除view背景色，否则在cell选中状态下与星星颜色有冲突
     
     */
    private func configureStarView() -> Void {
        starView.value               = 0
        starView.starCount           = defaultStarCount
        starView.allowAccruteStars   = true
        starView.starBackgroundColor = UIColor.lightGrayColor()
        starView.starFillColor       = UIColor.orangeColor()
        starView.backgroundColor     = UIColor.clearColor()
        score                        = 0
        
        starView.addTarget(self, action: #selector(self.valueChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    /**
     选中星星图标时触发事件。
     
     - parameter sender: 触发事件的StarReview
     */
    func valueChange(sender:StarReview) -> Void {
        score = Int((sender.value / Float(defaultStarCount)) * 100)
        
        print("当前得分: \(score)")
    }
}
