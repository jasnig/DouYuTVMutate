
//
//  PhotoBrowser.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/4.
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

//

import UIKit
// MARK:- PhotoBrowserDelegate
public protocol PhotoBrowserDelegate: NSObjectProtocol {
    /// 更新当前的sourceImageView(update the currentSourceImageView)
    func sourceImageViewForCurrentIndex(index: Int) -> UIImageView?
    ///  正在显示第几页(the current displaying page)
    func photoBrowserDidDisplayPage(currentPage: Int, totalPages: Int)
    ///  将要展示图片, 进入浏览模式, 可以用来进行个性化的设置, 比如在这个时候, 隐藏状态栏 和原来的图片 (photoBrowser is preparing well and will begin display the first page )
    func photoBrowerWillDisplay(beginPage: Int)
    /// 结束展示图片, 将要退出浏览模式,销毁photoBrowser, 可以用来进行个性化的设置 比如显示状态栏, 显示原来的图片(photoBrowser will be dismissed)
    func photoBrowserWillEndDisplay(endPage: Int)
    ///  photoBrowser is now dismissed
    func photoBrowserDidEndDisplay(endPage: Int)
    
    func extraBtnOnClick(extraBtn: UIButton)
}

// 协议扩展, 实现oc协议的optional效果, 当然可以直接在协议前 加上@objc
// just to reach the effect provided by the objective-c's 'optional',but you can also use "@objc"
// MARK:-  extension PhotoBrowserDelegate
extension PhotoBrowserDelegate {
    // 更新当前的sourceImageView
    public func sourceImageViewForCurrentIndex(index: Int) -> UIImageView? {
        return nil
    }
    ///  正在显示第几页
    public func photoBrowserDidDisplayPage(currentPage: Int, totalPages: Int) { }
    //  将要展示图片, 进入浏览模式, 可以用来进行个性化的设置, 比如在这个时候, 隐藏状态栏 和原来的图片
    public func photoBrowerWillDisplay(beginPage: Int) { }
    // 结束展示图片, 将要退出浏览模式,销毁photoBrowser, 可以用来进行个性化的设置 比如显示状态栏, 显示原来的图片
    public func photoBrowserWillEndDisplay(endPage: Int) { }
    public func photoBrowserDidEndDisplay(endPage: Int) { }
    
    ///  点击附加的按钮的响应方法
    public func extraBtnOnClick(extraBtn: UIButton) { }
    
}



public class PhotoBrowser: UIViewController {
    
    // MARK:- public property
    
    /// 点击附加的按钮响应Closure
    public var extraBtnOnClickAction: ((extraBtn: UIButton) -> Void)?
    /// delegate
    public weak var delegate: PhotoBrowserDelegate?
    public var hideToolBar: Bool = false {
        didSet {
            if hideToolBar {
                toolBar.hidden = true
            }
        }
    }
    /// 每一页之间的间隔
    static let contentMargin: CGFloat = 20.0
    /// cell重用id
    static let cellID = "cellID"
    
    // MARK:- private property
    
    private var toolBarStyle: ToolBarStyle!
    // 用于在屏幕旋转的时候(不要改变图片索引和旋转后更新布局)
    private var isOritenting = false
    private var photoModels: [PhotoModel] = []
    
    /// 用来添加当前控制器为子控制器
    private weak var parentVc: UIViewController!
    
    /// 用来记录当前的图片索引 默认为0 这里设置为-1 是为了在进来的时候设置初始为0也能使oldValue != currentIndex
    private var currentIndex: Int = -1 {
        didSet {
            if oldValue == currentIndex { return }
            
            setupToolBarIndexText(currentIndex)
            // 正在显示的页
            delegate?.photoBrowserDidDisplayPage(currentIndex, totalPages: photoModels.count)
            
        }
    }
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        // 每个cell的尺寸  -- 宽度设置为UICollectionView.bounds.size.width ---> 滚一页就是一个完整的cell
        flowLayout.itemSize = CGSize(width: self.view.zj_width + PhotoBrowser.contentMargin, height: self.view.zj_height)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsetsZero
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {[unowned self] in
        
        // 分页每次滚动 UICollectionView.bounds.size.width
        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.zj_width + PhotoBrowser.contentMargin, height: self.view.zj_height), collectionViewLayout: self.flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = true
        collectionView.registerClass(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoBrowser.cellID)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var toolBar: PhotoToolBar = {
        
        let toolBar = PhotoToolBar(frame: CGRect(x: 0.0, y: self.view.zj_height - 44.0, width: self.view.zj_width, height: 44.0), toolBarStyle: ToolBarStyle())
        toolBar.backgroundColor = UIColor.clearColor()
        return toolBar
    }()
    
