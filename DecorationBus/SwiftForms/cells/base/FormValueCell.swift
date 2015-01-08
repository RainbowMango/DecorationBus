//
//  FormValueCell.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 13/11/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

class FormValueCell: FormBaseCell {
    
    /// MARK: Cell views
    
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    
    /// MARK: Properties
    
    private var customConstraints: [AnyObject]!
    
    /// MARK: FormBaseCell
    
    override func configure() {
        super.configure()
        
        accessoryType = .DisclosureIndicator
        
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        valueLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        valueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        valueLabel.textColor = UIColor.lightGrayColor()
        valueLabel.textAlignment = .Right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        
        // apply constant constraints
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: valueLabel, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: valueLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
    
    override func constraintsViews() -> [String : UIView] {
        return ["titleLabel" : titleLabel, "valueLabel" : valueLabel]
    }
    
    override func defaultVisualConstraints() -> [String] {
        
        // apply default constraints
        var rightPadding = 0
        if accessoryType == .None {
            rightPadding = 16
        }
        
        if titleLabel.text != nil && countElements(titleLabel.text!) > 0 {
            return ["H:|-16-[titleLabel]-[valueLabel]-\(rightPadding)-|"]
        }
        else {
            return ["H:|-16-[valueLabel]-\(rightPadding)-|"]
        }
    }
}
