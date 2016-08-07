//
//  SectionHeaderView.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
import Kingfisher
class SectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBAction func moreBtnOnClick(sender: UIButton) {
        moreBtnOnClickClosure?(dataModel: dataModel)
    }
    var moreBtnOnClickClosure:((dataModel: TagModel) -> Void)?
    func setMoreBtnOnClickClosure(closure: ((dataModel: TagModel) -> Void)?) {
        moreBtnOnClickClosure = closure
    }
    var dataModel: TagModel = TagModel() {
        didSet {
            typeLabel.text = dataModel.tag_name
            imageView.kf_setImageWithURL(NSURL(string: dataModel.icon_url)!, placeholderImage: nil) {[weak self] (image, error, cacheType, imageURL) in
                guard let `self` = self where image != nil else { return }
                self.imageView.zj_setCircleImage(image, radius: 20.0)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
}
