//
//  CustomDatePicker.swift
//  YourPractice
//
//  Created by Devangi Shah on 12/03/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import Foundation
import UIKit

/**
 Create enum for tab bar methods.
 */

enum DatePickerToolBarAction {
    case done
    case cancel
}

/**
 The purpose of "CustomPickerView" where we can use UIDatePicker.
 */

class customDatePicker: UIDatePicker {
    
    //MARK: Design variables
    /// create object of UIToolbar
    let dateToolBar = UIToolbar()
    
    /// create an object for transperant view
    let transperantView =  UIView.init()
    
    //MARK: custom closure Variables
    
    /// create an object of select Date closure from Date pickerView
    var onSelectedDate: ((_ selectedDate: String) -> Void)?
    
    /// create an object of custom closure for tool bar actions
    var toolbarAction: ((_ toolbarAction: DatePickerToolBarAction) -> Void)?
    
    //MARK: init Method
    /**
     - Parameter frame: It is a CGRect type value.
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /**
     - Parameter coder: It is a NSCoder type value.
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //structure dynamic enum
    //optional min max date - Done
    //MARK: common set up for Date Picker
    @objc func commonDatePickerSetup(datePickerMode : UIDatePicker.Mode,minDate : Date? = nil,maxDate : Date? = nil,selectedDate : Date) {
        
        setupDatePickerTransperantView()
        setupDatePicker()
        setupDatePickerToolbar()
        setupCustomDatePickerDates(datePickerMode: datePickerMode,minDate: minDate, maxDate: maxDate,selectedDate: selectedDate)
    }
    
    //MARK: set up transperant view in current UIViewController
    @objc func setupDatePickerTransperantView(){
        transperantView.frame = MainWindow.frame
        transperantView.backgroundColor = UIColor.clear
        MainNavigation?.topViewController?.view.addSubview(transperantView)
    }
    //MARK: set up Date Picker in current UIViewController
    @objc func setupDatePicker(){
        self.frame =  CGRect(x: 0, y: kDEVICE_HEIGHT - kPICKER_HEIGHT, width: MainWindow.frame.width, height: kPICKER_HEIGHT)
        self.backgroundColor = Config.BlackColor.withAlphaComponent(0.2)
        MainNavigation?.topViewController?.view.addSubview(self)
    }
    
    //MARK: set up dynamic data in Date Picker in current UIViewController
    @objc func setupCustomDatePickerDates(datePickerMode : UIDatePicker.Mode,minDate : Date? = nil,maxDate : Date? = nil,selectedDate : Date){
        self.datePickerMode = datePickerMode
        if maxDate != nil{
            self.maximumDate = maxDate
        }
        if minDate != nil{
            self.minimumDate = minDate
        }
        self.setDate(selectedDate, animated: true)
    }
    
     //MARK: set up Tool bar in Date Picker in current UIViewController
    @objc func setupDatePickerToolbar(){
          dateToolBar.frame = CGRect(x: 0, y: self.frame.origin.y - kPICKER_TOOLBAR_HEIGHT, width: kDEVICE_WIDTH, height: kPICKER_TOOLBAR_HEIGHT)
        
        dateToolBar.barStyle = UIBarStyle.default
        dateToolBar.isTranslucent = true
        dateToolBar.tintColor = UIColor.darkText
        
        dateToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        
        dateToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        MainNavigation?.topViewController?.view.addSubview(self.dateToolBar)
    }
    
    //MARK: set up IBAction button methods in Tool bar in Date Picker in current UIViewController
    
    /// create done method for UIToolbar button
    @objc func donePicker(){
        if let block = toolbarAction {
            block(.done)
        }
        self.transperantView.removeFromSuperview()
        self.removeFromSuperview()
        self.dateToolBar.removeFromSuperview()
    }
    
    /// create cancel method for UIToolbar button
    @objc func cancelPicker(){
        if let block = toolbarAction {
            block(.cancel)
        }
        self.transperantView.removeFromSuperview()
        self.removeFromSuperview()
        self.dateToolBar.removeFromSuperview()
    }
}
