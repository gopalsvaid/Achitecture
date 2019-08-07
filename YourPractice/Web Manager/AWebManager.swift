//
//  AWebManager.swift
//  YourPractice
//
//  Created by Jaimin Galiya on 11/07/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import Alamofire
import SwiftyJSON
import Crashlytics

/**
 AWebManager uses Alamofire for interacting with server.
 */
class AWebManager: NSObject {

    ///Singleton object of AWebManager class.
    static let shared = AWebManager()
    
    //MARK:- Method to create api request
    /**
     This function create request for api.
     - Parameter strPath: It is a String type value.
     - Parameter apiMethod: It is a String type value.
     - Returns: It returns URLRequest value.
     */
    func createURLRequest(strPath : String, apiMethod : String) -> URLRequest{
        var urlRequest = URLRequest(url: URL(string: strPath)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: kTIMEINTERVAL_60)
        urlRequest.httpMethod = apiMethod
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.setValue("\(kWSDEVICETYPEVALUE)", forHTTPHeaderField: kWSDEVICETYPEPARAM)
        urlRequest.setValue(UIDevice.current.identifierForVendor!.uuidString, forHTTPHeaderField: kWSUDIDPARAMS)
        urlRequest.setValue(kWSDEVICETOKENPARAM, forHTTPHeaderField: kWSDEVICETOKENPARAM)
        return urlRequest
    }
    
