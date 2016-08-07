//
//  UIImageViewExtension.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/15.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

extension UIImageView {
    /// 设置圆角
    func zj_setCircleImage(image: UIImage?) {
        zj_setCircleImage(image, radius: bounds.size.width/2)
    }
    /// 设置圆角
    /// radius
    func zj_setCircleImage(image: UIImage?, radius: CGFloat ) {
        self.image = image?.zj_drawCorner(radius: radius, size: bounds.size)
    }
}