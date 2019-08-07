//
//  ViewUtility.swift
//  YourPractice
//
//  Created by Devangi Shah on 27/03/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import Foundation
import UIKit

enum ViewAnimation{
    
    case ANIMATION_UP
    case ANIMATION_DOWN
    case ANIMATION_LEFT
    case ANIMATION_RIGHT
}

class ViewUtility: NSObject {

    class func add(_ view: UIView?, toParentView parent: UIView?, animation: ViewAnimation){
        parent?.isUserInteractionEnabled = false
       view?.frame = self.getViewPositionOffScreen(animation, isAddiing: true)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            view?.frame = CGRect(x: 0, y: 0, width: kDEVICE_WIDTH, height: kDEVICE_HEIGHT)
        }) { finished in
            parent?.isUserInteractionEnabled = true
        }
        if let view = view {
            parent?.addSubview(view)
        }
    }
    
    class func removeView(fromParent view: UIView?, animation: ViewAnimation) {
        view?.frame = CGRect(x: 0, y: 0, width: kDEVICE_WIDTH, height: kDEVICE_HEIGHT)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            view?.frame = self.getViewPositionOffScreen(animation, isAddiing: false)
            view?.frame = (view?.frame)!
        }) { finished in
            if finished {
                view?.removeFromSuperview()
            }
        }
    }
    
    
    class func getViewPositionOffScreen(_ animation: ViewAnimation, isAddiing isAdding: Bool) -> CGRect {
    
        switch animation {
        case .ANIMATION_UP:
            return CGRect(x: 0, y: isAdding ? kDEVICE_HEIGHT : -kDEVICE_HEIGHT, width: kDEVICE_WIDTH, height: kDEVICE_HEIGHT)
        case .ANIMATION_DOWN:
            return CGRect(x: 0, y: isAdding ? -kDEVICE_HEIGHT : kDEVICE_HEIGHT, width: kDEVICE_WIDTH, height: kDEVICE_HEIGHT)
        case .ANIMATION_LEFT:
            return CGRect(x: isAdding ? kDEVICE_WIDTH : -kDEVICE_WIDTH, y: 0, width: kDEVICE_WIDTH, height: kDEVICE_HEIGHT)
        case .ANIMATION_RIGHT:
            return CGRect(x: isAdding ? -kDEVICE_WIDTH : kDEVICE_WIDTH, y: 0, width: kDEVICE_WIDTH, height: kDEVICE_HEIGHT)
        }
    }

    
    //PRAGMA MARK: Remove Animation
    class func remove(withEffect myView: UIView?) {
        UIView.beginAnimations("removeWithEffect", context: nil)
        UIView.setAnimationDuration(0.4)
        myView?.frame = CGRect(x: 0, y: 0, width: 320, height: kDEVICE_HEIGHT)
        myView?.alpha = 0.0
        UIView.commitAnimations()
       // myView?.perform(#selector(self.removeFromSuperview), with: nil, afterDelay: 0.7)
    }
    
    class func remove(_ navigationController: UINavigationController?, withAnimation animate: Bool = false) {
        let navigationControllerTemp: UINavigationController? = navigationController
        navigationControllerTemp?.popViewController(animated: animate)
        navigationControllerTemp?.view.removeFromSuperview()
        navigationControllerTemp?.removeFromParent()
    }

    class func removeSubviews(from view: UIView?) {
        if view != nil {
            for subView in view?.subviews ?? [] {
                subView.removeFromSuperview()
            }
        }
    }

    class func showUIViewControllerRight(toLeftAnimation viewController: UIViewController?, currentViewController: UIViewController?) {
        currentViewController?.view.isUserInteractionEnabled = false
        currentViewController?.parent?.view.isUserInteractionEnabled = false
        currentViewController?.parent?.parent?.view.isUserInteractionEnabled = false
        currentViewController?.parent?.parent?.parent?.view.isUserInteractionEnabled = false
        if let viewController = viewController
        {
            viewController.view.frame = CGRect(x: kDEVICE_WIDTH, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)

            currentViewController?.parent?.addChild(viewController)
            currentViewController?.parent?.view.addSubview(viewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions(rawValue: 1), animations: {
            
            viewController.view.frame = CGRect(x: 0, y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height)
            
        }) { finished in
                if let currentViewController = currentViewController{
                    currentViewController.view.isUserInteractionEnabled = true
                    currentViewController.parent?.view.isUserInteractionEnabled = true
                    currentViewController.parent?.parent?.view.isUserInteractionEnabled = true
                    currentViewController.parent?.parent?.parent?.view.isUserInteractionEnabled = true
                }
            }
        }
        
    }
    class func showUIViewControllerRight(toLeftAnimation viewController: UIViewController?, currentViewController: UIViewController?, ViewControllers: [Any]?) {
        
        if self.checkingViewControllerIsPresent(ViewControllers, currentViewController: currentViewController){
            currentViewController?.view.isUserInteractionEnabled = false
            currentViewController?.parent?.view.isUserInteractionEnabled = false
            currentViewController?.parent?.parent?.view.isUserInteractionEnabled = false
            currentViewController?.parent?.parent?.parent?.view.isUserInteractionEnabled = false
            
            if let viewController = viewController
            {
                viewController.view.frame = CGRect(x: kDEVICE_WIDTH, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.height)
                
                currentViewController?.parent?.addChild(viewController)
                currentViewController?.parent?.view.addSubview(viewController.view)
                
                UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions(rawValue: 1), animations: {
                    
                    viewController.view.frame = CGRect(x: 0, y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height)
                }) { finished in
                    if let currentViewController = currentViewController{
                        currentViewController.view.isUserInteractionEnabled = true
                        currentViewController.parent?.view.isUserInteractionEnabled = true
                        currentViewController.parent?.parent?.view.isUserInteractionEnabled = true
                        currentViewController.parent?.parent?.parent?.view.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    
    class func checkingViewControllerIsPresent(_ ViewControllers: [Any]?, currentViewController: UIViewController?) -> Bool {
        let B_ViewPresent = true
        
        for I_Index in 0..<(ViewControllers?.count ?? 0) {
            for Subview in currentViewController?.parent?.view.subviews ?? [] {
                let V_ = ViewControllers?[I_Index] as? UIViewController
                if let V_ =  V_
                {
                    if Subview == V_.view! {
                        return false
                    }
                }
            }
        }
        return B_ViewPresent
    }
    
    class func hideUIViewControllerLeft(toRightAnimation currentViewController: UIViewController?) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions(rawValue: 1), animations: {
            currentViewController?.view.frame = CGRect(x: 320, y: 0, width: currentViewController?.view.bounds.size.width ?? 0.0, height: currentViewController?.view.bounds.size.height ?? 0.0)
            
        }) { finished in
            currentViewController?.removeFromParent()
            currentViewController?.view.removeFromSuperview()
        }
    }
    
    class func showUIViewRight(toLeftAnimation view: UIView?, currentViewController: UIViewController?) {
        view?.isUserInteractionEnabled = false
        
        view?.frame = CGRect(x: kDEVICE_WIDTH, y: 0, width: view?.frame.size.width ?? 0.0, height: view?.frame.size.height ?? 0.0)
        if let view = view {
            currentViewController?.view.addSubview(view)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions(rawValue: 1), animations: {
            
            view?.frame = CGRect(x: 0, y: 0, width: view?.bounds.size.width ?? 0.0, height: view?.bounds.size.height ?? 0.0)
            
        }) { finished in
            currentViewController?.view.isUserInteractionEnabled = true
            view?.isUserInteractionEnabled = true
        }
    }

    class func showUIViewLeft(toRightAnimation view: UIView?, currentViewController: UIViewController?) {
        view?.isUserInteractionEnabled = false
        
        view?.frame = CGRect(x: -kDEVICE_WIDTH, y: 0, width: view?.frame.size.width ?? 0.0, height: view?.frame.size.height ?? 0.0)
        if let view = view {
            currentViewController?.view.addSubview(view)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions(rawValue: 1), animations: {
            
            view?.frame = CGRect(x: 0, y: 0, width: view?.bounds.size.width ?? 0.0, height: view?.bounds.size.height ?? 0.0)
            
        }) { finished in
            currentViewController?.view.isUserInteractionEnabled = true
            view?.isUserInteractionEnabled = true
        }
    }

    
    class func hideUIViewRight(toLeftAnimation view: UIView?) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions(rawValue: 1), animations: {
            view?.frame = CGRect(x: kDEVICE_WIDTH, y: 0, width: view?.bounds.size.width ?? 0.0, height: view?.bounds.size.height ?? 0.0)
            
        }) { finished in
            
            view?.removeFromSuperview()
        }
        
    }
    
    class func hideUIViewLeft(toRightAnimation view: UIView?) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions(rawValue: 1), animations: {
            view?.frame = CGRect(x: -kDEVICE_WIDTH, y: 0, width: view?.bounds.size.width ?? 0.0, height: view?.bounds.size.height ?? 0.0)
            
        }) { finished in
            
            view?.removeFromSuperview()
        }
        
    }
    
    class func centerFrame(_ frame: CGRect, withParentWidth parentWidth: CGFloat, parentHeight: CGFloat) -> CGRect {
        let tmpFrame: CGRect = self.centerFrame(frame, horizontallyWithParentWidth: parentWidth)
        return self.centerFrame(tmpFrame, verticallyWithParentHeight: parentHeight)
    }
    
    class func centerFrame(_ frame: CGRect, horizontallyWithParentWidth parentWidth: CGFloat) -> CGRect {
        return CGRect(x: (parentWidth - frame.size.width) / 2, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
    }
    
    class func centerFrame(_ frame: CGRect, verticallyWithParentHeight parentHeight: CGFloat) -> CGRect {
        return CGRect(x: frame.origin.x, y: (parentHeight - frame.size.height) / 2, width: frame.size.width, height: frame.size.height)
    }
    
    class func subView(_ view: UIView?, originMoveTo newPoint: CGPoint, with animation: ViewAnimation, duration time: Float) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            view?.frame = CGRect(x: newPoint.x, y: newPoint.y, width: view?.frame.size.width ?? 0.0, height: view?.frame.size.height ?? 0.0)
        }) { finished in
            if finished {
            }
        }
    }

    // Do not remove the view form parent
    class func show(_ view: UIView?, onParentView parent: UIView?, animation: ViewAnimation, duration time: Float) {
        parent?.isUserInteractionEnabled = false
        view?.frame = self.getViewPositionOffScreen(animation, isAddiing: true)
        UIView.animate(withDuration: TimeInterval(time), delay: 0.0, options: .curveEaseIn, animations: {
            view?.frame = CGRect(x: 0, y: 0, width: kDEVICE_WIDTH, height: kDEVICE_HEIGHT)
        }) { finished in
            parent?.isUserInteractionEnabled = true
        }
        
        if let view = view {
            parent?.addSubview(view)
        }
    }
    
    class func add(_ view: UIView?, toParentView parent: UIView?, animation: ViewAnimation, duration time: Float) {
        parent?.isUserInteractionEnabled = false
        view?.frame = self.getViewPositionOffScreen(animation, isAddiing: true)
        UIView.animate(withDuration: TimeInterval(time), delay: 0.0, options: .curveEaseIn, animations: {
            view?.frame = CGRect(x: 0, y: 0, width: kDEVICE_WIDTH, height: kDEVICE_HEIGHT)
        }) { finished in
            parent?.isUserInteractionEnabled = true
        }
        if let view = view {
            parent?.addSubview(view)
        }
    }
    
    class func showUIViewControllerBottom(toTopAnimation viewController: UIViewController?, andCurrentView currentViewController: UIView?) {
        viewController?.view.frame = CGRect(x: 0, y: kDEVICE_HEIGHT, width: viewController?.view.frame.size.width ?? 0.0, height: viewController?.view.frame.size.height ?? 0.0)
        
        if let view = viewController?.view {
            currentViewController?.addSubview(view)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions(rawValue: 1), animations: {
            
            viewController?.view.frame = CGRect(x: 0, y: 0, width: viewController?.view.bounds.size.width ?? 0.0, height: viewController?.view.bounds.size.height ?? 0.0)
            
        }) { finished in
        }
    }
    
    class func hideUIViewControllerTop(toBottomAnimation currentView: UIView?) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions(rawValue: 1), animations: {
            currentView?.frame = CGRect(x: 0, y: kDEVICE_HEIGHT, width: currentView?.bounds.size.width ?? 0.0, height: currentView?.bounds.size.height ?? 0.0)
            
        }) { finished in
            currentView?.removeFromSuperview()
        }
    }
}