    //MARK:- Method to create api request of multipart
    /**
     This function create request for api.
     - Parameter strPath: It is a String type value.
     - Parameter apiMethod: It is a String type value.
     - Returns: It returns URLRequest value.
     */
    func createURLRequestMutliPart(strPath : String, apiMethod : String) -> URLRequest{
        var urlRequest = URLRequest(url: URL(string: strPath)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: kTIMEINTERVAL_60)
        
        urlRequest.setValue("multipart/form-data; boundary=\(kBOUNDRY)", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = apiMethod
        
        urlRequest.setValue("\(kWSDEVICETYPEVALUE)", forHTTPHeaderField: kWSDEVICETYPEPARAM)
        urlRequest.setValue(UIDevice.current.identifierForVendor!.uuidString, forHTTPHeaderField: kWSUDIDPARAMS)
        urlRequest.setValue(kWSDEVICETOKENPARAM, forHTTPHeaderField: kWSDEVICETOKENPARAM)
        return urlRequest
    }
    
    //MARK:- Handle Almofire Methods
    /**
     This function handle the response of api
     - Parameter response: It is a DataResponse<Data> type value.
     - Returns: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func handleAPIResponse(response: DataResponse<Data>, handler: (_ response: JSON, _ error: String?) -> ()) {
        print(response.response?.statusCode ?? 0)
        if response.response?.statusCode == 417 {
            let statusCode = "\(response.response?.statusCode ?? 0)"
            handler(JSON.null, statusCode)
            
        } else if let error = response.error {
            Crashlytics.sharedInstance().recordError(error)
            handler(JSON.null, error.localizedDescription)
            
        } else if let result = response.value {
            handler(JSON(result), nil)
            
        } else {
            handler(JSON.null, kNO_DATA_FOUND)
        }
    }

    
    /**
     call GET API with ALAMOFIRE REQUEST
     - Parameter path: It is a String type value.
     - Parameter webServiceCallsCount: It is an Int type value.
     - Parameter completionHandler: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func callGETAPIAlamofire(path: String,webServiceCallsCount: Int, completionHandler:  @escaping (_ response: JSON, _ error: String?) -> ()){
        let apiRequest = createURLRequest(strPath: path,apiMethod: kGET_HTTPMETHOD)
        Alamofire.request(apiRequest).responseData { (apiResponse) in
            switch webServiceCallsCount{
            case kMaximumWebAPICount :
                self.handleAPIResponse(response: apiResponse, handler: completionHandler)
            default:
                if apiResponse.response?.statusCode == STATUSCODE_200 {
                    self.handleAPIResponse(response: apiResponse, handler: completionHandler)
                }
                else
                {
                    self.callGETAPIAlamofire(path: path,webServiceCallsCount: webServiceCallsCount + 1, completionHandler: { (response, strError) in
                    })
                }
            }
        }
    }
    
    /**
     call POST API with ALAMOFIRE REQUEST
     - Parameter path: It is a String type value.
     - Parameter webServiceCallsCount: It is an Int type value.
     - Parameter apiParameter: It is a [String : AnyObject] value.
     - Parameter completionHandler: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func callPOSTAPIAlamofire(path: String,webServiceCallsCount : Int,apiParameter : [String : AnyObject], completionHandler:  @escaping (_ response: JSON, _ error: String?) -> ()){
        var apiRequest = createURLRequest(strPath: path,apiMethod: kPOST_HTTPMETHOD)
        apiRequest.httpBody = try! JSONSerialization.data(withJSONObject: apiParameter, options: .prettyPrinted)
        
        Alamofire.request(apiRequest).responseData { (apiResponse) in
            switch webServiceCallsCount{
            case kMaximumWebAPICount :
                self.handleAPIResponse(response: apiResponse, handler: completionHandler)
            default:
                if apiResponse.response?.statusCode == STATUSCODE_200 {
                    self.handleAPIResponse(response: apiResponse, handler: completionHandler)
                }
                else
                {
                    self.callPOSTAPIAlamofire(path: path,webServiceCallsCount:  webServiceCallsCount + 1, apiParameter: apiParameter, completionHandler: { (response, strError) in
                    })
                }
            }
        }
    }
    
    /**
     call PUT API with ALAMOFIRE REQUEST
     - Parameter path: It is a String type value.
     - Parameter webServiceCallsCount: It is an Int type value.
     - Parameter apiParameter: It is a [String : AnyObject] value.
     - Parameter completionHandler: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func callPUTAPIAlamofire(path: String,webServiceCallsCount : Int,apiParameter : [String : AnyObject], completionHandler:  @escaping (_ response: JSON, _ error: String?) -> ()){
        var apiRequest = createURLRequest(strPath: path,apiMethod: kPUT_HTTPMETHOD)
        apiRequest.httpBody = try! JSONSerialization.data(withJSONObject: apiParameter, options: .prettyPrinted)
        
        Alamofire.request(apiRequest).responseData { (apiResponse) in
            switch webServiceCallsCount{
            case kMaximumWebAPICount :
                self.handleAPIResponse(response: apiResponse, handler: completionHandler)
            default:
                if apiResponse.response?.statusCode == STATUSCODE_200 {
                    self.handleAPIResponse(response: apiResponse, handler: completionHandler)
                }
                else
                {
                    self.callPUTAPIAlamofire(path: path,webServiceCallsCount: webServiceCallsCount + 1, apiParameter: apiParameter, completionHandler: { (response, strError) in
                    })
                }
            }
        }
    }
    
    /**
     call PATCH API with ALAMOFIRE REQUEST
     - Parameter path: It is a String type value.
     - Parameter webServiceCallsCount: It is an Int type value.
     - Parameter apiParameter: It is a [String : AnyObject] value.
     - Parameter completionHandler: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func callPATCHAPIAlamofire(path: String,webServiceCallsCount : Int,apiParameter : [String : AnyObject], completionHandler:  @escaping (_ response: JSON, _ error: String?) -> ()){
        var apiRequest = createURLRequest(strPath: path,apiMethod: kPATCh_HTTPMETHOD)
        apiRequest.httpBody = try! JSONSerialization.data(withJSONObject: apiParameter, options: .prettyPrinted)
        
        Alamofire.request(apiRequest).responseData { (apiResponse) in
            switch webServiceCallsCount{
            case kMaximumWebAPICount :
                self.handleAPIResponse(response: apiResponse, handler: completionHandler)
            default:
                if apiResponse.response?.statusCode == STATUSCODE_200 {
                    self.handleAPIResponse(response: apiResponse, handler: completionHandler)
                }
                else
                {
                    self.callPATCHAPIAlamofire(path: path,webServiceCallsCount: webServiceCallsCount + 1 , apiParameter: apiParameter, completionHandler: { (response, strError) in
                    })
                }
            }
        }
    }
    
    /**
     call Multi part API with ALAMOFIRE REQUEST
     - Parameter path: It is a String type value.
     - Parameter webServiceCallsCount: It is an Int type value.
     - Parameter apiParameter: It is a [String : AnyObject] value.
     - Parameter imgKeyName: It is a String value.
     - Parameter imgFolder: It is a String value.
     - Parameter imgPath: It is a String value.
     - Parameter completionHandler: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func callMutipartPostAPIAlamofire(path: String,webServiceCallsCount : Int,apiParameter : [String: AnyObject],imgKeyName : String,imgFolder : String,imgName : String, completionHandler:  @escaping (_ response: JSON, _ error: String?) -> ()){
        
        var apiRequest = createURLRequestMutliPart(strPath: path,apiMethod: kGET_HTTPMETHOD)
        
        var imageData = Data()
        
        if imgName.count > 0 && Utility.imageExistInCacheDirectory(strImgName: imgName, strFolderName: imgFolder){
            imageData = Utility.compressImage(image: Utility.getImgDocumentDirectory(strImgName: imgName, strFolderName: imgFolder))!
        }
        apiRequest.httpBody = createBodyWithParameters(parameters: apiParameter, imgKeyName: imgKeyName, imgName: imgName, imageDataKey: imageData as NSData) as Data
        
        Alamofire.request(apiRequest).responseData { (apiResponse) in
            switch webServiceCallsCount{
            case kMaximumWebAPICount :
                self.handleAPIResponse(response: apiResponse, handler: completionHandler)
            default:
                if apiResponse.response?.statusCode == STATUSCODE_200 {
                    self.handleAPIResponse(response: apiResponse, handler: completionHandler)
                }
                else
                {
                    self.callMutipartPostAPIAlamofire(path: path,webServiceCallsCount:  webServiceCallsCount + 1, apiParameter: apiParameter, imgKeyName: imgKeyName, imgFolder: imgFolder, imgName: imgName, completionHandler: { (response, strError) in
                    })
                }
            }
        }
    }
    
    /**
     create multipart data
     - Parameter parameters: It is a [String : AnyObject] value.
     - Parameter imgKeyName: It is a String value.
     - Parameter imgName: It is a String value.
     - Parameter imageDataKey: It is a NSData value.
     - Parameter completionHandler: It is a NSData type value.
     */
    func createBodyWithParameters(parameters: [String: AnyObject],imgKeyName : String,imgName : String,  imageDataKey: NSData) -> NSData
    {
        let body = NSMutableData();
        for (key, value) in parameters {
            body.appendString(string: "--\(kBOUNDRY)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string:  "\(value)\r\n")
        }
        
        if imgName.count > 0 && FileManager.default.fileExists(atPath: imgName){
            let mimetype = "image/png"
            
            body.appendString(string: "--\(kBOUNDRY)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(imgKeyName)\"; filename=\"\(String(describing: imgName))\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey as Data)
        }
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(kBOUNDRY)--\r\n")
        return body
    }
    
}
