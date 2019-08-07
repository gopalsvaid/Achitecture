//
//  AlertController.swift
//  YourPractice
//
//  Created by Jaimin Galiya on 12/07/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

/**
 AlertController - Alert Controller class to display different kinds of alert into the application.
 */
class AlertController: NSObject {

    //MARK: Display UIAlertController With View Controller delegate
    
    /**
     Display UIAlertController With View Controller delegate
     - Parameter title: The title parameter is an short alert title.
     - Parameter message: The message parameter is an detail alert message.
     - Parameter delegate: The delegate is an current pointer of an object.
     */
    
    class func alertShow(_ title : String , message :String, delegate: AnyObject?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Display UIAlertController on Main Window and With out View Controller delegate
    
    /**
     Display UIAlertController on Main Window and With out View Controller delegate
     - Parameter title: The title parameter is an short alert title.
     - Parameter message: The message parameter is an detail alert message.
     */
    
    class func alertNetworkError(_ title : String , message :String){
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        MainWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Display UIAlertController with handle Single Button Event
    
    /**
     Display UIAlertController with handle Single Button Event
     - Parameter title: The title parameter is an short alert title.
     - Parameter message: The message parameter is an detail alert message.
     - Parameter delegate: The delegate is an current pointer of an object.
     - Parameter okButtonText: The okButtonText parameter is an title for ok button.
     - Parameter okButtonHandler: The okButtonHandler parameter is an hanlder for ok button.
     */
    class func alertShowWithOkEvent(_ title : String , message :String, delegate: AnyObject?,okButtonHandler okHander: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: okHander))
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Display UIAlertController with handle Two Buttons Event
    /**
     Display UIAlertController with handle Two Buttons Event
     - Parameter title: The title parameter is an short alert title.
     - Parameter message: The message parameter is an detail alert message.
     - Parameter delegate: The delegate is an current pointer of an object.
     - Parameter okButtonText: The okButtonText parameter is an title for ok button.
     - Parameter cancelButtonText: The cancelButtonText parameter is an title for cancel button.
     - Parameter okButtonHandler: The okButtonHandler parameter is an hanlder for ok button.
     - Parameter cancelButtonHandler: The cancelButtonHandler parameter is an hanlder for cancel button.
     */
    class func displayAlertWithTwoButton(_ title : String , message :String, delegate: AnyObject?, okButtonText strOk: String, okButtonHandler okHander: ((UIAlertAction) -> Void)?, cancelButtonText strCancel: String?, cancelButtonHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        
        if strCancel != nil {
            alert.addAction(UIAlertAction(title: strCancel, style: .default, handler: cancelButtonHandler))
        }
        
        alert.addAction(UIAlertAction(title: strOk, style: .default, handler: okHander))
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Display UIAlertController for capture and select image option
    /**
     Display UIAlertController to show an alert for capture image.
     - Parameter title: The title parameter is an short alert title.
     - Parameter message: The message parameter is an detail alert message.
     - Parameter delegate: The delegate is an current pointer of an object.
     - Parameter imagePicker: The imagePicker parameter having an object of UIImagePickerController.
     - Parameter documentPicker: The documentPicker parameter having an object of UIDocumentPickerViewController.
     */
    class func alertShowForTakeCaptureImages(_ title : String,message : String,delegate : AnyObject?,imagePicker : UIImagePickerController,documentPicker : UIDocumentPickerViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Select Picture", style: UIAlertAction.Style.default, handler: { _ in
            alertShowForSelectPicture(kALERTTITLE, message: "Select Picture", delegate: delegate,imagePicker: imagePicker, documentPicker: documentPicker)
        }))
        alertController.addAction(UIAlertAction(title: "Capture Image", style: UIAlertAction.Style.default, handler: { _ in
            Utility.openCamera(delegate: delegate!, imagePicker: imagePicker)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        delegate?.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Display UIAlertController show alert to pick image from gallery or iCloud or file.
     - Parameter title: The title parameter is an short alert title.
     - Parameter message: The message parameter is an detail alert message.
     - Parameter delegate: The delegate is an current pointer of an object.
     - Parameter imagePicker: The imagePicker parameter having an object of UIImagePickerController.
     - Parameter documentPicker: The documentPicker parameter having an object of UIDocumentPickerViewController.
     */
    class func alertShowForSelectPicture(_ title : String,message : String,delegate : AnyObject?,imagePicker : UIImagePickerController,documentPicker : UIDocumentPickerViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { _ in
            Utility.openGallary(delegate: delegate!, imagePicker: imagePicker)
        }))
        alertController.addAction(UIAlertAction(title: "iCloud", style: UIAlertAction.Style.default, handler: { _ in
            Utility.getImagesFromiCloud(delegate: delegate,documentPicker: documentPicker)
        }))
        alertController.addAction(UIAlertAction(title: "File", style: UIAlertAction.Style.default, handler: { _ in
            Utility.getImagesFromFiles(delegate: delegate,documentPicker: documentPicker)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        delegate?.present(alertController, animated: true, completion: nil)
    }
    
}
