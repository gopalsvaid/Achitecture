//
//  AllowPrivacyAccess.swift
//  YourPractice
//
//  Created by Devangi Shah on 27/02/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit
import EventKit
import Contacts
import Photos

typealias successBlock =  ((_ isSuccess: Bool? ) ->  (Void))

// Allow App to access

class AllowPrivacyAccess: NSObject {
    
    //MARK: check Calendar Authorized
    
    class func checkCalendarAuthorized(success: @escaping successBlock){
        var isDisplayAlert : Bool = false
        
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event) {
            
        case .authorized:
            success(true)
        case .denied:
            isDisplayAlert = true
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                
                if granted {
                   success(true)
                } else {
                    isDisplayAlert = false
                }
                
            })
        default:
             isDisplayAlert = false
        }
        
        if isDisplayAlert{
            
            let vc = UIApplication.getTopMostViewController()
            AlertController.displayAlertWithTwoButton(kALERTTITLE, message: kALERENABLECALENDER, delegate: vc, okButtonText: kALERTSETTING, okButtonHandler: { (alertAction) in
                if let aString = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(aString, options: [:], completionHandler: { success in
                    })
                }
            }, cancelButtonText: KALERTCANCEL, cancelButtonHandler: nil)
            success(false)
        }
    }
    
    //MARK: check Contact Authorized
    
    class func checkContactAuthorized(success: @escaping successBlock){
        var isDisplayAlert : Bool = false
        let contactStore = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            success(true)
        case .denied:
           isDisplayAlert = true
        case .notDetermined:
            contactStore.requestAccess(for: .contacts, completionHandler: { (granted, error) in
                if granted {
                    success(true)
                } else {
                    isDisplayAlert = true
                }
                
            })
        default:
            isDisplayAlert = true
        }
        
        if isDisplayAlert{
            let vc = UIApplication.getTopMostViewController()
            AlertController.displayAlertWithTwoButton(kALERTTITLE, message: kALERENABLECONTACTS, delegate: vc, okButtonText: kALERTSETTING, okButtonHandler: { (alert) in
                if let aString = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(aString, options: [:], completionHandler: { success in
                    })
                }
            }, cancelButtonText: KALERTCANCEL, cancelButtonHandler: nil)
            success(false)
        }
    }
    
    //MARK: check Gallery Authorized
    
    class func checkGalleryAuthorized(success: @escaping successBlock){
       var isDisplayAlert : Bool = false
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            isDisplayAlert = false
            success(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    isDisplayAlert = false
                    success(true)
                }else {
                    isDisplayAlert = false
                }
            })
        case .denied:
            isDisplayAlert = true
        case .restricted:
            isDisplayAlert = true
        default:
            isDisplayAlert = true
        }
        if isDisplayAlert{
            let vc = UIApplication.getTopMostViewController()
            AlertController.displayAlertWithTwoButton(kALERTTITLE, message: kALERENABLECONTACTS, delegate: vc, okButtonText: kALERTSETTING, okButtonHandler: { (alert) in
                if let aString = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(aString, options: [:], completionHandler: { success in
                    })
                }
            }, cancelButtonText: KALERTCANCEL, cancelButtonHandler: nil)
            success(false)
        }
    }
    
    //MARK: check Camera Authorized
    
    class func checkCameraAuthorized(success: @escaping successBlock){
        
        var isDisplayAlert : Bool = false
        
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            isDisplayAlert = false
            success(true)
        case .denied:
            isDisplayAlert = true
           
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                if granted == true{
                    isDisplayAlert = false
                    success(true)
                }
                else{
                    isDisplayAlert = true

                }
            }
        case .restricted:
            isDisplayAlert = true
        default:
            isDisplayAlert = true
        }
        
        if isDisplayAlert{
            let vc = UIApplication.getTopMostViewController()
            AlertController.displayAlertWithTwoButton(kALERTTITLE, message: kALERENABLECAMERA, delegate: vc, okButtonText: kALERTSETTING, okButtonHandler: { (alert) in
                if let aString = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(aString, options: [:], completionHandler: { success in
                    })
                }
            }, cancelButtonText: KALERTCANCEL, cancelButtonHandler: nil)
            success(true)
        }
    }
}
