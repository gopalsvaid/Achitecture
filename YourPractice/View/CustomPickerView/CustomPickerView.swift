//
//  CustomPickerView.swift
//  Bidmo
//
//  Created by Devangi Shah on 8/4/18.
//  Copyright © 2018 Radixweb. All rights reserved.
//

import UIKit
import SwiftyJSON
/**
 Create enum for tab bar methods.
 */
enum PickerToolBarAction {
    case done
    case cancel
}

/**
 The purpose of "CustomPickerView" where we can use UIPickerView.
 */

class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Design variables
    /// create object of UIToolbar
    let toolBar = UIToolbar()
    
    /// create an object for transperant view
    let transperantView =  UIView.init()
   
    
    //MARK: Data Variables
    /// create array object for Structure Data
    var arrStructureData: [PickerData]!
    
    /// create array object for Json Data
    var arrJsonData = JSON.null
    
    /// create selectd Data for selected previous data
    var selectedStructureData = PickerData()
    
    /// create selectdData for selected previous data
    var selectedJSONData = JSON.null
    
    //MARK: Methods Variables
    /// create an object of select Data closure from Picker View
    var onSelectedStructureData: ((_ selectedStructureData: PickerData) -> Void)?
    var onSelectedJsonData: ((_ selectedJsonData: JSON) -> Void)?
    
     /// create an object of custom closure for tool bar actions
    var toolbarAction: ((_ toolbarAction: PickerToolBarAction ) -> Void)?
   
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
    
    //MARK: common set up for UIPicker View
    @objc func commonPickerSetup() {
        
        /// set up transperant view
        setupPickerTransperantView()
        
        /// set up Picker View
        setupPickerView()
        
        /// set up UIToolbar in Picker View
        setupDataPickerToolbar()
        
        /// set up dynamic data in Picker View
        setupCustomPickerData()
    }
    
    //MARK: set up transperant view in current UIViewController
    @objc func setupPickerTransperantView(){
        transperantView.frame = MainWindow.frame
        transperantView.backgroundColor = UIColor.clear
        MainNavigation?.topViewController?.view.addSubview(transperantView)
    }
    
    //MARK: set up Picker View in current UIViewController
    @objc func setupPickerView(){
        
        self.frame =  CGRect(x: 0, y: kDEVICE_HEIGHT - kPICKER_HEIGHT, width: kDEVICE_WIDTH, height: kPICKER_HEIGHT)
        self.backgroundColor = Config.BlackColor.withAlphaComponent(0.2)
        MainNavigation?.topViewController?.view.addSubview(self)
    }
    
    //MARK: set up dynamic data in Picker View in current UIViewController
    @objc func setupCustomPickerData(){
        self.delegate = self
        self.dataSource = self
        if arrStructureData != nil{
            let index = arrStructureData.enumerated().filter{($0.element.pickerId == selectedStructureData.pickerId)}.map{$0.offset}
            DispatchQueue.main.async {
                self.selectRow(index.count == 0 ? 0 : index[0], inComponent: 0, animated: true)
            }
        }else{
            let index = arrJsonData.enumerated().filter{($0.element.1["empCode"].intValue) == selectedJSONData.dictionary?["empCode"]?.int}.map{$0.offset}
            DispatchQueue.main.async {
                self.selectRow(index.count == 0 ? 0 : index[0], inComponent: 0, animated: true)
            }
        }
    }
    
    //MARK: set up Tool bar in Picker View in current UIViewController
    @objc func setupDataPickerToolbar(){
        
        toolBar.frame = CGRect(x: 0, y: self.frame.origin.y - kPICKER_TOOLBAR_HEIGHT, width: kDEVICE_WIDTH, height: kPICKER_TOOLBAR_HEIGHT)
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkText
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        MainNavigation?.topViewController?.view.addSubview(self.toolBar)
    }
    
    //MARK: set up IBAction button methods in Tool bar in Picker View in current UIViewController
    /// create done method for UIToolbar button
    @objc func donePicker(){
        if let block = toolbarAction {
            block(.done)
        }
        self.transperantView.removeFromSuperview()
        self.removeFromSuperview()
        self.toolBar.removeFromSuperview()
        
    }
    
    /// create cancel method for UIToolbar button
    @objc func cancelPicker(){
        if let block = toolbarAction {
            block(.cancel)
        }
        self.transperantView.removeFromSuperview()
        self.removeFromSuperview()
        self.toolBar.removeFromSuperview()
    }
    
    // Mark: UIPicker View Data source Methods
    
    /// Called by the picker view when it needs the number of components.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// Called by the picker view when it needs the number of rows for a specified component.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if arrStructureData != nil{
             return arrStructureData.count
        }else{
            return arrJsonData.arrayObject?.count ?? 0
        }
    }
    
    // Mark: UIPicker View Delegate Methods
    
    /// Called by the picker view when it needs the title to use for a given row in a given component.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if arrStructureData != nil{
            return "\(arrStructureData[row].strTitle ?? "")"
        }else{
            return "\(arrJsonData[row]["empFName"].string ?? "") \(arrJsonData[row]["empLName"].string ?? "")"
        }
    }
    
    /// Called by the picker view when the user selects a row in a component.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let index = self.selectedRow(inComponent: 0)
        
        if arrStructureData != nil{
            if let block = onSelectedStructureData {
                block(arrStructureData[index])
            }
        }else{
            if let block = onSelectedJsonData {
                block(arrJsonData[index])
            }
        }
    }
}
