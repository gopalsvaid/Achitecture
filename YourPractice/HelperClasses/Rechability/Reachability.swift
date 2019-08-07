//
//  Reachability.swift
//  Bidmo
//
//  Created by Gopal Vaid on 12/20/17.
//  Copyright © 2017 YourPractice. All rights reserved.
//

import Foundation
import SystemConfiguration

/**
This class is created for provide the status whether the device currently conneted to internet or not.
 */
public class Reachability{
    /**
     It shows the the network status.
     
     The method indentify the network connection status. And provide the status whether the device currently conneted to internet or not .
     
     To use it, simply call:
     
     ```
     Reachability.isConnectedToNetwork()
     ```
     
     
     - returns:  It returns bool value (true or false).
     
     */
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

