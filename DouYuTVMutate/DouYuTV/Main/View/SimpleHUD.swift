//
//  SimpleHUD.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/19.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class SimpleHUD: UIView {
    
    /// 加载错误提示
    private lazy var messageLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        
        label.font = UIFont.boldSystemFontOfSize(16.0)
        label.backgroundColor = UIColor.blackColor()
        label.layer.masksToBounds = true
        
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        addSubview(messageLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    ///
    ///  - parameter autoHide: 是否自动隐藏
    ///  - parameter time:     自动隐藏的时间 只有当autoHide = true的时候有效
    class func showHUD(text: String, autoHide: Bool, afterTime time: Double) {
        
        if let window = UIApplication.sharedApplication().keyWindow {
            let hud = SimpleHUD(frame: CGRect(origin: CGPointZero, size: window.bounds.size))
            window.addSubview(hud)
            
            hud.messageLabel.text = text
            let textSize = (text as NSString).boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), 0.0), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: hud.messageLabel.font], context: nil)
            
            hud.messageLabel.frame = CGRect(x: (UIScreen.mainScreen().bounds.width - textSize.width - 16)*0.5, y: (UIScreen.mainScreen().bounds.height - 40.0)*0.5, width: textSize.width + 16, height: 40.0)
            
            hud.messageLabel.layer.cornerRadius = hud.messageLabel.bounds.height / 2
            
            if autoHide {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    SimpleHUD.hideHUD()
                    
                })
            }
        }
        
    }
    
   class func hideHUD() {
        if let window = UIApplication.sharedApplication().keyWindow {
            for subview in window.subviews {
                if subview is SimpleHUD {
                    subview.removeFromSuperview()
                }
            }
        }
    }


}
