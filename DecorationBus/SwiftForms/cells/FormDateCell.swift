//
//  FormDateCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 22/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

class FormDateCell: FormValueCell {

    /// MARK: Properties
    
    private let datePicker = UIDatePicker()
    private let hiddenTextField = UITextField(frame: CGRectZero)
    private let defaultDateFormatter = NSDateFormatter()
    
    /// MARK: FormBaseCell
    
    override func configure() {
        super.configure()
        contentView.addSubview(hiddenTextField)
        hiddenTextField.inputView = datePicker
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
    }
    
    override func update() {
        super.update()
        
        if rowDescriptor.showInputToolbar && hiddenTextField.inputAccessoryView == nil {
            hiddenTextField.inputAccessoryView = inputAccesoryView()
        }
        
        titleLabel.text = rowDescriptor.title
        
        switch rowDescriptor.rowType {
        case .Date:
            datePicker.datePickerMode = .Date
            defaultDateFormatter.dateStyle = .LongStyle
            defaultDateFormatter.timeStyle = .NoStyle
        case .Time:
            datePicker.datePickerMode = .Time
            defaultDateFormatter.dateStyle = .NoStyle
            defaultDateFormatter.timeStyle = .ShortStyle
        default:
            datePicker.datePickerMode = .DateAndTime
            defaultDateFormatter.dateStyle = .LongStyle
            defaultDateFormatter.timeStyle = .ShortStyle
        }
        
        if rowDescriptor.value != nil {
            let date = rowDescriptor.value as? NSDate
            datePicker.date = date!
            valueLabel.text = self.getDateFormatter().stringFromDate(date!)
        }
    }
    
    override class func formViewController(formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        
        let row: FormDateCell! = selectedRow as? FormDateCell
        
        if row.rowDescriptor.value == nil {
            let date = NSDate()
            row.rowDescriptor.value = date
            row.valueLabel.text = row.getDateFormatter().stringFromDate(date)
            row.update()
        }
        
        row.hiddenTextField.becomeFirstResponder()
    }
    
    override func firstResponderElement() -> UIResponder? {
        return hiddenTextField
    }
    
    override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    /// MARK: Actions
    
    func valueChanged(sender: UIDatePicker) {
        rowDescriptor.value = sender.date
        valueLabel.text = getDateFormatter().stringFromDate(sender.date)
        update()
    }
    
    /// MARK: Private interface
    
    private func getDateFormatter() -> NSDateFormatter {
        if self.rowDescriptor.dateFormatter != nil {
            return self.rowDescriptor.dateFormatter
        }
        return defaultDateFormatter
    }
}