    // MARK:- life cycle
    public init(photoModels: [PhotoModel], extraBtnOnClickAction: ((extraBtn: UIButton) -> Void)? = nil) {
        self.photoModels = photoModels
        self.extraBtnOnClickAction = extraBtnOnClickAction
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(collectionView)
        self.view.addSubview(toolBar)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self.debugDescription) --- 销毁")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        automaticallyAdjustsScrollViewInsets = false

    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 不能在viewDidLoad里面设置
        setupFrame()
        setupToolBarAction()
        animateZoomIn()
        currentIndex(currentIndex, animated: false)

    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("视图布局完成")
        
        if isOritenting {
            currentIndex(currentIndex, animated: false)
            isOritenting = false
        }
    }
    
    
    // MARK:- orientation
    // 开始旋转
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        // 正在旋转屏幕
        isOritenting = true
        // to solve the error or complaint that 'the behavior of the UICollectionViewFlowLayout is not defined because:
        // the item height must be less that the height of the UICollectionView minus the section insets top and bottom values '
        // http://stackoverflow.com/questions/14469251/uicollectionviewflowlayout-size-warning-when-rotating-device-to-landscape
        
        // Call -invalidateLayout to indicate that the collection view needs to requery the layout information.
        collectionView.collectionViewLayout.invalidateLayout()


    }
    
    public override func shouldAutorotate() -> Bool {
        return true
    }
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
}


// MARK: - public use func (使用方法)
extension PhotoBrowser {
    ///  显示图片浏览器
    ///
    ///  - parameter parentVc:  一般即可传入self
    ///  - parameter beginPage: 初始图片页
    public func show(inVc parentVc: UIViewController, beginPage: Int) {
        currentIndex = beginPage
        self.parentVc = parentVc
        self.view.frame = UIScreen.mainScreen().bounds
        self.parentVc.view.addSubview(self.view)
        self.parentVc.addChildViewController(self)
        self.didMoveToParentViewController(self.parentVc)
        navigationController?.navigationBarHidden = true
        tabBarController?.tabBar.hidden = true
        
    }
    
    ///  用于设置当前的页
    ///
    ///  - parameter currentIndex: 指定的页数
    ///  - parameter animated:     是否执行动画滚动到指定的页
    public func currentIndex(currentIndex: Int, animated: Bool) {
        assert(currentIndex >= 0 && currentIndex < photoModels.count, "设置的下标有误")
        if currentIndex < 0 || currentIndex >= photoModels.count { return }
        // 更新当前下标
        self.currentIndex = currentIndex
        // 滚动到特定的位置  !----> 这里一定要使用collectionView.bounds.size.width来设置偏移量
        collectionView.setContentOffset(CGPoint(x: CGFloat(currentIndex) * collectionView.zj_width, y: 0.0), animated: animated)
        
    }
}

// MARK: - private helper
extension PhotoBrowser {
    /// 当前的sourceImageView, 以便于设置默认图片和执行动画退出
    private func getCurrentSourceImageView(index: Int) -> UIImageView? {
        // 更新当前的sourceImageView, 以便于执行动画退出
        let currentModel = photoModels[index]
        if let sourceView = delegate?.sourceImageViewForCurrentIndex(index) { // 首先判断是否实现了代理方法返回sourceImageView, 如果有,就使用代理返回的
            return sourceView
        } else {// 代理没有返回 就判断是否一开始就设置了sourceImageView
            if let sourceView = currentModel.sourceImageView { //  初始设置了 就使用
                return sourceView
            } else {// 没有设置
                
                return nil
                
            }
        }
        
    }
    
