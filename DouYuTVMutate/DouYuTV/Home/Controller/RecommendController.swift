//
//  RecommendController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
class RecommendController: BaseViewController {

    enum CellIdentifier: String {
        case headerCell, anchorCell, sectionHeader
    }
    
    struct ConstantValue {
        static let pptViewHeight = CGFloat(150.0)
        static let headCollectionViewHeight = CGFloat(100.0)
        static let headViewHeight = ConstantValue.pptViewHeight + ConstantValue.headCollectionViewHeight
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
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: ConstantValue.sectionHeaderHeight)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        collectionView.registerNib(UINib(nibName: String(AnchorCell), bundle: nil), forCellWithReuseIdentifier: CellIdentifier.anchorCell.rawValue)
        collectionView.registerClass(HeaderCell.self, forCellWithReuseIdentifier: CellIdentifier.headerCell.rawValue)
        collectionView.registerNib(UINib(nibName: String(SectionHeaderView), bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CellIdentifier.sectionHeader.rawValue)

        collectionView.backgroundColor = UIColor.whiteColor()

        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var headerView: UIView = {
       let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: ConstantValue.headViewHeight))
        headerView.backgroundColor = UIColor.blueColor()
        return headerView
    }()
    
    lazy var headerCollectionView: HeaderCollectionView = {
        let headerFrame = CGRect(x: 0.0, y: self.pptView.frame.maxY, width: self.view.bounds.width, height: ConstantValue.headCollectionViewHeight)
        
        let headerCollectionView = HeaderCollectionView(frame: headerFrame, onClickItemAtIndexPath: { (indexPath) in
            let model = self.viewModel.data[indexPath.row]
            let viewModel = AllListViewModel(tagID: String(model.tagIdInt))
            let liveVc = AllListController(viewModel: viewModel)
            liveVc.title = model.tag_name
            self.showViewController(liveVc, sender: nil)

        })

        return headerCollectionView
    }()
    /// 轮播图
    lazy var pptView: PPTView = {

        let pptView = PPTView.PPTViewWithImagesCount {
            return self.viewModel.pptData.count
        }
        .setupImageAndTitle({ (titleLabel, imageView, index) in
//            let model = self.viewModel.pptData.value[index]
            let model = self.viewModel.pptData[index]
            titleLabel.textAlignment = .Left
            titleLabel.text = "    " + "\(model.title)"
            imageView.image = UIImage(named: "2")
            imageView.kf_setImageWithURL(NSURL(string: model.pic_url), placeholderImage: UIImage(named: "1"))
            
        })
        .setupPageDidClickAction({ (clickedIndex) in
            let playerVc = PlayerController()
            playerVc.title = "播放"
            playerVc.roomID = String(self.viewModel.pptData[clickedIndex].id)
            self.showViewController(playerVc, sender: nil)
        })
//        let pptView = PPTView(imagesCount: {[unowned self] in
//                return self.pptData.count
//            }, setupImageAndTitle: {[unowned self] (titleLabel, imageView, index) in
//                
//                let model = self.pptData[index]
//                titleLabel.textAlignment = .Left
//                titleLabel.text = "    " + "\(model.title)"
//                imageView.image = UIImage(named: "2")
//                imageView.kf_setImageWithURL(NSURL(string: model.pic_url), placeholderImage: UIImage(named: "1"))
//
//            }, pageDidClick: {[unowned self] (clickedIndex) in
//                
//                let playerVc = PlayerController()
//                playerVc.title = "播放"
//                playerVc.roomID = String(self.pptData[clickedIndex].id)
//                self.showViewController(playerVc, sender: nil)
//        })
        pptView.frame = CGRect(x: 0, y: 0, width: Constant.screenWidth, height: ConstantValue.pptViewHeight)

        pptView.pageControlPosition = .BottomRight

        return pptView
    }()
    
    /// 使用RxSwift
    var viewModel: RecommendViewModel = RecommendViewModel()
    
    /// 不使用RxSwift  (注释第 119, 141--152 ,162代码, 并且打开 第 122, 164--182行代码)
