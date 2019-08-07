//
//  Config.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2018 YourPractice. All rights reserved.
//

import Foundation
import UIKit
/**
 Create Static Variable of color,device Idom etc..
*/
struct Config {
    private init() {}
    
    // MARK: Color palette
    
    /**
     White color
     */
    static let whiteColor           = UIColor.white
    
    /**
     Red color
     */
    static let RedColor             = UIColor.red
    
    /**
     Dark Gray color
     */
    static let DarkGrayColor        = UIColor.darkGray
    
    /**
     Gray color
     */
    static let GrayColor            = UIColor.gray
    
    /**
     Light Gray color
     */
    static let LightGrayColor       = UIColor.lightGray
    
    /**
     Light Text color
     */
    static let LightTextColor       = UIColor.lightText
    
    /**
     Blue color
     */
    static let BlueColor            = UIColor.blue
    
    /**
     Green color
     */
    static let GreenColor           = UIColor.green
    
    /**
     Orange color
     */
    static let OrangeColor          = UIColor.orange
    
    /**
     Purple color
     */
    static let PurpleColor          = UIColor.purple
    
    /**
     Black color
     */
    static let BlackColor           = UIColor.black
    
    /**
     Clear color
     */
    static let ClearColor           = UIColor.clear
    
   
    //MARK: set constant for Arial fonts
    /**
     set constant for Arial fonts
     */
    static let arial_Regular               = "Arial"
    
}


// MARK: set constant for Font use in app
/**
 set constant for Font use in app
 */
let FONTARIAL12 = UIFont(name: Config.arial_Regular, size: CGFloat((kIS_IPAD ? 14 : 12)).adjustFont)

let FONTARIAL18 = UIFont(name: Config.arial_Regular, size: CGFloat((kIS_IPAD ? 20 : 18)).adjustFont)
