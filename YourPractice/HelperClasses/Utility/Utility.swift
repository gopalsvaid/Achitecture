//
//  Utility.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit
import StoreKit
import UserNotifications
import SKActivityIndicatorView
import WebKit
import SwiftyJSON

/**
 Utility - Add global methods only
 */
class Utility: NSObject {
    
    /**
     register the app for receiving remote notification.
     */
    class func registerForRemoteNotifications(){
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        application.registerForRemoteNotifications()
    }
    
    //MARK: Set Notification Badge count on App Icon
    /**
    Set Notification Badge count on App Icon
     Note: set badge number to 0 to reset the badge count.
    - Parameter badgeNumber: Int
     */
    class func setBadgeCountOnAppIcon(badgeNumber : Int){
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = badgeNumber
    }
    
    //MARK: when Click On Camera This Method Is Called
    /**
     when Click On Camera This Method Is Called
     - Parameter delegate: AnyObject
     - Parameter imagePicker: UIImagePickerController
     */
    class func openCamera(delegate: AnyObject, imagePicker: UIImagePickerController){
        AllowPrivacyAccess.checkCameraAuthorized { (isSuccess) -> (Void) in
            if isSuccess!{
                DispatchQueue.main.async {
                    if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                        imagePicker.sourceType = UIImagePickerController.SourceType.camera
                        imagePicker.allowsEditing = true
                        DispatchQueue.main.async{
                            (delegate as AnyObject).present(imagePicker, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: when Click On Gallery This Method Is Called
    /**
     when Click On Gallery This Method Is Called
     - Parameter delegate: AnyObject
     - Parameter imagePicker: UIImagePickerController
     */
    class func openGallary(delegate: AnyObject, imagePicker: UIImagePickerController){
        
         AllowPrivacyAccess.checkGalleryAuthorized(success: { (isSuccess) -> (Void) in
            if isSuccess!{
                DispatchQueue.main.async {
                    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                        imagePicker.allowsEditing = true
                        DispatchQueue.main.async{
                            (delegate as AnyObject).present(imagePicker, animated: true, completion: nil)
                        }
                    }
                }
            }
        })
    }
    
    // MARK: Email validation
    
    /**
     Method for email validation.
     
     - Parameter strEmail: The strEmail parameter is an email string.
     - Returns: Return the bool value.
     */
    class func isValidEmail(_ strEmail:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: strEmail)
    }
    
    class func getImagesFromFiles(delegate: AnyObject?,documentPicker : UIDocumentPickerViewController){
        
        let manager = FileManager.default
        let dir = manager.url(forUbiquityContainerIdentifier: "")
        let files = try? FileManager.default.contentsOfDirectory(at: dir!, includingPropertiesForKeys: nil, options: [])
        print(files!)
        if (files?.count)! > 0{
            documentPicker.modalPresentationStyle = .formSheet
            delegate?.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    class func getImagesFromiCloud(delegate: AnyObject?,documentPicker : UIDocumentPickerViewController){
        let manager = FileManager.default
        let dir = manager.url(forUbiquityContainerIdentifier: "")
        let files = try? FileManager.default.contentsOfDirectory(at: dir!, includingPropertiesForKeys: nil, options: [])
        if (files?.count)! > 0{
            documentPicker.modalPresentationStyle = .formSheet
            delegate?.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    //MARK: addobserver to hide and show keyboard
    
    /**
     addobserver to hide and show keyboard
      - Parameter view: UIScrollView
      - Parameter target: Any
     */
    class func addObserver(view: UIScrollView, target: Any){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: {
            notification in
            keyboardWillShow(notification: notification, delegate: target, view: view)
        })
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: {
            notification in
            keyboardWillHide(notification: notification, view: view)
        })
    }

    //MARK: keyboard show in calculating scrollview contentinset

    /**
     keyboard show in calculating scrollview contentinset
     - Parameter notification: Notification
     - Parameter delegate: Any
     - Parameter view: UIScrollView
     */
    class func keyboardWillShow(notification: Notification, delegate: Any, view: UIScrollView){
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
                return
        }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        view.contentInset = contentInsets
        view.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: keyboard hide
    
    /**
    keyboard hide
     - Parameter notification: Notification
     - Parameter view: UIScrollView
     */
    class func keyboardWillHide(notification: Notification, view: UIScrollView){
        let contentInsets = UIEdgeInsets.zero
        view.contentInset = contentInsets
        view.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: remove observer from view
    /**
     remove observer from view
     - Parameter target: Any
     */
    class func removeObservers(target: Any){
        NotificationCenter.default.removeObserver(target)
    }
    
    //MARK: set Display Bundle Version on Main Window
    /**
    set Display Bundle Version on Main Window
    */
    class func displayAppVersion(){
        let window = UIApplication.shared.keyWindow!
        let v2 = UILabel(frame: CGRect(x: 0, y: kDEVICE_HEIGHT - 15, width:  kIS_IPAD ? 50 : 30, height: 15))
        v2.backgroundColor = Config.RedColor
        v2.textColor = Config.whiteColor
        v2.textAlignment = .center
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            v2.text = "v \(version)"
        }
        window.addSubview(v2)
    }
    
    class func showIndicatior(strMesage : String){
        //https://github.com/SachK13/SKActivityIndicatorView
        
        SKActivityIndicator.dismiss()
       
        // default is darkGray
        SKActivityIndicator.spinnerColor(UIColor.gray)
        
        // default is black
        SKActivityIndicator.statusTextColor(UIColor.darkText)
        
        // default is System Font
        SKActivityIndicator.statusLabelFont(FONTARIAL18!)

        // ActivityIndicator Styles: choose and set one of four.
        SKActivityIndicator.spinnerStyle(.spinningFadeCircle)
        
        SKActivityIndicator.show(strMesage, userInteractionStatus: false)
    }
    
    class func hideIndicatior(){
        SKActivityIndicator.dismiss()
    }
    
    //MARK: Image Exist or not in Cache directory Cache Directory
    /**
     Image Exist or not in Cache directory Cache Directory
     - Parameter strImgName: String
     - Parameter strFolderName: String
     - Returns: Bool
     */
    class func imageExistInCacheDirectory(strImgName : String,strFolderName : String) -> Bool{
        var isSuccess : Bool = false
        
        let docPath = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        let folderPath = docPath.appendingPathComponent(strFolderName)
        
        let imagePath = folderPath.appendingPathComponent(strImgName)
        
        if FileManager.default.fileExists(atPath: imagePath.path){
            isSuccess = true
        }
        return isSuccess
    }
    
    //MARK: Get images from document directory
    /**
     - Parameter strImgName: Image name which one is used.
     - Parameter strFolderName: Folder name for get image.
     - Returns: UIImage.
     */
    class func getImgDocumentDirectory(strImgName : String,strFolderName : String) -> UIImage{
        var image = UIImage()
        
        let docPath = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        let folderPath = docPath.appendingPathComponent(strFolderName)
        
        let imagePath = folderPath.appendingPathComponent(strImgName)
        
        if FileManager.default.fileExists(atPath: imagePath.path){
            do {
                if let imageData: Data = try? Data(contentsOf: imagePath){
                    image = UIImage(data: imageData)!
                    
                }
            }
        }
        return image
    }
    
    //MARK: Remove Image from Cache Directory
    /**
     Remove Image from Cache Directory
     - Parameter pickedimage: UIImage
     - Parameter strImgName: String
     - Parameter strFolderName: String
     */
    class func removeImgCacheDirectory(strImgName : String,strFolderName : String){
        if strImgName.count > 0{
            let docPath = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
            let folderPath = docPath.appendingPathComponent(strFolderName)
            
            let imagePath = folderPath.appendingPathComponent(strImgName)
            
            if imageExistInCacheDirectory(strImgName: strImgName, strFolderName: strFolderName){
                do {
                    try FileManager.default.removeItem(at: imagePath)
                } catch let error as NSError {
                    print(error.debugDescription)
                }
            }
        }
    }
    
    //MARK: Save Capture Image in Cache Directory
    /**
     Save Capture Image in Cache Directory
     - Parameter pickedimage: UIImage
     - Parameter strImgName: String
     - Parameter strFolderName: String
     */
    class func saveImgCacheDirectory(pickedimage: UIImage, strImgName : String ,strFolderName : String){
        guard let image : Data = pickedimage.jpegData(compressionQuality: 1) else{
            return
        }
        
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        
        let folderPath = path.appendingPathComponent(strFolderName)
        
        do {
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let imagePath = folderPath.appendingPathComponent(strImgName)
        do {
            try image.write(to: imagePath, options: .atomic)
        } catch let error {
            print(error)
        }
    }
    
    // MARK: Compare Image
    class func compressImage(image:UIImage) -> Data? {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 1136.0
        let maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }else{
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let imageData = img.jpegData(compressionQuality: compressionQuality) else{
            return nil
        }
        return imageData
    }
    
    class func ratingScreen(isDefault : Bool,strURL : String){
    
        var isDispaly : Bool = false
        if isDefault{
            isDispaly = true
        }else{
            if #available(iOS 10.3,*){
                SKStoreReviewController.requestReview()
            }else{
                isDispaly = true
            }
        }
        
        if isDispaly{
            guard let url = URL(string : strURL) else{
                return
            }
            guard #available(iOS 10, *) else {
                return UIApplication.shared.open(url)
            }
            UIApplication.shared.open(url, options: [:]) { (isSuccess) in
                print("Success")
            }
        }
    }
    
    /**
     Method redirects to safaricontroller from link given in html string
     */
    class func navigateToHTMLLink(controller: UIViewController, navigationAction: WKNavigationAction, handler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url, let _ = url.host {
               
                handler(.cancel)
            } else {
                handler(.allow)
            }
        } else {
            handler(.allow)
        }
    }
    
    class func createCSV(strFileName : String,values : JSON){
        
        var strKeys = ""
        var strValues = ""
        
        if values != JSON.null{
            strKeys = (values[0].dictionaryObject?.keys.joined(separator: ","))!

            let arrKeys = strKeys.split(separator: ",")
            
            for dictData in values{

                for key in arrKeys{
                    let value = "\(dictData.1.dictionary![String(key)] ?? "")"
                    strValues = strValues.count > 0 ? (strValues.last == "\n" ? "\(strValues)\(value)" : "\(strValues),\(value)") : "\(value)"
                }
                strValues = "\(strValues)\n"
                
            }
            strKeys = "\(strKeys)\n"
        }
        
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        
        let filePath = path.appendingPathComponent(strFileName)

        do {
            try "\(strKeys)\(strValues)".write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
            print(filePath)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    class func createPDF(strFileName : String,htmlContent : String){
        
        let printPageRenderer = CustomPrintPageRenderer()
        let printFormatter = UIMarkupTextPrintFormatter(markupText: htmlContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        let pdfData = Utility.drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
       
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        
        let filePath = path.appendingPathComponent(strFileName)
        pdfData?.write(to: filePath, atomically: true)
        print(filePath)
    }
    
    class func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        return data
    }
    
    /**
     This function will help the user to navigate to app store for rating.
    */
    class func rateUsAction(){
        if let appStoreUrl = URL(string: kAPPSTOREURL){
            UIApplication.shared.open(appStoreUrl options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
