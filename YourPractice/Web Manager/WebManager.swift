//
//  WebManager.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import Alamofire
import SwiftyJSON
import Crashlytics
/**
 Webmamager interact with server
 */

/**
 constant of status code
 */
let STATUSCODE_200 = 200
let STATUSCODE_417 = 417
/**
 constant of time interval of web service
 */
let kTIMEINTERVAL_60 = 60.0

//var kWebServiceCount = 0
var kMaximumWebAPICount = 2

//EXTRA
let kWSDEVICETYPEPARAM = "DeviceType"
let kWSDEVICETYPEVALUE = 1
let kWSDEVICETOKENPARAM = "DeviceToken"
let kWSUDIDPARAMS = "UDID"
let kBOUNDRY = "---011000010111000001101001"
let kBACKGROUND = "backGround"

class WebManager: NSObject,URLSessionDelegate,URLSessionDataDelegate,URLSessionDownloadDelegate {


    ///Singleton object of WebManager class.
    static let sharedInstance = WebManager()
    
    ///create object of defaultSession
    lazy var defaultSession : Foundation.URLSession! =  {
        let _session = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        return _session
    }()
    
    /// create object of URLSession
    var urlSessionDownload:URLSession!
    
    /// create object of URLSessionConfiguration
    var urlConfigurationDownload:URLSessionConfiguration!
    
    /// create object of URLSessionDownloadTask
    var urlDownloadTask:URLSessionDownloadTask!
    
    /// create object of URLSessionUploadTask
    var urlUploadTask:URLSessionUploadTask!
    
     var responseData = NSMutableData()
    
    ///create object of URLSessionDataTask
    @objc var taskForCallAPI: URLSessionDataTask!
    
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
    
