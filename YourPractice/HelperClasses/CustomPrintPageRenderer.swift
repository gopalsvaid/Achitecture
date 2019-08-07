//
//  CustomPrintPageRenderer.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 24/06/16.
//  Copyright © 2016 YourPractice. All rights reserved.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {

    let A4PageWidth: CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    
    override init() {
        super.init()
        // Specify the frame of the A4 page.
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
        // Set the page frame.
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        // Set the horizontal and vertical insets (that's optional).
        // self.setValue(NSValue(CGRect: pageFrame), forKey: "printableRect")
        self.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 10.0, dy: 10.0)), forKey: "printableRect")
        self.headerHeight = 50.0
        self.footerHeight = 50.0
    }
    
    override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
        // Specify the header text.
        let headerText: NSString = "Test"
        // Set the desired font.
        let font = UIFont(name: "AmericanTypewriter-Bold", size: 30.0)
        // Specify some text attributes we want to apply to the header text.
        let textAttributes = [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.black]
        // Calculate the text size.
        let textSize = getTextSize(text: headerText as String, font: font)
        // Specify the point that the text drawing should start from.
        let pointX = headerRect.size.width/2 - textSize.width/2
        let pointY = headerRect.size.height/2 - textSize.height/2 + 10
        // Draw the header text.
        headerText.draw(at: CGPoint(x: pointX, y: pointY), withAttributes: textAttributes)
    }
    
    func getTextSize(text: String, font: UIFont!, textAttributes: [NSAttributedString.Key : Any]! = nil) -> CGSize {
        let testLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.paperRect.size.width, height: footerHeight))
        if let attributes = textAttributes {
            testLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        }else {
            testLabel.text = text
            testLabel.font = font!
        }
        testLabel.sizeToFit()
        return testLabel.frame.size
    }
    
}
