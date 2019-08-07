//
//  Enum.swift
//  Bidmo
//
//  Created by Gopal Vaid on 12/20/17.
//  Copyright © 2017 YourPractice. All rights reserved.
//

import Foundation

//https://appventure.me/2015/10/17/advanced-practical-enum-examples/
//https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html#//apple_ref/doc/uid/TP40014097-CH12-ID145

/**
 create custom enum for App Notification case
 */
enum AppNotificationsCase {
    
    /**
     create case for did update location
     */
    case didUpdateLocation
    
    /**
     create case for date Time Filter
     */
    case dateTimeFilter
}

/**
 create custom extension of App Notification case
 */
extension AppNotificationsCase: ObserverType{
    
    /**
     varible for natification name
     */
    var notificationName:String{
        switch self {
        /**
        create case for date Time Filter
        */
        case .dateTimeFilter:
            return "user_date_time_filter"
        /**
        create case for did update location
        */
        case .didUpdateLocation:
            return "did_update_location"
        }
    }
}