    private func setupFrame() {
        // to solve the error or complaint that 'the behavior of the UICollectionViewFlowLayout is not defined because:
        // the item height must be less that the height of the UICollectionView minus the section insets top and bottom values '
        // http://stackoverflow.com/questions/14469251/uicollectionviewflowlayout-size-warning-when-rotating-device-to-landscape
        
        // Call -invalidateLayout to indicate that the collection view needs to requery the layout information.
        collectionView.collectionViewLayout.invalidateLayout()
        
        let collectionX = NSLayoutConstraint(item: collectionView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let collectionY = NSLayoutConstraint(item: collectionView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let collectionW = NSLayoutConstraint(item: collectionView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: PhotoBrowser.contentMargin)
        let collectionH = NSLayoutConstraint(item: collectionView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0.0)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([collectionX, collectionY, collectionW, collectionH])
        
        let toolBarX = NSLayoutConstraint(item: toolBar, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let toolBarY = NSLayoutConstraint(item: toolBar, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let toolBarW = NSLayoutConstraint(item: toolBar, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let toolBarH = NSLayoutConstraint(item: toolBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 44.0)
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([toolBarX, toolBarY, toolBarW, toolBarH])
        
        
    }
}

// MARK: - toolBar
extension PhotoBrowser {
    
    private func setupToolBarIndexText(index: Int) {
        toolBar.indexText = "\(index + 1)/\(photoModels.count)"
        
    }
    
    private func setupToolBarAction() {
        
        toolBar.saveBtnOnClick = {[unowned self] (saveBtn: UIButton) in
            // 保存到相册
            let currentCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: self.currentIndex, inSection: 0)) as! PhotoViewCell
            guard let currentImage = currentCell.imageView.image else { return }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                UIImageWriteToSavedPhotosAlbum(currentImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                
            })
            
        }
        toolBar.extraBtnOnClick = {[unowned self] (extraBtn: UIButton) in

            self.extraBtnOnClickAction?(extraBtn: extraBtn)
            self.delegate?.extraBtnOnClick(extraBtn)
        }
        
        
    }
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafePointer<Void>) {
        let hud = SimpleHUD(frame:CGRect(x: 0.0, y: (self.view.zj_height - 80)*0.5, width: self.view.zj_width, height: 80.0))

        self.view.addSubview(hud)
        if error == nil {
            // successful
            hud.showHUD("保存成功!", autoHide: true, afterTime: 1.0)
            
        } else {
            // failure
            hud.showHUD("保存失败!", autoHide: true, afterTime: 1.0)
            
        }
    }
}

// MARK: - animation
extension PhotoBrowser {
    
    private func animateZoomIn() {

        let currentModel = photoModels[currentIndex]
        let sourceView = getCurrentSourceImageView(currentIndex)
        
        if let sourceImageView = sourceView {
            //  当前的sourceView 将它的frame从它的坐标系转换为self的坐标系中来
            let window = UIApplication.sharedApplication().keyWindow!
            
            let beginFrame = window.convertRect(sourceImageView.frame, fromView: sourceImageView)
            
//            print("\(beginFrame) --- \(sourceImageView.frame)")
            
            let sourceViewSnap = snapView(sourceImageView)
            //
            sourceViewSnap.frame = beginFrame
            
            var endFrame: CGRect
            
            if let localImage = currentModel.localImage {
                
                // 按照图片比例设置imageView的frame
                let width = localImage.size.width < view.zj_width ? localImage.size.width : view.zj_width
                let height = localImage.size.height * (width / localImage.size.width)
                
                // 长图
                if height > view.zj_height {
                    endFrame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
                    
                } else {
                    // 居中显示
                    endFrame = CGRect(x:(view.zj_width - width) / 2, y: (view.zj_height - height) / 2, width: width, height: height)
                }
                
                
            } else {
                if let placeholderImage = sourceImageView.image {
                    // 按照图片比例设置imageView的frame
                    let width = placeholderImage.size.width < self.view.zj_width ? placeholderImage.size.width : self.view.zj_width
                    let height = placeholderImage.size.height * (width / placeholderImage.size.width)
                    // 长图
                    if height > view.zj_height {
                        endFrame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
                        
                    } else {
                        // 居中显示
                        endFrame = CGRect(x:(view.zj_width - width) / 2, y: (view.zj_height - height) / 2, width: width, height: height)
                        
                    }
                } else {
                    endFrame = CGRectZero
                }
            }
            
            window.addSubview(sourceViewSnap)
            view.alpha = 1.0
            collectionView.hidden = true
            toolBar.hidden = true
            // 将要进入浏览模式
            delegate?.photoBrowerWillDisplay(currentIndex)
            UIView.animateWithDuration(0.5, animations: {
                
                sourceViewSnap.frame = endFrame
            }) {[unowned self] (_) in
                sourceViewSnap.removeFromSuperview()
                self.collectionView.hidden = false
                self.toolBar.hidden = false
                
            }

        } else {
            view.alpha = 0.0

            // 将要进入浏览模式
            delegate?.photoBrowerWillDisplay(currentIndex)
            UIView.animateWithDuration(0.5, animations: {[unowned self] in
                self.view.alpha = 1.0
            }) { (_) in

                
            }
        }
    }
    
