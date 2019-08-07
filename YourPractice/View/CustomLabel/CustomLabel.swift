//
//  CustomLabel.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit
/**
 The purpose of the `CustomLabel` class where we can add our button related code over here which will be reflected everywhere where we can use this class.
 
 The `CustomLabel` class is a subclass of the `UIResponder`.
 */
class CustomLabel: UILabel {

    @IBInspectable open var labelTextColor: UIColor = .black {
        willSet{
            self.textColor = newValue
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.backgroundColor = Config.ClearColor
        self.textColor = Config.BlackColor
    }
    
    //MARK: set text and font in UILabel
    /**
     - Parameter lblText: It is a String type value.
     - Parameter lblFont: It is a UIFont type value.
     - Parameter attributedText: It is a NSAttributedString type value.
     - Parameter isAttributedText: It is a Bool type value.
      - Parameter lblTextAlignment: It is a NSTextAlignment type value.
     */
    func setCustomLable(lblText : String,lblTextColor : UIColor,lblFont : UIFont,lblAttributedText: NSAttributedString,isAttributedText : Bool,lblTextAlignment : NSTextAlignment){
        switch isAttributedText {
        case true:
            self.attributedText = lblAttributedText
        default:
            self.text = lblText
            self.font = lblFont
            self.textColor = lblTextColor
        }
        self.textAlignment = lblTextAlignment
    }
}
