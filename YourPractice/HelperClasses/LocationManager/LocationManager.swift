//
//  LocationManager.swift
//  Bidmo
//
//  Created by Gopal Vaid on 12/26/17.
//  Copyright © 2017 YourPractice. All rights reserved.
//

import UIKit
import CoreLocation

/**
 The purpose of the `Location Manager` class where we can get current location from singleton object.
 */


class LocationManager: NSObject, CLLocationManagerDelegate  {
    
    //MARK: Variable
    
    /**
     create fileprivate type object of CLLocationManager
     */
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    
    /**
     set Location Authorization station object of CLAuthorizationStatus
     */
    var locationAuthorizationStatus:CLAuthorizationStatus = .denied
    /**
     create static object of LocationManager Class
     */
    static let sharedInstance = LocationManager()
    /**
     create file private type object of location Status in String
     */
    fileprivate var locationStatus: String = ""
    /**
     create file private type object of Timer
     */
    fileprivate var timer:Timer?
    
    /**
     Call Init Method
     */
    fileprivate override init(){
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
   /**
    Returns a Boolean value indicating whether location services are enabled on the device.
    */
    class func isLocationServicesEnable() -> Bool {
        return LocationManager.sharedInstance.locationAutorizationStatus() == CLAuthorizationStatus.authorizedAlways
    }
    /**
    Returns the app’s authorization status for using location services.
     */
    func locationAutorizationStatus() -> CLAuthorizationStatus {
        return self.locationAuthorizationStatus
    }
    
    /**
     Starts the generation of updates that report the user’s current location.
    */
    @objc func startLocationServices(){
        self.timer?.invalidate()
        self.locationManager.startUpdatingLocation()
    }
    
    /**
     Stops the generation of location updates.
     */
    func stopLocationUpdating(){
        self.locationManager.stopUpdatingLocation()
    }
    
    /**
     Tells the delegate that new location data is available.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if manager.location?.coordinate.latitude != nil && manager.location?.coordinate.longitude != nil{
            Singleton.sharedInstance.setCurrentLocation(manager.location!.coordinate.latitude, long: manager.location!.coordinate.longitude)
        }
        manager.stopUpdatingLocation()
        if let location = manager.location {
            NotificationHandler.postNotification(AppNotificationsCase.didUpdateLocation, message: NotificationMessageWrapper(message: location))
        }
        
        self.timer?.invalidate()
        self.timer =  Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(LocationManager.startLocationServices), userInfo: nil, repeats: false)
    }
    
    /**
    Tells the delegate that the authorization status for the application changed.
     */
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        locationAuthorizationStatus = status
        
        switch locationAuthorizationStatus {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationHasbeenUpdated"), object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }

}
