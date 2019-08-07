//
//  Singleton.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2018 YourPractice. All rights reserved.
//

import UIKit

/**
 - Used to ensure that there's only one instance of
 a class in an application
 - Every application has exactly one instance of
 UIApplication
 
 */

class Singleton: NSObject {

    /**
    create singleton instance
    */
    static let sharedInstance = Singleton()
    
    /**
    create object User Default object for Location
    */
    fileprivate let locationDefaults = UserDefaults.standard
    
    /**
    create Key Name for Current Latitude
    */
    fileprivate let kCurrentLocationLat = "__u_s_current_lat"
    
    /**
    create Key Name for Current Longitude
    */
    fileprivate let kCurrentLocationLong = "__u_s_current_long"
    
    /**
     - Set Current Location
     - Parameter lat: It is a double type value.
     - Parameter long: It is a double type value.
     */
    func setCurrentLocation(_ lat: Double, long: Double){
        locationDefaults.set(lat, forKey: kCurrentLocationLat)
        locationDefaults.set(long, forKey: kCurrentLocationLong)
        locationDefaults.synchronize()
    }
    
    /**
     - Get Current Location
     - Parameter lat: It is a double type value.
     - Parameter long: It is a double type value.
     */
    func currentLocation() -> (lat: Double, long: Double) {
        return  (locationDefaults.double(forKey: kCurrentLocationLat),  locationDefaults.double(forKey: kCurrentLocationLong))
    }
    
}