    //MARK:- Handle Almofire Methods
    /**
     This function handle URL session response of api
     - Parameter response: It is a DataResponse<Data> type value.
     - Returns: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func handleAPISessionResponse(response: URLResponse?,responseData : Data?,error : Error?, handler: (_ response: JSON, _ error: String?) -> ()) {
        if error != nil{
            Crashlytics.sharedInstance().recordError(error!)
            handler(JSON.null, error!.localizedDescription)
        }
        else if (response as! HTTPURLResponse).statusCode == STATUSCODE_417{
            let statusCode = "\((response as! HTTPURLResponse).statusCode)"
            handler(JSON.null, statusCode)
        }
        else if (responseData?.count)! > 0  && JSON(responseData!) != JSON.null{
            handler(JSON(responseData!), nil)
        }
        else {
            handler(JSON.null, kNO_DATA_FOUND)
        }
    }
    
    /**
    call GET API with URLSESSION REQUEST
    - Parameter path: It is a String type value.
    - Parameter webServiceCallsCount: It is an Int type value.
    - Parameter completionHandler: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func callGETAPIURLSession(path: String,webServiceCallsCount : Int, completionHandler:  @escaping (_ response: JSON, _ error: String?) -> ()){
        let apiRequest = createURLRequest(strPath: path,apiMethod: kGET_HTTPMETHOD)
        
        taskForCallAPI = WebManager.sharedInstance.defaultSession.dataTask(with: apiRequest, completionHandler: { (data, response, error) in
            
            switch webServiceCallsCount{
                case kMaximumWebAPICount :
                    self.handleAPISessionResponse(response: response, responseData: data, error: error, handler: completionHandler)
                default :
                    if (response as! HTTPURLResponse).statusCode == STATUSCODE_200{
                        self.handleAPISessionResponse(response: response, responseData: data, error: error, handler: completionHandler)
                    }else{
                        self.callGETAPIURLSession(path: path,webServiceCallsCount: webServiceCallsCount + 1, completionHandler: completionHandler)
                    }
            }
        })
        taskForCallAPI.resume()
    }
    
    /**
     call POST API with URLSESSION REQUEST
     - Parameter path: It is a String type value.
     - Parameter webServiceCallsCount: It is an Int type value.
     - Parameter apiParameter: It is a [String : AnyObject] value.
     - Parameter completionHandler: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func callPOSTAPIURLSession(path: String,webServiceCallsCount : Int,apiParameter : [String : AnyObject], completionHandler:  @escaping (_ response: JSON, _ error: String?) -> ()){
        var apiRequest = createURLRequest(strPath: path,apiMethod: kPOST_HTTPMETHOD)
        apiRequest.httpBody = try! JSONSerialization.data(withJSONObject: apiParameter, options: .prettyPrinted)
       
        taskForCallAPI = WebManager.sharedInstance.defaultSession.dataTask(with: apiRequest, completionHandler: { (data, response, error) in
            
            switch webServiceCallsCount{
            case kMaximumWebAPICount :
                self.handleAPISessionResponse(response: response, responseData: data, error: error, handler: completionHandler)
            default :
                if (response as! HTTPURLResponse).statusCode == STATUSCODE_200{
                    self.handleAPISessionResponse(response: response, responseData: data, error: error, handler: completionHandler)
                }else{
            
                    self.callPOSTAPIURLSession(path: path,webServiceCallsCount: webServiceCallsCount + 1, apiParameter: apiParameter, completionHandler: {(response, strError) in
                    })
                }
            }
        })
        taskForCallAPI.resume()
    }
 
    /**
     call PUT API with URLSESSION REQUEST
     - Parameter path: It is a String type value.
     - Parameter webServiceCallsCount: It is an Int type value.
     - Parameter apiParameter: It is a [String : AnyObject] value.
     - Parameter completionHandler: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func callPUTAPIURLSession(path: String,webServiceCallsCount : Int,apiParameter : [String : AnyObject], completionHandler:  @escaping (_ response: JSON, _ error: String?) -> ()){
        var apiRequest = createURLRequest(strPath: path,apiMethod: kPUT_HTTPMETHOD)
        apiRequest.httpBody = try! JSONSerialization.data(withJSONObject: apiParameter, options: .prettyPrinted)
       
        
        taskForCallAPI = WebManager.sharedInstance.defaultSession.dataTask(with: apiRequest, completionHandler: { (data, response, error) in
            
            switch webServiceCallsCount{
            case kMaximumWebAPICount :
                self.handleAPISessionResponse(response: response, responseData: data, error: error, handler: completionHandler)
            default :
                if (response as! HTTPURLResponse).statusCode == STATUSCODE_200{
                    self.handleAPISessionResponse(response: response, responseData: data, error: error, handler: completionHandler)
                }else{
                    self.callPUTAPIURLSession(path: path,webServiceCallsCount: webServiceCallsCount + 1, apiParameter: apiParameter, completionHandler: {(response, strError) in
                    })
                }
            }
        })
        taskForCallAPI.resume()
    }
    
    /**
     call PATCH API with URLSESSION REQUEST
     - Parameter path: It is a String type value.
     - Parameter webServiceCallsCount: It is an Int type value.
     - Parameter apiParameter: It is a [String : AnyObject] value.
     - Parameter completionHandler: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func callPATCHAPIURLSession(path: String,webServiceCallsCount : Int,apiParameter : [String : AnyObject], completionHandler:  @escaping (_ response: JSON, _ error: String?) -> ()){
        var apiRequest = createURLRequest(strPath: path,apiMethod: kPATCh_HTTPMETHOD)
        apiRequest.httpBody = try! JSONSerialization.data(withJSONObject: apiParameter, options: .prettyPrinted)
        
        taskForCallAPI = WebManager.sharedInstance.defaultSession.dataTask(with: apiRequest, completionHandler: { (data, response, error) in
            
            switch webServiceCallsCount{
            case kMaximumWebAPICount :
                self.handleAPISessionResponse(response: response, responseData: data, error: error, handler: completionHandler)
            default :
                if (response as! HTTPURLResponse).statusCode == STATUSCODE_200{
                    self.handleAPISessionResponse(response: response, responseData: data, error: error, handler: completionHandler)
                }else{
                    self.callPATCHAPIURLSession(path: path,webServiceCallsCount: webServiceCallsCount + 1, apiParameter: apiParameter, completionHandler: {(response, strError) in
                    })
                }
            }
        })
        taskForCallAPI.resume()
    }
    
    /**
     call Multi part API with URLSESSION REQUEST
     - Parameter path: It is a String type value.
     - Parameter webServiceCallsCount: It is an Int type value.
     - Parameter apiParameter: It is a [String : AnyObject] value.
     - Parameter imgKeyName: It is a String value.
     - Parameter imgFolder: It is a String value.
     - Parameter imgName: It is a String value.
     - Parameter completionHandler: It is a (_ response: JSON, _ error: String?) -> () type value.
     */
    func callMutipartPostAPIURLSession(path: String,webServiceCallsCount : Int,apiParameter : [String: AnyObject],imgKeyName : String,imgFolder : String,imgName : String, completionHandler:  @escaping (_ response: JSON, _ error: String?) -> ()){
        
        var apiRequest = createURLRequestMutliPart(strPath: path,apiMethod: kGET_HTTPMETHOD)
       
        var imageData = Data()
        
        if imgName.count > 0 && Utility.imageExistInCacheDirectory(strImgName: imgName, strFolderName: imgFolder){
            imageData = Utility.compressImage(image: Utility.getImgDocumentDirectory(strImgName: imgName, strFolderName: imgFolder))!
        }
        apiRequest.httpBody = createBodyWithParameters(parameters: apiParameter, imgKeyName: imgKeyName, imgName: imgName, imageDataKey: imageData as NSData) as Data
        
      
        taskForCallAPI = WebManager.sharedInstance.defaultSession.dataTask(with: apiRequest, completionHandler: { (data, response, error) in
            
            switch webServiceCallsCount{
            case kMaximumWebAPICount :
                self.handleAPISessionResponse(response: response, responseData: data, error: error, handler: completionHandler)
            default :
                if (response as! HTTPURLResponse).statusCode == STATUSCODE_200{
                    self.handleAPISessionResponse(response: response, responseData: data, error: error, handler: completionHandler)
                }else{
                    self.callMutipartPostAPIURLSession(path: path,webServiceCallsCount: webServiceCallsCount + 1, apiParameter: apiParameter, imgKeyName: imgKeyName, imgFolder: imgFolder, imgName: imgName, completionHandler: {(response, strError) in
                    })
                }
            }
        })
        taskForCallAPI.resume()
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
    
    //MARK: download file using url session
    /**
     download file using urlsession
     - Parameter strUrl: It is a String value.
     - Parameter isBackground: It is a Bool value.
     */
    
    func downloadWithURLSession(strUrl : String,isBackground : Bool){
        
        if urlDownloadTask != nil && (urlDownloadTask.currentRequest!.url != nil)  &&  urlDownloadTask.currentRequest?.url == URL.init(string: strUrl)!{
            
        }else{
            let url : URL = URL.init(string: strUrl)!
            urlConfigurationDownload = isBackground == true ?  URLSessionConfiguration.background(withIdentifier: "kBACKGROUND") : URLSessionConfiguration.default
            let queue:OperationQueue = OperationQueue.main
            urlSessionDownload = URLSession(configuration: urlConfigurationDownload, delegate: self, delegateQueue: queue)
            urlDownloadTask = urlSessionDownload.downloadTask(with: url)
            urlDownloadTask.resume();
        }
    }
   
    //MARK: URLSessionDownloadDelegate Methods
    ///Tells the delegate that a download task has finished downloading.
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(downloadTask.currentRequest!.url!)
        session.finishTasksAndInvalidate()
        downloadTask.cancel()
    }
    
