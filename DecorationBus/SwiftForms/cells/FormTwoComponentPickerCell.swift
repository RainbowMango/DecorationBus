//
//  FormTwoComponentPickerCell.swift
//  SwiftForms
//
//  Created by ruby on 15-1-9.
//  Copyright (c) 2015年 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

class FormTwoComponentPickerCell: FormValueCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /// MARK: Properties
    
    private let picker = UIPickerView()
    private let hiddenTextField = UITextField(frame: CGRectZero)
    
    private var firstComponentArray_: Array<String>!
    private var secondComponentArray_: Array<String>!
    private var firstComponentValue_: String!
    private var secondComponentValue_: String!
    
    /// MARK: FormBaseCell
    
    override func configure() {
        super.configure()
        accessoryType = .None
        
        picker.delegate = self
        picker.dataSource = self
        hiddenTextField.inputView = picker
        
        contentView.addSubview(hiddenTextField)
    }
    
    override func update() {
        super.update()
        
        titleLabel.text = rowDescriptor.title
        
        if rowDescriptor.value != nil {
            //valueLabel.text = rowDescriptor.titleForOptionValue(rowDescriptor.value)
            let value = rowDescriptor.value as Array<String>
            valueLabel.text = "\(value[0])-\(value[1])"
            rowDescriptor.value = nil
        }
    }
    
    override class func formViewController(formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        let row = selectedRow as FormTwoComponentPickerCell
        
        /*Initialize component array and selected value for first time selected */
        if(row.rowDescriptor.value == nil) {
            row.firstComponentArray_ = Array(row.rowDescriptor.pickerDatasourceWithTwoComponent.keys)
            row.firstComponentValue_ = row.firstComponentArray_[0]
            row.secondComponentArray_ = row.rowDescriptor.pickerDatasourceWithTwoComponent[row.firstComponentValue_]
            row.secondComponentValue_ = row.secondComponentArray_[0]
            
            row.rowDescriptor.value = [row.firstComponentValue_, row.secondComponentValue_]
            row.valueLabel.text = "\(row.firstComponentValue_)-\(row.secondComponentValue_)"
        }
        
        row.hiddenTextField.becomeFirstResponder()
    }
    
    /// MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch component {
        case 0:
            return firstComponentArray_[row]
        case 1:
            return secondComponentArray_[row]
        default:
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(0 == component) {/*update second component array when first component value changed*/
            secondComponentArray_ = rowDescriptor.pickerDatasourceWithTwoComponent[firstComponentArray_[row]]
            self.picker.reloadComponent(1)
            self.picker.selectRow(0, inComponent: 1, animated: true)
            firstComponentValue_ = firstComponentArray_[row]
            secondComponentValue_ = secondComponentArray_[0]
        }
        else {
            secondComponentValue_ = secondComponentArray_[row]
        }
        
        rowDescriptor.value = [firstComponentValue_, secondComponentValue_]
        valueLabel.text = "\(firstComponentValue_)-\(secondComponentValue_)"
    }
    
    /// MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return rowDescriptor.options.count
        var count: Int = 0
        switch component {
        case 0:
            count = firstComponentArray_.count
        case 1:
            count = secondComponentArray_.count
        default:
            count = 0
        }
        
        return count
    }
}
