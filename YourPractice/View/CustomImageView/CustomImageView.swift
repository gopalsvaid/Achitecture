//
//  CustomImageView.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

/**
 The purpose of the `CustomImageView` class where we can add our button related code over here which will be reflected everywhere where we can use this class.
 
 The `CustomImageView` class is a subclass of the `UIResponder`.
 */
class CustomImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK : Set image ,content mode , shadow effect and border color in UIImageview
    /**
     Set image ,content mode , shadow effect and border color in UIImageview
     - Parameter imgName: It is a String type value.
     - Parameter imageViewContentMode: It is a UIViewContentMode type value.
     - Parameter isImgViewCircle: It is a Bool type value.
     - Parameter isImgViewShadowEffect: It is a Bool type value.
     - Parameter imgViewShadowOffset: It is a CGSize type value.
     - Parameter imgViewShadowColor: It is a UIColor type value.
     - Parameter isImgViewBorder: It is a Bool type value.
     - Parameter imgViewBorderColor: It is a UIColor type value.
     */
    func setCustomImageAndShadow(imgName : String,imageViewContentMode : UIView.ContentMode,isImgViewCircle : Bool,isImgViewShadowEffect : Bool,imgViewShadowOffset : CGSize,imgViewShadowColor : UIColor,isImgViewBorder : Bool,imgViewBorderColor : UIColor){
        self.image = UIImage.init(named: imgName)
        self.contentMode = imageViewContentMode
        if isImgViewCircle{
            self.clipsToBounds = true
            self.layer.masksToBounds = true
            self.layer.cornerRadius = self.frame.height / 2
        }
        if isImgViewShadowEffect{
            self.layer.shadowOffset = imgViewShadowOffset
            self.layer.shadowColor = imgViewShadowColor.cgColor
        }
        if isImgViewBorder{
            self.layer.borderColor = imgViewBorderColor.cgColor
        }
    }
}
