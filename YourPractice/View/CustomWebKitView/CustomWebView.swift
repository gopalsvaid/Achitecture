//
//  CustomWebView.swift
//  YourPractice
//
//  Created by Jaimin Galiya on 11/07/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit
import WebKit


/**
 The purpose of the `CustomWebView` is to perform webview operations.
 
 The `CustomWebView` class is a subclass of the `WKWebView`.
 */
class CustomWebView: WKWebView {

    let contentController = WKUserContentController()
    let webConfiguration = WKWebViewConfiguration()

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        webConfiguration.userContentController = contentController
        super.init(coder: coder)
    }
    
    func addJavaScriptFunctionHandler(_ viewController: UIViewController,withFunctionName functionName: String){
        if let scriptMessageHandler = viewController as? WKScriptMessageHandler{
            webConfiguration.userContentController.add(scriptMessageHandler, name: functionName)
        }
    }
    
    //MARK : Set HTML Content in WKWebView
    /**
     Set HTML Content in WKWebView
     - Parameter htmlContent: html string to load in webview.
     */
    func setHtmlContent(htmlContent : String){
        self.loadHTMLString(htmlContent, baseURL: nil)
    }
    
    //MARK: Load Url
    /**
     Load url in WKWebView
     - Parameter urlString: string url which is needed to load in webview.
     */
    func loadUrl(_ urlString: String){
        guard let url = URL(string: urlString)else {return}
        let request = URLRequest.init(url: url)
        self.load(request)
    }
}
