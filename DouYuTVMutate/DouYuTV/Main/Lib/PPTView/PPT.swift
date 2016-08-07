//
//  PPT.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/18.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class PPTCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        
        return titleLabel
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = true
        return imageView
    }()
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        titleLabel.frame = CGRect(x: 0, y: bounds.height - 28.0, width: bounds.width, height: 28.0)
        
    }
}

extension PPT: UIScrollViewDelegate {
    
    // 手指触摸到时
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if autoScroll {
            stopTimer()
            
        }
    }
    
    // 松开手指时
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll {
            startTimer()
            
        }
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if fabs(scrollView.contentOffset.x - scrollView.bounds.size.width) > scrollView.bounds.size.width / 2 {
            // 重新加载图片
        }
    }
    
    /// 代码设置scrollview的contentOffSet滚动完成后调用
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        // 重新加载图片
        
    }
    
    /// scrollview的滚动是由拖拽触发的时候,在它将要停止时调用
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 将currentImageView显示在屏幕上
        scrollView.contentOffset = CGPoint(x: bounds.size.width, y: 0)
        
        
    }
    
}

extension PPT: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! PPTCell
        return cell
    }
}
public class PPT: UIView {
    let cellID = "cellId"
    // PageControl位置
    public enum PageControlPosition {
        case TopCenter
        case BottomLeft
        case BottomRight
        case BottomCenter
    }
    
    public typealias PageDidClickAction = (clickedIndex: Int) -> Void
    public typealias SetupImageAndTitle = (titleLabel: UILabel, imageView: UIImageView, index: Int) -> Void
    public typealias ImagesCount = () -> Int
    //MARK:- 可供外部修改的属性
    
    // pageControl的位置 默认为底部中间
    public var pageControlPosition: PageControlPosition = .BottomCenter
    
    // 点击响应
    public var pageDidClick:PageDidClickAction?
    
    // 设置图片和标题, 同时可以设置相关的控件的属性
    public var setupImageAndTitle: SetupImageAndTitle?
    
    // 滚动间隔
    public var timerInterval = 3.0
    /// 计时器
    private var timer: NSTimer?
    
    private lazy var pageControl: UIPageControl = {
        let pageC = UIPageControl()
        pageC.currentPage = 0
        pageC.hidesForSinglePage = true
        pageC.userInteractionEnabled = false
        
        return pageC
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    /// 图片总数, 需要在初始化的时候指定*
    var imagesCount: ImagesCount!
    /// 总页数
    private var pageCount: Int {
        return max(self.imagesCount(), 1)
    }
    /// 其他page的颜色
    public var pageIndicatorTintColor = UIColor.whiteColor() {
        willSet {
            pageControl.pageIndicatorTintColor = newValue
        }
    }
    
    /// 当前page的颜色
    public var currentPageIndicatorTintColor = UIColor.whiteColor() {
        willSet {
            pageControl.currentPageIndicatorTintColor = newValue
        }
    }
    
    /// 是否自动滚动, 默认为自动滚动
    public var autoScroll = true {
        willSet {
            if !newValue {
                stopTimer()
            }
        }
    }
    
    /// 开启倒计时
    private func startTimer() {
        if timer == nil {
            timer = NSTimer(timeInterval: timerInterval, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    /// 停止倒计时
    private func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
    }
    
    /// 计时器响应方法
    func timerAction() {
        // 更新位置, 更换图片
        
        UIView.animateWithDuration(3.0, animations: {
            self.collectionView.setContentOffset(CGPoint(x: self.bounds.size.width * 2, y: 0), animated: true)
            
            }, completion: nil)
        
    }
    
    func imageTapdAction() {
        //        pageDidClick?(clickedIndex:currentIndex)
    }
    
    deinit {
        //        debugPrint("\(self.debugDescription) --- 销毁")
        stopTimer()
    }
    
    /// 当父view将释放的时候需要 释放掉timer以释放当前view
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview == nil {
            stopTimer()
            
        }
    }
    
}
