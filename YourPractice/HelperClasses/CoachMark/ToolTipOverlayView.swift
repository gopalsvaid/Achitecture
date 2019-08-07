//
//  ToolTipOverlayView.swift
//  Picsy
//
//  Created by Jaimin Galiya on 26/11/18.
//  Copyright © 2018 YourPractice. All rights reserved.
//

import UIKit

enum ToolTipTextPosition {
    case top
    case bottom
    case bottomCenter
    case topCenter
    case bottomLeft
}

struct ToolTip{
    var infoText: String = String()
    var textPosition: ToolTipTextPosition = .bottom
    var toolTipPosition: CGPoint = CGPoint.zero
    var toolTipImage: UIImage = UIImage()
}

class ToolTipOverlayView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.addTapGesture()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.addTapGesture()
    }

    open var arrOfToolTipData: [ToolTip] = []{
        didSet{
            for toolTipData in arrOfToolTipData{
                self.addSubView(withToolTipData: toolTipData)
            }
        }
    }
    
    func addTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureAction(_ sender: UITapGestureRecognizer){
        if let view = sender.view{
            view.removeFromSuperview()
        }
    }
    
    func addSubView(withToolTipData toolTip: ToolTip){
        var imgWidth: CGFloat = kIS_IPAD ? 75.0 : 50.0
        let imgHeight: CGFloat = kIS_IPAD ? 75.0 : 50.0
        if toolTip.toolTipImage == #imageLiteral(resourceName: "ic_overlay_hand_with_arrow"){
            imgWidth = kIS_IPAD ? 150.0 : 100.0
        }
        let imgView = UIImageView(frame: CGRect(x: toolTip.toolTipPosition.x, y: toolTip.toolTipPosition.y, width: imgWidth, height: imgHeight))
        imgView.image = toolTip.toolTipImage
        imgView.contentMode = .scaleAspectFit
        self.addSubview(imgView)
        let textLbl = UILabel()
        textLbl.text = toolTip.infoText
        textLbl.numberOfLines = 0
        textLbl.font = FONTARIAL12
        textLbl.textColor = Config.whiteColor
        textLbl.sizeToFit()
        textLbl.textAlignment = .center

        switch toolTip.textPosition {
        case .top:
            textLbl.frame.origin.y = imgView.frame.minY - 8.0
            break
        case .bottom:
            textLbl.frame.origin.y = imgView.frame.maxY + 8.0
            break
        case .bottomCenter:
            textLbl.frame.origin.y = imgView.frame.maxY + 12.0
            textLbl.center.x = imgView.center.x
            break
        case .topCenter:
            textLbl.frame.origin.y = imgView.frame.minY - (kIS_IPAD ? 34.0 : 22.0)
            textLbl.center.x = imgView.center.x
            break
        case .bottomLeft:
            textLbl.frame.origin.x = imgView.frame.minX
            textLbl.frame.origin.y = imgView.frame.maxY + 12.0
            textLbl.textAlignment = .left
            break
        }
        
        if textLbl.frame.maxX > self.bounds.maxX{
            let diffX = (textLbl.frame.maxX - self.bounds.maxX) + 8.0
            textLbl.frame.origin.x -= diffX
        }
        
        if imgView.frame.maxY > self.bounds.maxY{
            let diffY = (imgView.frame.maxY - self.bounds.maxY) + 8.0
            imgView.frame.origin.y -= diffY
            textLbl.frame.origin.y -= diffY
        }
        
        self.addSubview(textLbl)
    }
}
