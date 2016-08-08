//
//  UIViewExtensionFrame.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/15.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/p/b84f4dd96d0c

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
//MARK: - frame extension
extension UIView {
    /// x
    public final var zj_x: CGFloat {
        set(x) {
            frame.origin.x = x
        }
        
        get {
            return frame.origin.x
        }
    }
    /// y
    public final var zj_y:CGFloat {
        set(y) {
            frame.origin.y = y
        }
        
        get {
            return frame.origin.y
        }
    }
    /// centerX
    public final var zj_centerX: CGFloat {
        set(centerX) {
            center.x = centerX
        }
        
        get {
            return center.x
        }
    }
    /// centerY
    public final var zj_centerY: CGFloat {
        set(centerY) {
            center.y = centerY
        }
        
        get {
            return center.y
        }
    }
    /// width
    public final var zj_width: CGFloat {
        set(width) {
            frame.size.width = width
        }
        
        get {
            return bounds.size.width
        }
    }
    /// height
    public final var zj_height: CGFloat {
        set(height) {
            frame.size.height = height
        }
        
        get {
            return bounds.size.height
        }
    }
    
}