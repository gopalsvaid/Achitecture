//
//  CustomTextField.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

/**
 The purpose of the `CustomTextField` class where we can add our button related code over here which will be reflected everywhere where we can use this class.
 
 The `CustomTextField` class is a subclass of the `UIResponder`.
 */
open class CustomTextField: UITextField {

    @IBInspectable open var textFieldBorderColor: UIColor = .black {
        willSet{
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable open var textFieldBorderWidth: CGFloat = 2.0 {
        willSet{
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable open var textFieldRightPaddingWidth: CGFloat = 0.0{
        willSet{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
    @IBInspectable open var textFieldLeftPaddingWidth: CGFloat = 0.0{
        willSet{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
    
    /*
    @IBInspectable open var textFieldLeftSideImage: UIImage!{
        willSet{
            let imageView = UIImageView(frame : CGRect(x: 0, y: 0, width: self.frame.size.height - 5.0, height: self.frame.size.height - 5.0))
            imageView.image = newValue
            imageView.contentMode = .scaleAspectFit
            self.leftView = imageView
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable open var textFieldRightSideImage: UIImage!{
        willSet{
            let imageView = UIImageView(frame : CGRect(x: 0, y: 0, width: self.frame.size.height - 5.0, height: self.frame.size.height - 5.0))
            imageView.image = newValue
            imageView.contentMode = .scaleAspectFit
            self.rightView = imageView
            self.rightViewMode = .always
        }
    }
 */
    
    //MARK: set text , font , Border , left and right padding in UITextField
    /**
     - Parameter txtFieldText: It is a String type value.
     - Parameter txtFieldPlaceHolder: It is a String type value.
     - Parameter txtFieldFont: It is a UIFont type value.
     - Parameter txtFieldBorderColor: It is a UIColor type value.
     - Parameter txtFieldBorderWidth: It is a CGFloat type value.
     - Parameter isLeftPadding: It is a CGFloat type value.
     - Parameter txtFieldLeftPadding: It is a CGFloat type value.
     - Parameter isRightPadding: It is a Bool type value.
     - Parameter txtFieldRightPadding: It is a CGFloat type value.
     - Parameter isLeftSideImage: It is a Bool type value.
     - Parameter strLeftSideImage: It is a String type value.
     - Parameter frameLeftSideImage: It is a CGFloat type value.
     - Parameter isRightSideImage: It is a Bool type value.
     - Parameter strRightSideImage: It is a String type value.
     - Parameter frameRightSideImage: It is a CGFloat type value.
     */
    func setCustomTextField(txtFieldText : String,txtFieldPlaceHolder : String,txtFieldFont : UIFont,txtFieldBorderColor : UIColor,txtFieldBorderWidth: CGFloat,isLeftPadding : Bool,txtFieldLeftPadding : CGFloat,isRightPadding : Bool,txtFieldRightPadding : CGFloat,isLeftSideImage : Bool,strLeftSideImage  :String,frameLeftSideImage  :CGRect,isRightSideImage : Bool,strRightSideImage  :String,frameRightSideImage  :CGRect){
        self.placeholder = txtFieldPlaceHolder
        self.text = txtFieldText
        self.font = txtFieldFont
        self.layer.borderColor = txtFieldBorderColor.cgColor
        self.layer.borderWidth = txtFieldBorderWidth
        self.leftView = nil
        self.rightView = nil
        
        if isLeftPadding{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: txtFieldLeftPadding, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        if isRightPadding{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: txtFieldLeftPadding, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
        
        if isLeftSideImage{
            let imageView = UIImageView(frame : frameLeftSideImage)
            imageView.frame = frameLeftSideImage
            imageView.image = UIImage(named: strLeftSideImage)
            self.leftView = imageView
        }
        if isRightSideImage{
            let imageView = UIImageView(frame : frameRightSideImage)
            imageView.frame = frameRightSideImage
            imageView.image = UIImage(named: strRightSideImage)
            self.rightView = imageView
        }
    }
}