//    var viewModel: RecommendViewModel1 = RecommendViewModel1()
    
    /// 是否是第一次加载数据
    var isFirstTimeLoadData = true
    
    
    // 这里面获取到的view.bounds 不是最终的(ContentView里面设置之后才是准确的frame)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)

        // 下拉刷新
        addRefreshHeader()
        
        bindToViewModel()

    }
    
    func bindToViewModel() {
        viewModel.isLoadFinished.subscribeNext { (finish) in
            if finish {
                self.pptView.reloadData()
                self.collectionView.reloadData()
                self.headerCollectionView.data = self.viewModel.data
                self.collectionView.zj_stopHeaderAnimation()
            }
            else {
                /// 提示错误
            }
        }
        .addDisposableTo(disposeBag)

    }
    
    func addRefreshHeader() {
        let normalAnimator = NormalAnimator.loadNormalAnimatorFromNib()
        normalAnimator.isAutomaticlyHidden = true
        normalAnimator.lastRefreshTimeKey = "recommondHeader"
        collectionView.zj_addRefreshHeader(normalAnimator) { [weak self] in
            
            self?.viewModel.isBeginLoad.value = true
            
//            guard let `self` = self else { return }
//
//            self.viewModel.loadDataWithHandler({ (loadState) in
//                switch loadState {
//                case .success:
//                    self.pptView.reloadData()
//                    self.collectionView.reloadData()
//                    self.headerCollectionView.data = self.viewModel.data
//                    self.collectionView.zj_stopHeaderAnimation()
//
//                case .failure(let errorMessage):
//                    self.collectionView.zj_stopHeaderAnimation()
//
//                    /// 提示错误
//                    print(errorMessage)
//                    break
//                }
//                
//            })
        
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstTimeLoadData {/// 自定刷新
            collectionView.zj_startHeaderAnimation()
            isFirstTimeLoadData = false
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

extension RecommendController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.data.count + 1 // +1作为headerVIew
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.data[section - 1].room_list.count
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.headerCell.rawValue, forIndexPath: indexPath) as! HeaderCell
            if cell.viewWithTag(1994) == nil {
                headerView.tag = 1994
                headerView.addSubview(pptView)
                headerView.addSubview(headerCollectionView)
                cell.contentView.addSubview(headerView)
            }

            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.anchorCell.rawValue, forIndexPath: indexPath) as! AnchorCell
            // 设置数据
            let roomList = viewModel.data[indexPath.section - 1].room_list
            cell.configCell(roomList[indexPath.row])
            

            return cell
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: CellIdentifier.sectionHeader.rawValue, forIndexPath: indexPath) as! SectionHeaderView
        sectionHeader.dataModel = viewModel.data[indexPath.section - 1]
        
        sectionHeader.setMoreBtnOnClickClosure {[unowned self] (dataModel) in
            let viewModel = AllListViewModel(tagID: String(dataModel.tagIdInt))
            let liveVc = AllListController(viewModel: viewModel)
            liveVc.title = dataModel.tag_name
            self.showViewController(liveVc, sender: nil)
        }
        return sectionHeader
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let playerVc = PlayerController()
        playerVc.title = "播放"
        let roomModel = viewModel.data[indexPath.section - 1].room_list[indexPath.row]
        playerVc.roomID = roomModel.room_id
        showViewController(playerVc, sender: nil)
    }
}

extension RecommendController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.bounds.width, height: ConstantValue.headViewHeight)
        }
        return layout.itemSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsZero
        }
        return layout.sectionInset
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeZero
        } else {
            let count = collectionView.numberOfItemsInSection(section)

            return count == 0 ? CGSizeZero : layout.headerReferenceSize
        }
    }
}
