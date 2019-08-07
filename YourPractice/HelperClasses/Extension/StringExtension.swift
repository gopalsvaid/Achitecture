//
//  StringExtension.swift
//  YourPractice
//
//  Created by Devangi Shah on 14/03/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import Foundation
import UIKit

/**
 Add extension for String.
 */
extension String {
    
     // create variable for all character in string in upper case
    var strUpperCased:String {
        return self.uppercased()
    }
    
    // create variable for first character in upper case and other character in lower case
    var firstUpperCased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    // create variable for all character in string in lower case
    var strLowerCased:String {
        return self.lowercased()
    }
    
    // create variable for first character in lower case and other character in upper case
    var firstLowerCased: String {
        guard let first = first else { return "" }
        return String(first).lowercased() + dropFirst().uppercased()
    }
    
    // trailing trim whole string
    func trailingTrim(_ characterSet : CharacterSet) -> String {
        return self.trimmingCharacters(in: characterSet)
    }
    
     // set padding left side
    func padLeft (totalWidth: Int, with: String) -> String {
        let toPad = totalWidth - self.count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: with, startingAt: 0) + self
    }
    
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.
     
     - Returns: A `String` object.
     */
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
}