     ///Periodically informs the delegate about the download’s progress.
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let downloadProgress: Float = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print("session \(session) downloaded \(downloadProgress * 100)%.")
    }
    
    //MARK: upload file using url session
    
    func createURLRequestofUploadData(strFilePath : String,strURL  :String) -> URLRequest
    {
        var urlrequest = URLRequest.init(url: URL.init(string: strURL)!)
        
        if strFilePath.count > 0 && FileManager.default.fileExists(atPath: strFilePath){
            urlrequest.setValue(strFilePath.components(separatedBy: "/").last, forHTTPHeaderField: "filename")
        }
        urlrequest.httpMethod = kPOST_HTTPMETHOD
        urlrequest.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        return urlrequest
    }
    
    func uploadWithURLSession(strUrl : String,isBackground : Bool,strFilePath :String){
        
        let request = createURLRequestofUploadData(strFilePath: strFilePath, strURL: strUrl)
        
        urlConfigurationDownload = isBackground == true ?  URLSessionConfiguration.background(withIdentifier: "kBACKGROUND") : URLSessionConfiguration.default
        urlSessionDownload =  URLSession.init(configuration: urlConfigurationDownload)
        taskForCallAPI = urlSessionDownload.uploadTask(with: request, fromFile: URL.init(string: strFilePath)!)
        taskForCallAPI.resume()
    }
     //MARK: URLSession Upload Methods
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print("session \(session) uploaded \(uploadProgress * 100)%.")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("session \(session) occurred error \(error?.localizedDescription ?? "")")
        } else {
            print("session \(session) upload completed, response: \(NSString(data: responseData as Data, encoding: String.Encoding.utf8.rawValue) ?? "")")
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("session \(session), received response \(response)")
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        responseData.append(data)
    }
}
