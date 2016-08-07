//
//  UIViewExtension.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/19.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

extension UIView {
    /// controller
    var viewController: UIViewController? {
        var currentView:UIView? = self
        // 当还有superView的时候就循环
        while currentView != nil {
            
            //            if let nextView = currentView!.superview {
            //
            // 遍历到superView是uiwindow的时候就结束了
            //                if nextView is UIWindow {
            //                    let responsder = currentView!.nextResponder()
            //                    if responsder is UIViewController {
            //                        return responsder as? UIViewController
            //                    }
            //                    break
            //                }
            //
            //                currentView = nextView
            //                print(currentView)
            //            }
            
            // 当还有下一级响应者的时候
            if let responder = currentView!.nextResponder() {
                if responder is UIViewController {
                    return responder as? UIViewController
                } else {
                    if let nextView = currentView!.superview {
                        currentView = nextView
                    }
                }
                
            }
        }
        
        return nil
        
    }
}