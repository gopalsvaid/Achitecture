//
//  ImageResizing.swift
//  YourPractice
//
//  Created by Devangi Shah on 04/03/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

class ImageResizing: NSObject {

    //MARK: Compress Image
    
    /*class func resizedImage(img : UIImage) -> UIImage? {
        
        guard let imageData = UIImagePNGRepresentation(img) else { return nil }
        
        var resizingImage = img
        var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage =  resizingImage.resized(withPercentage: 0.9),
                let imageData = UIImagePNGRepresentation(resizedImage)
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        return resizingImage
    }*/
}
