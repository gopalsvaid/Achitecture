//
//  CustomTableView.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

/**
 The purpose of the `CustomTableView` class where we can add our button related code over here which will be reflected everywhere where we can use this class.
 
 The `CustomTableView` class is a subclass of the `UIResponder`.
 */

class CustomTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    //MARK: set background color and cell seperator in UitableView
    /**
     set background color and cell seperator in UitableView
     - Parameter tblBackGroundColor: It is a UIColor type value.
     - Parameter tblMultipleSelection: It is a Bool type value.
     - Parameter tblSeperatorStyle: It is a UITableViewCellSeparatorStyle type value.
     */
    func setCustomTableView(tblBackGroundColor  : UIColor,tblMultipleSelection : Bool,tblSeperatorStyle : UITableViewCell.SeparatorStyle,tblCellUIEdgeInset : UIEdgeInsets){
        self.backgroundColor = tblBackGroundColor
        self.allowsMultipleSelection = tblMultipleSelection
        self.separatorStyle = tblSeperatorStyle
        self.separatorInset = tblCellUIEdgeInset
    }
}
