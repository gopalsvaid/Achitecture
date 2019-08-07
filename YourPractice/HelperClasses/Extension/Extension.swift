//
//  Extension.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2018 YourPractice. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

// MARK: Extension

//MARK:- CGFloat extension
extension CGFloat {
    /**
     The relative dimension to the corresponding screen size.
     */
    var adjustFont: CGFloat {
        return (self / 375) * UIScreen.main.bounds.width
    }
}

/**
 Add extension for UIApplication.
 */
extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}

/**
 Add extension for setting color using hexa value.
 */
extension UIColor {
    
    /**
    convert hexa String to RGB Color
    */
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

/**
 Add extension for setting Dictionary.
 */

extension Dictionary where Key == String, Value == Any {
    
    func dictionaryByReplacingNullsWithStrings() -> [AnyHashable : Any]? {
        var replaced = self
        let nul = NSNull()
        
        let nul1 =  "(null)"
        let nul2 = "null"
        let nul3 = ""
        let blank = "NA"
        
        for key in self.keys {
            let object = self[key]
            if ((object as? NSNull) == nul) || ((object as? String) == nul1) || ((object as? String)  == nul2) || ((object as? String) == nul3) {
                replaced[key] = blank
            }
        }
        return replaced
    }

}


/**
 Add extension for customize date format and conversion.
 */
extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String, outputFormat:String) -> String? {
        let date = toDate(format: inputFormat)
        return DateFormatter(format: outputFormat).string(from: date!)
    }
}

extension Date {
    
    func toString (format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
}
