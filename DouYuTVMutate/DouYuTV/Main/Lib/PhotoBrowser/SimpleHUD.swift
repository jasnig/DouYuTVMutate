//
//  SimpleHUD.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/15.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles

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

class SimpleHUD: UIView {
    
    class LoadingView: UIView {
        
        private let lineWidth: CGFloat = 8.0
        private var radius: CGFloat {
            return min(zj_width, zj_height) * 0.5
        }
        
        private var progressText: String = "0%" {
            didSet {
                addSubview(progressLabel)
                progressLabel.text = progressText
            }
        }
        
        private lazy var progressLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 10.0, y: (self.zj_height - 30.0) * 0.5, width: self.zj_width - 20.0, height: 30.0))
            label.center = self.center
            label.font = UIFont.boldSystemFontOfSize(16.0)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            
            return label
        }()
        
        
        var progress: Double = 0.0 {
            didSet {
                //            print(progress)
                if progress >= 1.0 { // 加载完成
                    removeFromSuperview()
                }
                progressText = "\(String(format: "%.0f", progress * 100))%"
                
                // 调用这个方法会执行drawRect方法
                setNeedsDisplay()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            layer.cornerRadius = frame.size.width * 0.5
            layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func drawRect(rect: CGRect) {
            
            
            let context = UIGraphicsGetCurrentContext()
            
            // 画圆环
            CGContextSetLineWidth(context, lineWidth)
            
            CGContextSetLineCap(context, .Round)
            let endAngle = CGFloat(progress * M_PI * 2 - M_PI_2 + 0.01)
            
            CGContextAddArc(context, rect.size.width/2, rect.size.height/2, radius, -CGFloat(M_PI_2), endAngle, 0)
            
            CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
            CGContextStrokePath(context)
            
        }
        
    }
    
    /// 加载错误提示
    private lazy var messageLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: (self.bounds.size.width - 80.0) * 0.5, y:0.0, width: 80.0 , height: 30.0))
        
        label.font = UIFont.boldSystemFontOfSize(16.0)
        label.backgroundColor = UIColor.blackColor()
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.layer.masksToBounds = true
        
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        return label
    }()
    
    var progress: Double = 0.01 {
        willSet {
            loadingView.progress = newValue
        }
    }
    
    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView(frame: CGRect(x: (self.bounds.width - 80)*0.5, y: (self.bounds.height - 80)*0.5, width: 80.0, height: 80.0))
        return loadingView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addLoadingView() {
        messageLabel.removeFromSuperview()
        addSubview(loadingView)
        
    }
    
    ///
    ///
    ///  - parameter autoHide: 是否自动隐藏
    ///  - parameter time:     自动隐藏的时间 只有当autoHide = true的时候有效
    func showHUD(text: String, autoHide: Bool, afterTime time: Double) {
        
        loadingView.removeFromSuperview()
        addSubview(messageLabel)
        messageLabel.text = text
        
        let textSize = (text as NSString).boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), 0.0), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: messageLabel.font], context: nil)
        messageLabel.frame = CGRect(x: (self.bounds.width - textSize.width - 16)*0.5, y: (self.bounds.height - 40.0)*0.5, width: textSize.width + 16, height: 40.0)
        
        messageLabel.layer.cornerRadius = messageLabel.bounds.height / 2

        
        if autoHide {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {[unowned self] in
                self.hideHUD()
                
            })
        }
        
    }
    func hideLoadingView() {
        loadingView.removeFromSuperview()
    }
    func hideHUD() {
        self.removeFromSuperview()
    }
}