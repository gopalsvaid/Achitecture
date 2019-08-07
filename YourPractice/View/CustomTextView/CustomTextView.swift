//
//  CustomTextView.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

/**
 The purpose of the `CustomTextView` class where we can add our button related code over here which will be reflected everywhere where we can use this class.
 
 The `CustomTextView` class is a subclass of the `UIResponder`.
 */
class CustomTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
     //MARK: set text , font and Border in UITextView
    /**
     - Parameter txtViewText: It is a String type value.
     - Parameter txtViewFont: It is a UIFont type value.
     - Parameter txtViewBorderColor: It is a UIColor type value.
     - Parameter txtViewBorderWidth: It is a CGFloat type value.
     */
    func setCustomTextView(txtViewText : String,txtViewFont : UIFont,txtViewBorderColor : UIColor?,txtViewBorderWidth: CGFloat?){
        self.text = txtViewText
        self.font = txtViewFont
        
        guard let borderWidth = txtViewBorderWidth else{
            return
        }
        self.layer.borderWidth = borderWidth
        
        guard let borderColor = txtViewBorderColor else{
            return
        }
        self.layer.borderColor = borderColor.cgColor
    }
}
