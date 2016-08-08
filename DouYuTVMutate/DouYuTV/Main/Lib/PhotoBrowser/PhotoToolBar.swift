//
//  PhotoToolBar.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/9.
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

///  ///  @author ZeroJ, 16-05-24 23:05:11
///
//TODO: 还未使用 (it is not useful now)
struct ToolBarStyle {
    enum ToolBarPosition {
        case Up
        case Down
    }
    /// 是否显示保存按钮
    var showSaveBtn = true
    /// 是否显示附加按钮
    var showExtraBtn = true
    /// toolBar位置
    var toolbarPosition = ToolBarPosition.Down
    
}

class PhotoToolBar: UIView {
    typealias BtnAction = (btn: UIButton) -> Void
    var saveBtnOnClick: BtnAction?
    var extraBtnOnClick: BtnAction?
    
    var indexText: String = " " {
        didSet {
            indexLabel.text = indexText
        }
    }
    
    var toolBarStyle: ToolBarStyle!
    
    /// 保存图片按钮
    private lazy var saveBtn: UIButton = {
        
       let saveBtn = UIButton()
        saveBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveBtn.backgroundColor = UIColor.clearColor()
        saveBtn.setImage(UIImage(named: "feed_video_icon_download_white"), forState: .Normal)
        saveBtn.addTarget(self, action: #selector(self.saveBtnOnClick(_:)), forControlEvents: .TouchUpInside)
        
//        saveBtn.hidden = self.toolBarStyle.showSaveBtn
        return saveBtn
    }()
    /// 附加的按钮
    private lazy var extraBtn: UIButton = {
        let extraBtn = UIButton()
        extraBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        extraBtn.backgroundColor = UIColor.clearColor()
        extraBtn.setImage(UIImage(named: "more"), forState: .Normal)
        extraBtn.addTarget(self, action: #selector(self.extraBtnOnClick(_:)), forControlEvents: .TouchUpInside)
//        extraBtn.hidden = self.toolBarStyle.showExtraBtn

        return extraBtn
    }()
    /// 显示页码
    private lazy var indexLabel:UILabel = {
       let indexLabel = UILabel()
        indexLabel.textColor = UIColor.whiteColor()
        indexLabel.backgroundColor = UIColor.clearColor()
        indexLabel.textAlignment = NSTextAlignment.Center
        indexLabel.font = UIFont.boldSystemFontOfSize(20.0)
        return indexLabel
    }()
    
    init(frame: CGRect, toolBarStyle: ToolBarStyle) {
        super.init(frame: frame)
        self.toolBarStyle = toolBarStyle
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        addSubview(saveBtn)
        addSubview(indexLabel)
        addSubview(extraBtn)
    }
    
    func saveBtnOnClick(btn: UIButton) {
        saveBtnOnClick?(btn:btn)
    }
    func extraBtnOnClick(btn: UIButton) {
        extraBtnOnClick?(btn: btn)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 30.0
        let btnW: CGFloat = 60.0
        
        let saveBtnX = NSLayoutConstraint(item: saveBtn, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: margin)
        let saveBtnY = NSLayoutConstraint(item: saveBtn, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let saveBtnW = NSLayoutConstraint(item: saveBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: btnW)
        let saveBtnH = NSLayoutConstraint(item: saveBtn, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0.0)
        
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([saveBtnX, saveBtnY, saveBtnW, saveBtnH])
        
        let extraBtnX = NSLayoutConstraint(item: extraBtn, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -margin)
        let extraBtnY = NSLayoutConstraint(item: extraBtn, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let extraBtnW = NSLayoutConstraint(item: extraBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: btnW)
        let extraBtnH = NSLayoutConstraint(item: extraBtn, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0.0)
        
        extraBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([extraBtnX, extraBtnY, extraBtnW, extraBtnH])
        
        
        let indexLabelLeft = NSLayoutConstraint(item: indexLabel, attribute: .Leading, relatedBy: .Equal, toItem: saveBtn, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
        let indexLabelY = NSLayoutConstraint(item: indexLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let indexLabelRight = NSLayoutConstraint(item: indexLabel, attribute: .Trailing, relatedBy: .Equal, toItem: extraBtn, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let indexLabelH = NSLayoutConstraint(item: indexLabel, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0.0)
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([indexLabelLeft, indexLabelY, indexLabelRight, indexLabelH])

        
    }

}