    private func animateZoomOut() {
        navigationController?.navigationBarHidden = false
        tabBarController?.tabBar.hidden = false

        let sourceView = getCurrentSourceImageView(currentIndex)
        
        if let sourceImageView = sourceView {
            // 当前的cell一定可以获取到
            let currentCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: self.currentIndex, inSection: 0)) as! PhotoViewCell
            let currentImageView: UIView
            // 如果超出imageView屏幕则截取整个屏幕
            if currentCell.imageView.bounds.size.height > view.zj_height {
                currentImageView = currentCell.contentView
            } else {
                currentImageView = currentCell.imageView
            }
            
            let currentImageSnap = snapView(currentImageView)
            
            let window = UIApplication.sharedApplication().keyWindow!
            window.addSubview(currentImageSnap)
            //        let beginFrame = window.convertRect(currentImageView.frame, toView: window)
            //        print(beginFrame)
            currentImageSnap.frame = currentImageView.frame
//            print(currentImageView.frame)
            let endFrame = sourceImageView.convertRect(sourceImageView.frame, toView: window)
//            print(endFrame)
            // 将要退出
            delegate?.photoBrowserWillEndDisplay(currentIndex)
            
            UIView.animateWithDuration(0.5, animations: {[unowned self] in
                currentImageSnap.frame = endFrame
                self.view.alpha = 0.0
                
            }) {[unowned self] (_) in
                // 退出浏览模式
                self.delegate?.photoBrowserDidEndDisplay(self.currentIndex)
                currentImageSnap.removeFromSuperview()
                
                self.willMoveToParentViewController(nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }

        } else {
            delegate?.photoBrowserWillEndDisplay(currentIndex)
            
            UIView.animateWithDuration(0.5, animations: {[unowned self] in
                self.view.alpha = 0.0
                
            }) {[unowned self] (_) in
                // 退出浏览模式
                self.delegate?.photoBrowserDidEndDisplay(self.currentIndex)
                
                self.willMoveToParentViewController(nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }
        }
    }
    
    private func snapView(view: UIView) -> UIView {
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        view.layer.renderInContext(context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: image)
        return imageView
        
    }
    
    private func dismiss() {
        animateZoomOut()
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoBrowser: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public final func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public final func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    public final func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowser.cellID, forIndexPath: indexPath) as! PhotoViewCell
        // 避免出现重用出错的问题(to avoid reusing mistakes)
        cell.resetUI()
        let currentModel = photoModels[indexPath.row]
        // 可能在代理方法中重新设置了sourceImageView,所以需要更新当前的sourceImageView
        // maybe we update the sourceImageView through the delegare, so we need to reset the currentModel.sourceImageView
        currentModel.sourceImageView = getCurrentSourceImageView(indexPath.row)
        cell.photoModel = currentModel
        
        // 注意之前直接传了self的一个函数给singleTapAction 造成了循环引用
        cell.singleTapAction = {[unowned self](ges: UITapGestureRecognizer) in
            self.dismiss()
        }
        
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //        let size = UIScreen.mainScreen().bounds.size
        return collectionView.bounds.size
    }
    
    public final func scrollViewDidScroll(scrollView: UIScrollView) {
        if isOritenting { return }
        // 向下取整
        currentIndex = Int(scrollView.contentOffset.x / scrollView.zj_width + 0.5)
//                print(currentIndex)
    }
    
}