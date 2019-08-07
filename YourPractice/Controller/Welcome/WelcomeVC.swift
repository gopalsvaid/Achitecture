//
//  WelcomeVC.swift
//  YourPractice
//
//  Created by Devangi Shah on 8/29/18.
//  Copyright © 2019 YourPractice. All rights reserved..
//
let kBASEURL = "https://kyciz01orl.execute-api.us-east-1.amazonaws.com/Prod"
let kGETSENDRESETPASSWORDMAIL = "/api/user/SendResetPasswordMail?"
let kPOSTCONFIRMCODE = "/api/User/ConfirmCode"



import UIKit
import SwiftyJSON
import MobileCoreServices
import WebKit
import Alamofire
/**
The purpose of the `WelcomeVC` view controller is to provide a user interface where user can change his location.
 
There's a matching scene in the *Main.storyboard* and *Main_iPad.storyboard* files. Go to Interface Builder for details.
 
The `WelcomeVC` class is a subclass of the `UIViewController`.
 */

class WelcomeVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate,UIGestureRecognizerDelegate {
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
    }
    
    var audioPlayer : CustomAVAudioPlayer?

    @IBOutlet weak var textField: UITextField!
    var selectedPickerData = PickerData()
    var selectedJSONData = JSON()
    var strConfirmCode = String()
    var strUserId = String()
    var objImgPicker = UIImagePickerController()
    var documentPicker = UIDocumentPickerViewController(documentTypes:  [String(kUTTypePDF)], in: .import)
    
    var customView = UIView()
    //MARK:- Life cycle of ViewController
    /**
    Called after the controller's view is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        documentPicker.delegate = self
        // Do any additional setup after loading the view.
    }
    /**
     Sent to the view controller when the app receives a memory warning.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        if Reachability.isConnectedToNetwork(){
            AlertController.alertShow("Connected!", message: "Internet is connected", delegate: self)
        }else{
            AlertController.alertShow("Not Connected!", message: "Internet is not connected", delegate: self)
        }
        // Utility.showIndicatior(strMesage: "Here, Activity indicator is shown with message. \nMultiple line Messages is to set here.")
        // callGETAPI()
        // callPOSTAPI()
        // callDateFunction()
        // downloadFiles()
        // uploadFiles()
        // displayWebViewJS()
        // createCSVFile()
        // createPDFFile()
        // getGalleryData()
       
        // playCurrentAudio()
    }
    
    func getGalleryData(){
        AlertController.alertShowForTakeCaptureImages(kAPPNAME, message: kTAKEPHOTO_CAPTUREIMAGE, delegate: self, imagePicker: objImgPicker, documentPicker: documentPicker)
    }

    func callGETAPI(){
        
        let strURL = "\(kBASEURL+kGETSENDRESETPASSWORDMAIL)\(DBColumn.kWSEMAIL)=devangip06@gmail.com"
        
        WebManager.sharedInstance.callGETAPIURLSession(path: strURL,webServiceCallsCount: 0) { (responseJson, errorString) in
            if responseJson != JSON.null && (responseJson.dictionaryObject != nil) && (responseJson.dictionaryObject?.keys.contains(DBColumn.kWSUSERID))!
            {
                 print(responseJson)
                self.strUserId = responseJson.dictionaryObject![DBColumn.kWSUSERID] as! String
            }
            else
            {
                AlertController.alertNetworkError(kAPPNAME, message: errorString!)
            }
        }
    }
    
    func callPOSTAPI(){
        
        let strURL = "\(kBASEURL+kPOSTCONFIRMCODE)"
        
        var dictData = [String : AnyObject]()
        dictData[DBColumn.kWSEMAIL] = "devangip06@gmail.com" as AnyObject
        dictData[DBColumn.kWSUSERID] = strUserId as AnyObject
        dictData[DBColumn.kWSCONFIRMCODE] = strConfirmCode as AnyObject
        
        WebManager.sharedInstance.callPOSTAPIURLSession(path: strURL,webServiceCallsCount: 0, apiParameter: dictData) { (responseJson, errorString) in
            if responseJson != JSON.null && (responseJson.dictionaryObject != nil) && (responseJson.dictionaryObject?.keys.contains(DBColumn.kWSUSERID))!
            {
                print(responseJson)
            }
            else
            {
                AlertController.alertNetworkError(kAPPNAME, message: errorString!)
            }
        }
    }
    
    func downloadFiles(){
        let strUrl = "https://s3.us-east-2.amazonaws.com/work-mindful-audio/SampleAudioForTesting/01.mp3"
        WebManager.sharedInstance.downloadWithURLSession(strUrl: strUrl, isBackground: false)
    }
    
    func uploadFiles(){
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
         displayPickerView()
        // displayDatePickerView()
//        callViewAnimationActivity()
//        textField.resignFirstResponder()
    }
    
    func playCurrentAudio(){
        let strPath =  Bundle.main.path(forResource: "DD05188W_01", ofType:  "m4a")
        audioPlayer = CustomAVAudioPlayer.init(strFilePath: strPath ?? "")
        audioPlayer?.play()
    }
    
    func displayPickerView(){
        
        let changePicker = CustomPickerView()
        
        if let path = Bundle.main.path(forResource: "Employee", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(JSON(jsonResult))
                
              //  changePicker.arrJsonData = JSON(jsonResult)
                
            } catch {
                // handle error
            }
        }
        
        changePicker.arrStructureData = [PickerData(strTitle: "1", strSubTitle: "1",pickerId: 1),PickerData(strTitle: "2", strSubTitle: "2",pickerId: 2),PickerData(strTitle: "3", strSubTitle: "3",pickerId: 3),PickerData(strTitle: "4", strSubTitle: "4",pickerId: 4),PickerData(strTitle: "5", strSubTitle: "5",pickerId: 5)]
        changePicker.selectedStructureData = selectedPickerData
        changePicker.selectedJSONData = selectedJSONData
        
        changePicker.commonPickerSetup()
       
        changePicker.onSelectedStructureData = { (selectedStructureData : PickerData) in
            changePicker.selectedStructureData = selectedStructureData
        }
        
        changePicker.onSelectedJsonData = {(selectedJsonData : JSON) in
            changePicker.selectedJSONData = selectedJsonData
        }
        changePicker.toolbarAction = {
            (action: PickerToolBarAction) in
            if action == .done{
                print("Selected Data : \(changePicker.selectedStructureData)")
                print("Selected Data : \(changePicker.selectedJSONData)")
            }
            else{
                print("Cancel")
            }
        }
    }
    
    func displayDatePickerView(){
        
        
        let pastStrDate = CustomDateFormat.getPastDate(numberOfDays: 15,dateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false)
        let futureStrDate =  CustomDateFormat.getFutureDate(numberOfDays: 15,dateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false)
        
        // convert into string
        let pastDate = CustomDateFormat.convertStringToDate(pastStrDate, inoutDateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false)
        
        let futureDate = CustomDateFormat.convertStringToDate(futureStrDate, inoutDateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false)
        
        let changeDatePicker = customDatePicker()
        changeDatePicker.commonDatePickerSetup(datePickerMode: .date, selectedDate: Date())
        
        changeDatePicker.commonDatePickerSetup(datePickerMode: .date, minDate: pastDate, maxDate: futureDate, selectedDate: Date())
        changeDatePicker.onSelectedDate = {(selectedDate: String) in
           print(selectedDate)
        }
        changeDatePicker.toolbarAction = {
            (action : DatePickerToolBarAction) in
            if action == .done{
                print("Done")
            }else{
                 print("Cancel")
            }
        }
    }
    
    func callDateFunction(){

        /*
        print("Current Date : \(CustomDateFormat.getCurrentDate(dateFormatter: kd_MMM_yyyy, useUTC: false))")
        print("Current Date : \(CustomDateFormat.getCurrentDate(dateFormatter: kd_MMM_yyyy, useUTC: true))")
        */
        
        /*
        print("Current Time : \(CustomDateFormat.getCurrentTime(timeFormatter: kHH_mm_ss))")
        */
        
        /*
        print("Past Date : \(CustomDateFormat.getPastDate(numberOfDays: 12,dateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false))")
        print("Past Date : \(CustomDateFormat.getPastDate(numberOfDays: 12,dateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: true))")
        */
        
        /*
        print("Future Date : \(CustomDateFormat.getFutureDate(numberOfDays: 12,dateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false))")
        print("Future Date : \(CustomDateFormat.getFutureDate(numberOfDays: 12,dateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: true))")
        */
        
        /*
        print("Change in 24 hours to 12 hours format \(CustomDateFormat.changetoHourDateFormat("02/19/2019 15:10:20", inputDateFormatter: kMM_dd_yyyy_HH_mm_ss,outputDateFormatter: kyyyy_MM_dd_hh_mm_ss_a, useUTC: false))")

        print("Change in 24 hours to 12 hours format \(CustomDateFormat.changetoHourDateFormat("02/19/2019 15:10:20", inputDateFormatter: kMM_dd_yyyy_HH_mm_ss,outputDateFormatter: kyyyy_MM_dd_hh_mm_ss_a, useUTC: true))")
        */

        /*
        print("Change in 12 hours to 24 hours format \(CustomDateFormat.changetoHourDateFormat("2019-02-19 03:10:25 pm", inputDateFormatter: kyyyy_MM_dd_hh_mm_ss_a,outputDateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false))")

        print("Change in 12 hours to 24 hours format \(CustomDateFormat.changetoHourDateFormat("2019-02-19 03:10:25 pm", inputDateFormatter: kyyyy_MM_dd_hh_mm_ss_a,outputDateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: true))")
        */
        
        /*
        print ("Merge Date and time and change of Date Format \(CustomDateFormat.mergeAndChangetoDateTimeFormat("2019-02-19", withTime: "13:10:25", inputDateFormatter: kyyyy_MM_dd_HH_mm_ss, outputDateFormatter: kyyyy_MM_dd_hh_mm_ss_a, useUTC: false))")

        print ("Merge Date and time and change of Date Format \(CustomDateFormat.mergeAndChangetoDateTimeFormat("2019-02-19", withTime: "13:10:25", inputDateFormatter: kyyyy_MM_dd_HH_mm_ss, outputDateFormatter: kyyyy_MM_dd_hh_mm_ss_a, useUTC: true))")
        */
        
        /*
        print("Merge Date and time and retrun in Date Value \(CustomDateFormat.mergeDateAndTime("2019-02-19", withTime: "13:10:25", inoutDateFormatter: kyyyy_MM_dd_HH_mm_ss, useUTC: false))")

        print("Merge Date and time and retrun in Date Value \(CustomDateFormat.mergeDateAndTime("2019-02-19", withTime: "13:10:25", inoutDateFormatter: kyyyy_MM_dd_HH_mm_ss, useUTC: true))")

        */
        
        /*
        print("Convert Date to String \(CustomDateFormat.convertDateToString(Date(), inoutDateFormatter: kyyyy_MM_dd_HH_mm_ss, useUTC: false))")
        
        print("Convert Date to String \(CustomDateFormat.convertDateToString(Date(), inoutDateFormatter: kyyyy_MM_dd_HH_mm_ss, useUTC: true))")
        */
        
        /*
        let utcTime = "2019-03-14T11:42:00.269"
        print("date : \(utcTime)")
        */
 
        /*
        print("Convert UTC to GMT \(CustomDateFormat.ConvertStrDateUTCtoGMT(strDate: utcTime, inDateFormatter: kyyyy_MM_dd_T_HH_mm_ss_sss, outDateFormatter: kyyyy_MM_dd_T_HH_mm_ss_sss))")
        */
        
        /*
        print("Convert GMT to UTC \(CustomDateFormat.ConvertStrDateGMTtoUTC(strDate: utcTime, inDateFormatter: kyyyy_MM_dd_T_HH_mm_ss_sss, outDateFormatter: kyyyy_MM_dd_hh_mm_ss_a))")
        */
        
        /*
        print ("Check hour format of device: \(CustomDateFormat.timeIs24HourFormat())")
        */
        
        /*
        print("get seconds from current date : \(CustomDateFormat.getCurrentSeconds(strDate: utcTime, strDateFormat: kyyyy_MM_dd_T_HH_mm_ss_sss, isDateOnly: false)))")
        */

        /*
        print("Change Datge format: \(CustomDateFormat.getStringFromDate(date: Date()))")
        */
        
        /*
        print("get different from date : \(CustomDateFormat.convertMonthYearFormater(utcTime, inoutDateFormatter: kyyyy_MM_dd_T_HH_mm_ss_sss))")
        */
        
        /*
        // get date in string
        let pastStrDate = CustomDateFormat.getPastDate(numberOfDays: 2,dateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false)
        let futureStrDate =  CustomDateFormat.getFutureDate(numberOfDays: 2,dateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false)

        // convert into string
        let pastDate = CustomDateFormat.convertStringToDate(pastStrDate, inoutDateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false)

        let futureDate = CustomDateFormat.convertStringToDate(futureStrDate, inoutDateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false)

        print("Comparison between two dates : \(CustomDateFormat.isGraterThan(date1: futureDate, date2: pastDate))")

        print("Comparison between two dates : \(CustomDateFormat.isLessThan(date1: pastDate, date2: futureDate))")

        print("Comparison between two dates : \(CustomDateFormat.isEqual(date1: pastDate, date2: futureDate))")
        */
        
        /*
        let pastStrDate = CustomDateFormat.getPastDate(numberOfDays: 736,dateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false)
        let pastDate = CustomDateFormat.convertStringToDate(pastStrDate, inoutDateFormatter: kMM_dd_yyyy_HH_mm_ss, useUTC: false)
        print("get Age From date : \(CustomDateFormat.getAge(pastDate))")
        */
    }
    
    func displayWebViewJS(){
    //    CustomWebkitView.handleJavaScriptinWebView(vc: self,handleMethodName: "callbackHandler",htmlFileName: "OrderYearbook")
//        CustomWebkitView.handleDelegateMethods(vc: self, strURL: "https://learnappmaking.com")
    }
    
    func createCSVFile(){
        if let path = Bundle.main.path(forResource: "Employee", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
               
                    Utility.createCSV(strFileName: "test.csv", values: JSON(jsonResult))
                    // do stuff
               
            } catch {
                // handle error
            }
        }
    }
    
    func createCSVHTMDATA() -> String{
        let strHTML = "<html><body><h1>This is heading 1</h1><h2>This is heading 2</h2><h3>This is heading 3</h3><h4>This is heading 4</h4><h5>This is heading 5</h5><h6>This is heading 6</h6></body></html>"
        return strHTML
    }
    
    func createPDFFile(){
        Utility.createPDF(strFileName:"test.pdf", htmlContent: createCSVHTMDATA())
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    func callViewAnimationActivity(){
        
       /* customView = UIView.init(frame: CGRect(x: 50.0, y: 50.0, width: 200.0, height: 200.0))
        customView.backgroundColor = UIColor.green
        ViewUtility.add(customView, toParentView: self.view, animation: .ANIMATION_UP)
        */
        
       
        customView = UIView.init(frame: CGRect(x: 50.0, y: 100.0, width: 200.0, height: 200.0))
        customView.backgroundColor = UIColor.green
        customView.isUserInteractionEnabled = true
        
        let objGesture = UITapGestureRecognizer.init(target: self, action: #selector(removeView))
        objGesture.delegate = self
        customView.addGestureRecognizer(objGesture)
        ViewUtility.add(customView, toParentView: self.view, animation: .ANIMATION_UP, duration:20)
 
       // ViewUtility.showUIViewLeft(toRightAnimation: customView, currentViewController: self)
 
        
       
       // ViewUtility.show(customView, onParentView: self.view, animation: .ANIMATION_DOWN, duration: 20)
        
       // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
       // let secondVC = storyBoard.instantiateViewController(withIdentifier: "secondVCIdentifier") as! SecondVC
        
       // ViewUtility.showUIViewControllerRight(toLeftAnimation: secondVC, currentViewController: self)
        
        //ViewUtility.showUIViewControllerRight(toLeftAnimation: secondVC, currentViewController: self, ViewControllers: self.navigationController?.viewControllers)
 
       /* self.navigationController?.present(secondVC, animated: false, completion: nil)
        let isSiccess = ViewUtility.checkingViewControllerIsPresent(self.navigationController?.viewControllers, currentViewController: secondVC)
        print(isSiccess)
    */
        
     //  ViewUtility.subView(customView, originMoveTo: CGPoint.zero, with: .ANIMATION_LEFT, duration: 15.0)
    }
    
    @objc func removeView(){
        
       // ViewUtility.hideUIViewControllerTop(toBottomAnimation: customView)
       // ViewUtility.subView(customView, originMoveTo: CGPoint(x: 100.0, y: 100.0), with: .ANIMATION_LEFT, duration: 15.0)
        //ViewUtility.hideUIViewRight(toLeftAnimation: customView)
       // ViewUtility.removeView(fromParent: customView, animation: .ANIMATION_LEFT)
        // ViewUtility.remove(withEffect: customView)
        
       // ViewUtility.remove(self.navigationController, withAnimation: true)
        
        let storyBoard : UIStoryboard = currentStoryboard
        
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "secondVCIdentifier") as! SecondVC
        
        ViewUtility.showUIViewControllerBottom(toTopAnimation: secondVC, andCurrentView: self.view)
    }
    
   
    
}

extension WelcomeVC : WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        if message.name == "callbackHandler",let messageBody = message.body as? String {
            print(messageBody)
            print(message.name)
        }
    }
}

extension WelcomeVC : WKNavigationDelegate,WKUIDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        print(#function)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
        webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
            if (result as? String) != nil
            {
                print("User Agent")
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        Utility.navigateToHTMLLink(controller: self, navigationAction: navigationAction) { (actionPolicy) in
            decisionHandler(actionPolicy)
        }
    }
}
