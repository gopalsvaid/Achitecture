//
//  NotificationHandler.swift
//  Bidmo
//
//  Created by Gopal Vaid on 12/26/17.
//  Copyright © 2017 YourPractice. All rights reserved.
//

import Foundation

/**
 Create Class of Notification Handler
 */
class NotificationHandler {
    
    /**
    Adds an entry to the notification center's dispatch table with an observer and a notification selector, and an optional notification name and sender.
     */
    
    class func registerNotification(_ broadcaster:ObserverType, selector: Selector, observer: AnyObject){
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: broadcaster.notificationName), object: nil)
        
    }
    /**
     Adds an entry to the notification center's dispatch table with an observer and a notification selector, and an optional notification name and sender.
     */
    class func registerNotification(_ broadcaster:ObserverType, closer: @escaping (Notification) -> Void) -> NSObjectProtocol{
        
        return NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: broadcaster.notificationName), object: nil, queue: OperationQueue.main, using: closer)
        
    }
    /**
     Creates a notification with a given name and sender and posts it to the notification center.
    */
    class func postNotification(_ broadcaster: ObserverType, message: Any?){
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: broadcaster.notificationName), object: message)
    }
    /**
     Removes all entries specifying a given observer from the notification center's dispatch table.
     */
    class func removeAllObserver(_ observer: AnyObject){
        NotificationCenter.default.removeObserver(observer)
    }
    /**
     Removes matching entries from the notification center's dispatch table.
     */
    class func removeObserver(_ observer: ObserverType, observable: NSObject){
        NotificationCenter.default.removeObserver(observable, forKeyPath: observer.notificationName)
    }
    
    /**
     Removes all entries specifying a given observer from the notification center's dispatch table.
     */
    class func removeObserver(_ observable: NSObjectProtocol){
        NotificationCenter.default.removeObserver(observable)
    }
    
}
