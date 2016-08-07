//
//  VInterestingController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
class InterestingController: BaseViewController {
    
    struct ConstantValue {
        static let sectionHeaderHeight = CGFloat(44.0)
        static let anchorCellHeight = CGFloat(150.0)
        static let anchorCellMargin = CGFloat(10.0)
    }
    
    lazy var layout: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = ConstantValue.anchorCellMargin
        layout.minimumInteritemSpacing = ConstantValue.anchorCellMargin
        // 每一排显示两个cell
        layout.itemSize = CGSize(width: (self.view.bounds.width - 3*layout.minimumInteritemSpacing)/2, height: ConstantValue.anchorCellHeight)
        layout.scrollDirection = .Vertical
        // 间距
        layout.sectionInset = UIEdgeInsets(top: ConstantValue.anchorCellMargin, left: ConstantValue.anchorCellMargin, bottom: ConstantValue.anchorCellMargin, right: ConstantValue.anchorCellMargin)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        collectionView.registerNib(UINib(nibName: String(AnchorCell), bundle: nil), forCellWithReuseIdentifier: self.anchorCell)
        collectionView.backgroundColor = UIColor.whiteColor()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    let anchorCell = "anchorCell"
    
    var viewModel: InterestViewModel = InterestViewModel()
    
    var isFirstTimeAppear = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        addHeaderAndFooter()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstTimeAppear {
            collectionView.zj_startHeaderAnimation()
            isFirstTimeAppear = false
        }
    }
    
    func addHeaderAndFooter() {
        collectionView.zj_addRefreshHeader(NormalAnimator.loadNormalAnimatorFromNib()) {[weak self] in
            guard let `self` = self else { return }
            
            self.viewModel.headerRefreshWithHandler({ (loadState) in
                // 可以根据不同的加载结果给出提示
                //                switch loadState {
                //                case .success:
                //                    break
                //                case .failure( _):
                //                    break
                //                }
                self.collectionView.reloadData()
                self.collectionView.zj_stopHeaderAnimation()
            })
        }
        
        
        collectionView.zj_addRefreshFooter(NormalAnimator.loadNormalAnimatorFromNib()) {[weak self] in
            guard let `self` = self else { return }
            
            self.viewModel.footerRefreshWithHandler({ (loadState) in
                self.collectionView.reloadData()
                self.collectionView.zj_stopFooterAnimation()
            })
        }
    }
    
    override func addConstraints() {
        super.addConstraints()
        collectionView.snp_makeConstraints { (make) in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension InterestingController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.data.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(anchorCell, forIndexPath: indexPath) as! AnchorCell
        // 设置数据
        
        cell.configCell(viewModel.data[indexPath.row])
        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let playerVc = PlayerController()
        playerVc.roomID = viewModel.data[indexPath.row].room_id
        playerVc.title = "播放"
        showViewController(playerVc, sender: nil)
    }
}

