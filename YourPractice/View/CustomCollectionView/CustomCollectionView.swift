//
//  CustomCollectionView.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

/**
 The purpose of the `CustomCollectionView` class where we can add our button related code over here which will be reflected everywhere where we can use this class.
 
 The `CustomCollectionView` class is a subclass of the `UIResponder`.
 */

class CustomCollectionView: UICollectionView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: set background color and cell seperator in UICollectionView
    /**
     set background color and cell seperator in UICollectionView
     - Parameter clBackGroundColor: It is a UIColor type value.
     - Parameter tblMultipleSelection: It is a Bool type value.
     */
    func setCustomTableView(clBackGroundColor  : UIColor, clMultipleSelection : Bool){
        self.backgroundColor = clBackGroundColor
        self.allowsMultipleSelection = clMultipleSelection
    }
}
