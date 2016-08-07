//
//  PageView.swift
//  PPT
//
//  Created by jasnig on 16/4/2.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles
import UIKit

class PPTImageView: UIView {
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
        /// 剪去多余的部分
        imageView.clipsToBounds = true
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

public class PPTView: UIView {
    // 滚动方向
    public enum Direction {
        /// 当前的图片向左移
        case Left
        
        /// 当前的图片向右移
        case Right
        
    }
    
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
    
    /// 图片总数, 需要在初始化的时候指定*
    var imagesCount: ImagesCount!
    /// 总页数
    private var pageCount: Int {
       return self.imagesCount()
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
    
    //MARK:- 私有属性
    private var scrollDirection: Direction = .Left
    
    private var currentIndex = -1
    private var leftIndex = -1
    private var rightIndex = 1
    
    /// 计时器
    private var timer: NSTimer?
    
    private lazy var scrollView: UIScrollView = { [weak self] in
        let scroll = UIScrollView(frame: CGRectZero)
        
        if let strongSelf = self {
            scroll.delegate = strongSelf

        }
        scroll.bounces = false
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.pagingEnabled = true
        return scroll
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageC = UIPageControl()
        pageC.currentPage = 0
        pageC.hidesForSinglePage = true
        pageC.userInteractionEnabled = false
        
        return pageC
    }()
    
    lazy var currentPPTImageView: PPTImageView = {
        let imageView = PPTImageView()
        return imageView
    }()

    lazy var rightPPTImageView = PPTImageView()
    lazy var leftPPTImageView = PPTImageView()
    
    // MARK: - 可链式调用
    public class func PPTViewWithImagesCount(imagesCount: ImagesCount) -> PPTView {
        return PPTView(imagesCount: imagesCount)
    }
    public func setupImageAndTitle(setupImageAndTitle: SetupImageAndTitle) -> Self {
        self.setupImageAndTitle = setupImageAndTitle
        return self
    }
    public func setupPageDidClickAction(pageDidClick: PageDidClickAction?) -> Self {
        self.pageDidClick = pageDidClick
        return self
    }
    
    //MARK:- 初始化
    // 遍历构造器, 不监控点击事件的时候可以使用
    public convenience init(imagesCount: ImagesCount, setupImageAndTitle: SetupImageAndTitle) {
        self.init(imagesCount: imagesCount, setupImageAndTitle: setupImageAndTitle, pageDidClick: nil)
    }

    private init(imagesCount: ImagesCount) {
        self.imagesCount = imagesCount
        super.init(frame: CGRectZero)
        initialization()
    }
    
    public init(imagesCount: ImagesCount, setupImageAndTitle: SetupImageAndTitle, pageDidClick: PageDidClickAction?) {
        
        // 这个Closure 处理点击
        self.pageDidClick = pageDidClick
        // 这个Closure获取图片 相当于UITableView的cellForRow...方法
        self.setupImageAndTitle = setupImageAndTitle
        // 相当于UITableView的numberOfRows...方法
        self.imagesCount = imagesCount
        
        super.init(frame: CGRectZero)
        // 这里面添加了各个控件, 和设置了初始的图片和title
        initialization()
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 初始设置和内部函数
    
    private func initialization()  {
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapdAction))
        tapGuesture.numberOfTapsRequired = 1
        currentPPTImageView.addGestureRecognizer(tapGuesture)
        setupPageControl()
        
        addSubview(scrollView)
        addSubview(pageControl)

        scrollView.addSubview(currentPPTImageView)
        scrollView.addSubview(leftPPTImageView)
        scrollView.addSubview(rightPPTImageView)
        // 添加初始化图片
        loadImages()
        ///
        startTimer()
    }
    
    private func setupPageControl() {
        
        pageControl.numberOfPages = pageCount
        pageControl.sizeForNumberOfPages(pageCount)
    }
    
    
    public func reloadData() {
        currentIndex = -1
        setupPageControl()
        loadImages()
        startTimer()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        let pageHeight:CGFloat = 28.0
        let width = bounds.size.width
        let height = bounds.size.height
        
        switch pageControlPosition {
        case .BottomLeft:
            pageControl.frame = CGRect(x: 0, y: height - pageHeight, width: width / 2, height: pageHeight)
            
        case .BottomCenter:
            pageControl.frame = CGRect(x: 0, y: height - pageHeight, width: width, height: pageHeight)
            
        case .BottomRight:
            pageControl.frame = CGRect(x: width / 2, y: height - pageHeight, width: width / 2, height: pageHeight)
            
        case .TopCenter:
            pageControl.frame = CGRect(x: 0, y: 0, width: width, height: pageHeight)
        }
        
        currentPPTImageView.frame = CGRect(x: width, y: 0, width: width, height: height)
        leftPPTImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        rightPPTImageView.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
        
        scrollView.contentOffset = CGPoint(x: width, y: 0)
        scrollView.contentSize = CGSize(width: 3 * width, height: 0)

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
            self.scrollView.setContentOffset(CGPoint(x: self.bounds.size.width * 2, y: 0), animated: true)
            
        }, completion: nil)
        
    }
    
    func imageTapdAction() {
        pageDidClick?(clickedIndex:currentIndex)
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

extension PPTView: UIScrollViewDelegate {
    
    // 手指触摸到时
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if autoScroll {
            stopTimer()

        }
    }
    
    // 松开手指时
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll {
            scrollDirection = .Left
            startTimer()

        }
    }
    
    /// 代码设置scrollview的contentOffSet滚动完成后调用
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        // 重新加载图片
        scrollDirection = .Left
        loadImages()

    }
    
    /// scrollview的滚动是由拖拽触发的时候,在它将要停止时调用
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 1/2屏
        if fabs(scrollView.contentOffset.x - scrollView.bounds.size.width) > scrollView.bounds.size.width / 2 {
            
            scrollDirection = scrollView.contentOffset.x > bounds.size.width ? .Left : .Right
            // 重新加载图片
            loadImages()
        }
        

    }
    
    
    private func loadImages() {
        
        if pageCount == 0 {
            return
        }
        // 根据滚动方向不同设置将要显示的图片下标
        switch scrollDirection {
            
            case .Left:
                currentIndex = (currentIndex + 1) % pageCount

            case .Right:
  
                currentIndex = (currentIndex - 1 + pageCount) % pageCount
            
        }
        
        leftIndex = (currentIndex - 1 + pageCount) % pageCount
        rightIndex = (currentIndex + 1) % pageCount
        
        setupImageAndTitle?(titleLabel: currentPPTImageView.titleLabel, imageView: currentPPTImageView.imageView, index: currentIndex)
        setupImageAndTitle?(titleLabel: rightPPTImageView.titleLabel, imageView: rightPPTImageView.imageView, index: rightIndex)
        setupImageAndTitle?(titleLabel: leftPPTImageView.titleLabel, imageView: leftPPTImageView.imageView, index: leftIndex)

        
        pageControl.currentPage = currentIndex

        // 将currentImageView显示在屏幕上
        scrollView.contentOffset = CGPoint(x: bounds.size.width, y: 0)

    }
}

