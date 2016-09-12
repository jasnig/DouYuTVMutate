//
//  UIButton+Extension.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/8/12.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

private var touchKey = "touchKey"

class ButtonHandler: NSObject {
    typealias Handler = (btn: UIButton) -> Void
    
    var onClickBtnClosure: ((btn: UIButton) -> Void)?
    
    func touchUpInsede(btn: UIButton) {
        onClickBtnClosure?(btn: btn)
    }
}
extension UIButton {
    
    //    override public class func initialize() {
    //
    //    }
    
    private var btnHandler: ButtonHandler? {
        set {
            objc_setAssociatedObject(self, &touchKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &touchKey) as? ButtonHandler
        }
    }
    
    convenience init(frame: CGRect, callBack: (btn: UIButton) -> Void) {
        self.init(frame: frame)
        btnHandler = ButtonHandler()
        btnHandler?.onClickBtnClosure = callBack
        self.addTarget(btnHandler, action: #selector(ButtonHandler.touchUpInsede(_:)), forControlEvents: .TouchUpInside)
    }
    
    
}