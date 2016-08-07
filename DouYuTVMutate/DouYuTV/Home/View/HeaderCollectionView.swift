//
//  HeaderCollectionView.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class HeaderCollectionView: UIView {

    let cellID = "cellID"
    var data:[TagModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var onClickItemAtIndexPath: ((indexPath: NSIndexPath) -> ())?
    lazy var layout: UICollectionViewFlowLayout = {
        let cellMargin:CGFloat = 10.0
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = cellMargin
        layout.minimumInteritemSpacing = 0
        
        layout.itemSize = CGSize(width: 65.0, height: 95.0)
        layout.scrollDirection = .Horizontal
        // 间距
        layout.sectionInset = UIEdgeInsetsZero
        return layout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.layout)
        collectionView.registerNib(UINib(nibName: String(GameCell), bundle: nil), forCellWithReuseIdentifier: self.cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()
    
    init(frame: CGRect, onClickItemAtIndexPath: ((indexPath: NSIndexPath) -> ())?) {
        self.onClickItemAtIndexPath = onClickItemAtIndexPath
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


extension HeaderCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! GameCell
        cell.confinCell(data[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        onClickItemAtIndexPath?(indexPath: indexPath)
    }
}