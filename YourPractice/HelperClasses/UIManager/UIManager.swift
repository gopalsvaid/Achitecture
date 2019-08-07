//
//  UIManager.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

/**
 Global object for managing the vipre shared UI activities
 */
class UIManager: NSObject {
}

// MARK: public variable

/**
 The Your Practice AppDelegate object. AppDelegate handles special UIApplication states and activities.
*/
var APPDelegate: AppDelegate {
    return  UIApplication.shared.delegate as! AppDelegate
}

/**
 Your Practicle get Top View Controller object just for get current view controller.
*/
var getTopViewController : UIViewController{
    let base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
    if let presented = base?.presentedViewController {
        return presented
    }
    if let nav = base as? UINavigationController {
        return nav.visibleViewController!
    }
    if let tab = base as? UITabBarController {
        if let selected = tab.selectedViewController {
            return selected
        }
    }
    return base!
}

/**
 Your Practice Root navigation Controller just over the Window. the MainNavigation controller manages a stack of view controllers to provide a drill-down interface for hierarchical content.
 */
var MainNavigation: UINavigationController? {
    guard let navController: UINavigationController =  APPDelegate.window?.rootViewController as? UINavigationController else {return nil}
    navController.view.backgroundColor = Config.whiteColor
    return navController
}

/**
 Your Practice main story board object for iPhone, which loaded from Interface Builder.
 */
var MainStoryBoard: UIStoryboard = {
    let  storyboard:  UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
    return storyboard
}()

/**
 Your Practice main story board object for iPad, which loaded from Interface Builder.
 */
var MainStoryBoard_iPad: UIStoryboard = {
    let  storyboard:  UIStoryboard = UIStoryboard(name: "Main_iPad", bundle: nil)
    return storyboard
}()

/// Your Practice main Window, The root UI object. It contains ROI visible content.
var MainWindow: UIWindow! {
    return APPDelegate.window
}
