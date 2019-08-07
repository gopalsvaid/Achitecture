//
//  ObserverNotifiationMessage.swift
//  Bidmo
//
//  Created by Gopal Vaid on 12/26/17.
//  Copyright © 2017 YourPractice. All rights reserved.
//

import Foundation

/**
 Create Protocol of Notification Message
 */
protocol NotificationMessage {
    
    //MARK: Variable
    /**
     getter and setter message object of Any Type
     */
    var message: Any {get set}
}

/**
 Create Sub Class of Notification Message
 */
class NotificationMessageWrapper:NotificationMessage{
   
    //MARK: Variable
    /**
     get message object of Any Type
     */
    var message: Any
    
    /**
     set message Value via init method
     */
    init(message: Any){
        self.message = message
    }
}
