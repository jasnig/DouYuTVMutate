

//
//  File.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/14.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

extension UIImage {
    func zj_drawCorner(radius radius: CGFloat, size: CGSize) -> UIImage {
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        // 开启上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners:UIRectCorner.AllCorners, cornerRadii: CGSize(width: radius, height: radius)).CGPath

        CGContextAddPath(context, path)
        CGContextClip(context)
        
        self.drawInRect(rect)
        
        let imageWithCorner = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        
        return imageWithCorner
        
    }
}


