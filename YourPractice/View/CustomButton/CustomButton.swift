//
//  CustomButton.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

/**
 The purpose of the `CustomButton` class where we can add our button related code over here which will be reflected everywhere where we can use this class.
 
 The `CustomButton` class is a subclass of the `UIResponder`.
 */

class CustomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    //MARK: set background Color ,Tint Color , Border , Shadow , font , text and image in UIbutton
    /**
      set background Color ,Tint Color , Border , Shadow , font , text and image in UIbutton
     - Parameter btnFrame: It is a CGRect type value.
     - Parameter btnName: It is a String type value.
     - Parameter btnTextFont: It is a UIFont type value.
     - Parameter btnBackGroundColor: It is a UIColor type value.
     - Parameter btnTintColor: It is a UIColor type value.
     - Parameter btnTextColor: It is a UIColor type value.
     - Parameter btnBorderColor: It is a UIColor type value.
     - Parameter btnBorderWidth: It is a CGFloat type value.
     - Parameter btnAlpha: It is a CGFloat type value.
     - Parameter btnImage: It is a String type value.
     - Parameter isBtnImage: It is a Bool type value.
     */
    func setCustomButton(btnFrame : CGRect,btnName : String ,btnTextFont : UIFont, btnBackGroundColor : UIColor, btnTintColor : UIColor,btnTextColor : UIColor, btnBorderColor : UIColor, btnBorderWidth: CGFloat,btnAlpha : CGFloat,btnImage : String,isBtnImage : Bool,btnEdgeInset : UIEdgeInsets){
        if isBtnImage
        {
            self.setImage((UIImage(named: btnImage)?.withRenderingMode(.alwaysTemplate))!, for: .normal)
        }
        self.frame = CGRect(x: btnFrame.origin.x, y:  btnFrame.origin.y, width: btnFrame.size.width, height:btnFrame.size.height)
        self.setTitle(btnName, for:.normal)
        self.setTitleColor(btnTextColor, for: UIControl.State.normal)
        self.titleLabel?.font = btnTextFont
        self.backgroundColor = btnBackGroundColor
        self.tintColor = btnTintColor
        self.layer.borderWidth = btnBorderWidth
        self.layer.borderColor = btnBorderColor.cgColor
        self.alpha = btnAlpha
    }
    
    //MARK: Set Text and Image in different line (Image in first line and text in second line)
    /**
    Set Text and Image in different line (Image in first line and text in second line)
     - Parameter btnFrame: It is a CGRect type value.
     - Parameter btnName: It is a String type value.
     - Parameter btnImage: It is a String type value.
     - Parameter btnTintColor: It is a UIColor type value.
     - Parameter btnTextColor: It is a UIColor type value.
     - Parameter btnTextFont: It is a UIFont type value.
     - Parameter btnAlpha: It is a CGFloat type value.
     - Parameter btnSpace: It is a CGFloat type value.
     */
    
    func customButtonTextWithImageDoubleLine(btnFrame : CGRect,btnName : String,btnImage : String,btnTintColor : UIColor, btnTextColor : UIColor,btnTextFont : UIFont,btnAlpha : CGFloat,btnSpace : CGFloat){
        self.frame = CGRect(x: btnFrame.origin.x, y:  btnFrame.origin.y, width: btnFrame.size.width, height:btnFrame.size.height)
        self.setImage((UIImage(named: btnImage)?.withRenderingMode(.alwaysTemplate))!, for: .normal)
        self.setTitle(btnName, for:.normal)
        self.setTitleColor(btnTextColor, for: UIControl.State.normal)
        self.titleLabel?.font = btnTextFont
        self.tintColor = btnTintColor
        self.alpha = btnAlpha
        
        let sign : CGFloat = 1
        let gap : CGFloat = btnSpace //5
        
        self.titleEdgeInsets = UIEdgeInsets(top: ((imageView?.frame.size.height)! + gap) * sign, left: -(imageView?.frame.size.width)!, bottom: 0, right: 0)
        if kIS_IPAD {
            self.imageEdgeInsets = UIEdgeInsets(top: -((titleLabel?.bounds.size.height)! + gap) * sign, left: 0, bottom: 0, right: -(titleLabel?.bounds.size.width)!-8)
        }else {
            self.imageEdgeInsets = UIEdgeInsets(top: -((titleLabel?.bounds.size.height)! + gap) * sign, left: 0, bottom: 0, right: -(titleLabel?.bounds.size.width)!)
        }
    }
    
    //MARK: Set Text and Image in same line
    /**
    Set Text and Image in same line
     - Parameter btnFrame: It is a CGRect type value.
     - Parameter btnName: It is a String type value.
     - Parameter btnImage: It is a String type value.
     - Parameter btnTintColor: It is a UIColor type value.
     - Parameter btnTextColor: It is a UIColor type value.
     - Parameter btnTextFont: It is a UIFont type value.
     - Parameter btnSpace: It is a CGFloat type value.
     - Parameter btnAlpha: It is a CGFloat type value.
     */
    
    func customButtonTextWithImageSameline(btnFrame : CGRect,btnName : String,btnImage : String,btnTintColor : UIColor, btnTextColor : UIColor, btnTextFont : UIFont,btnSpace : CGFloat,btnAlpha : CGFloat){
        
        self.frame = CGRect(x: btnFrame.origin.x, y:  btnFrame.origin.y, width: btnFrame.size.width, height:btnFrame.size.height)
        
        self.imageView?.isHidden = true
        
        if btnImage != ""{
            self.imageView?.isHidden = false
            self.setImage((UIImage(named: btnImage)?.withRenderingMode(.alwaysTemplate))!, for: .normal)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageView?.frame.size.width)! + btnSpace, bottom: 0, right: 0)
        }else{
            self.setImage(nil, for: .normal)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        self.setTitle(btnName, for:.normal)
        self.setTitleColor(btnTextColor, for: UIControl.State.normal)
        self.titleLabel?.font = btnTextFont
        
        self.tintColor = tintColor
        self.alpha = btnAlpha
    }
    
    //MARK: Set Circle button
    /**
     Set Circle button
     - Parameter btnFrame: It is a CGRect type value.
     - Parameter btnName: It is a String type value.
     - Parameter btnBackgroundColor: It is a UIColor type value.
     - Parameter btnTextColor: It is a UIColor type value.
     - Parameter btnTextFont: It is a UIFont type value.
     - Parameter btnBorderColor: It is a UIColor type value.
     - Parameter btnBorderWidth: It is a CGFloat type value.
     - Parameter btnAlpha: It is a CGFloat type value.
     */
    
    func customCircleButton(btnFrame : CGRect,btnName : String,btnBackgroundColor : UIColor, btnTextColor : UIColor, btnTextFont : UIFont,btnBorderColor : UIColor,btnBorderWidth : CGFloat,btnAlpha : CGFloat){
        self.frame = CGRect(x: btnFrame.origin.x, y:  btnFrame.origin.y, width: btnFrame.size.width, height:btnFrame.size.height)
        self.setTitle(btnName, for:.normal)
        self.setTitleColor(btnTextColor, for: UIControl.State.normal)
        self.titleLabel?.font = btnTextFont
        self.backgroundColor = btnBackgroundColor
        self.alpha = btnAlpha
        self.layer.cornerRadius = btnFrame.size.height / 2
        self.layer.borderWidth = btnBorderWidth
        self.layer.borderColor = btnBorderColor.cgColor
    }
}
