//
//  NSMutableDataExtension.swift
//  YourPractice
//
//  Created by Devangi Shah on 14/03/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import Foundation

//MARK:- NSMutableData

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
