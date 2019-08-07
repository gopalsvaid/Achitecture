//
//  CustomView.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

/**
 The purpose of the `CustomView` class where we can add our button related code over here which will be reflected everywhere where we can use this class.
 
 The `CustomView` class is a subclass of the `UIResponder`.
 */
class CustomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    //MARK: set background color and Border in UIView
    /**
     - Parameter vwBackGroundColor: It is a UIColor type value.
     - Parameter viewBorderColor: It is a UIColor type value.
     - Parameter viewBorderWidth: It is a CGFloat type value.
     */
    func setCustomView(vwBackGroundColor : UIColor,viewBorderColor : UIColor,viewBorderWidth: CGFloat){
        self.backgroundColor = vwBackGroundColor
        self.layer.borderColor = viewBorderColor.cgColor
        self.layer.borderWidth = viewBorderWidth
    }
}
