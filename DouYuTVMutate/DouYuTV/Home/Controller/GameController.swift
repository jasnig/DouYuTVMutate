//
//  GameController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
class GameController: BaseViewController {
    let cellID = "cellID"
    var viewModel = GameViewModel()

    lazy var layout: UICollectionViewFlowLayout = {
        let cellMargin:CGFloat = 10.0
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = cellMargin
        layout.minimumInteritemSpacing = 0
        
        layout.itemSize = CGSize(width: (Constant.screenWidth - 2*cellMargin)/4, height: 95.0)
        layout.scrollDirection = .Vertical
        // 间距
        layout.sectionInset = UIEdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin)
        return layout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        collectionView.registerNib(UINib(nibName: String(GameCell), bundle: nil), forCellWithReuseIdentifier: self.cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.whiteColor()

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        // 加载数据
        self.viewModel.loadDataWithHandler({[weak self] (loadState) in
            guard let `self` = self else { return }
            self.collectionView.reloadData()
        })

    }
    
    override func addConstraints() {
        super.addConstraints()
        collectionView.snp_makeConstraints { (make) in
            make.leading.equalTo(view)
            make.top.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension GameController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! GameCell
        
        cell.confinCell(viewModel.data[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = viewModel.data[indexPath.row]
        let allListViewModel = AllListViewModel(tagID: model.tag_id)
        let liveVc = AllListController(viewModel: allListViewModel)
        liveVc.title = model.tag_name
        self.showViewController(liveVc, sender: nil)
    }
}
