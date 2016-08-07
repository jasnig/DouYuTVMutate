//
//  EntertainmentController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class EntertainmentController: BaseViewController {
    
    enum CellIdentifier: String {
        case headerCell, anchorCell, sectionHeader
    }
    
    struct ConstantValue {
        static let headViewHeight = CGFloat(200.0)
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
    
    lazy var headerCollectionView: HeaderCollectionView = {
        
        let headerCollectionView = HeaderCollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: ConstantValue.headViewHeight), onClickItemAtIndexPath: {[weak self] (indexPath) in
            guard let `self` = self else { return }

            let model = self.viewModel.data[indexPath.row]
            let listViewModel = AllListViewModel(tagID: model.tagIdString)
            let liveVc = AllListController(viewModel: listViewModel)
            liveVc.title = model.tag_name
            
            self.showViewController(liveVc, sender: nil)
            
            
        })
        
        return headerCollectionView
    }()

    var viewModel: EntertainmentViewModel = EntertainmentViewModel()
    
    var isFirstTimeLoadData = true

    // 这里面获取到的view.bounds 不是最终的(ContentView里面设置之后才是准确的frame)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
       addRefreshHeader()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstTimeLoadData {
            collectionView.zj_startHeaderAnimation()
            isFirstTimeLoadData = false
        }
    }
    
    func addRefreshHeader() {
        collectionView.zj_addRefreshHeader(NormalAnimator.loadNormalAnimatorFromNib()) { [weak self] in
            guard let `self` = self else { return }
            
            self.viewModel.loadDataWithHandler({ (loadState) in
                switch loadState {
                case .success:
                    self.collectionView.reloadData()
                    self.headerCollectionView.data = self.viewModel.data
                    self.collectionView.zj_stopHeaderAnimation()
                    
                case .failure(let errorMessage):
                    self.collectionView.zj_stopHeaderAnimation()
                    
                    /// 提示错误
                    print(errorMessage)
                    break
                }
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

extension EntertainmentController: UICollectionViewDelegate, UICollectionViewDataSource {
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
                headerCollectionView.tag = 1994
                cell.contentView.addSubview(headerCollectionView)
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
            let listViewModel = AllListViewModel(tagID: dataModel.tagIdString)
            let liveVc = AllListController(viewModel: listViewModel)
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


extension EntertainmentController: UICollectionViewDelegateFlowLayout {
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

