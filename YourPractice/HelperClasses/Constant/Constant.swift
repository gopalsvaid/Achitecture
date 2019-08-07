//
//  Constant.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import Foundation
import UIKit


//MARK: Device Type
/**
 create variable for device is iPad or iPhone
 */
let kIS_IPAD                                    = (UIDevice.current.userInterfaceIdiom == .pad)

//MARK: Device Size Resolution
/**
 create variable for iPhone 5 resolution
 */
let kIS_IPHONE5                                 = (UIScreen.main.bounds.size.height == 568 && UIScreen.main.bounds.size.width == 320)
/**
 create variable for iPhone 6 Plus / 7 Plus / 8 Plus resolution
 */
let kIS_IPHONEPLUS                              = (UIScreen.main.bounds.size.height == 736 && UIScreen.main.bounds.size.width == 414)

/**
 create variable for iPhone X / iPhone XR / iPhone XS / iPhone XS MAX resolution
 */
let kIS_IPHONEX                                 = (UIScreen.main.bounds.size.height == 812 && UIScreen.main.bounds.size.width == 375)

//MARK: get Height of current device
/**
 create variable for get current device height
 */
let kDEVICE_HEIGHT = UIScreen.main.bounds.size.height

//MARK: get Width of current device
/**
 create variable for get current device width
 */
let kDEVICE_WIDTH = UIScreen.main.bounds.size.width

//MARK: Select storyboard.
/**
 create variable for get current story board
 */
let currentStoryboard = kIS_IPAD ? MainStoryBoard_iPad : MainStoryBoard

let kPICKER_HEIGHT : CGFloat =  200
let kPICKER_TOOLBAR_HEIGHT : CGFloat =  44
//MARK: Constant Text
/**
 Constant  Text
 */
let kAPPNAME = "App Name"
let kALERTTITLE = "Alert Title"

//MARK: Constant Alert Button Title
/**
Constant Alert Button Title
 */
let kALERTSETTING = "Settings"
let KALERTCANCEL = "Cancel"

//MARK: App Store URL
/**
 Appstore url
 Note: Change App id to your application id.
 */
let kAPPSTOREURL = "itms-apps://itunes.apple.com/app/<Your app id>"

//MARK: Constant Erorr Mesasges
/**
 Constant Erorr Mesasges
 */
let kNO_DATA_FOUND = "No Data Found"
let kALERENABLECAMERA = "This app is not authorized to use camera."
let kALERENABLECONTACTS = "This app is not authorized to use contacts."
let kALERENABLECALENDER = "This app is not authorized to use calendar."
let kALERENABLEPHOTOS = "This app is not authorized to use gallery."
let kTAKEPHOTO_CAPTUREIMAGE = "Take Photo or Capture Image"
//MARK: Constant Web Service Type
/**
 Constant  Web Service Type
 */
let kGET_HTTPMETHOD = "GET"
let kPOST_HTTPMETHOD = "POST"
let kPUT_HTTPMETHOD = "PUT"
let kPATCh_HTTPMETHOD = "PATCH"


//MARK: Constant Database File name
/**
 Constant Database File name
 */
let kDATABASENAME = "Database.sqlite"

//Database Table constants.
struct DBTable {
    static let kUSERSTABLE = "Users"
}
//Database columns constant.
struct DBColumn{
    static let kUPDATETIME = "UpdateTime"
    static let kVERSION = "version"
    static let kJSONRESPONSE = "jsonResponse"
    static let kAPINAME = "APIName"
    static let kWSEMAIL = "email"
    static let kWSUSERID = "userId"
    static let kWSCONFIRMCODE = "confirmCode"
    static let kWSFIRSTNAME = "firstName"
    static let kWSLASTNAME = "lastName"
}
