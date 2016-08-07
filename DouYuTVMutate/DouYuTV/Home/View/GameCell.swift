//
//  GameCell.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
import Kingfisher

class GameCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var segLineView: UIView!
    
    
    func confinCell<Model>(model: Model) {
        
        if let detailModel = model as? DetailColumnModel {
            segLineView.hidden = false
            nameLabel.text = detailModel.tag_name
            
            KingfisherManager.sharedManager.retrieveImageWithURL(NSURL(string: detailModel.icon_url)!, optionsInfo: nil, progressBlock: nil) {[weak self] (image, error, cacheType, imageURL) in
                guard let `self` = self where image != nil else {
                    return
                }
                
                self.imageView.zj_setCircleImage(image)
                
            }
        }
        else if let tagDataModel = model as? TagModel {
            imageView.zj_setCircleImage(UIImage(named: "1"))
            segLineView.hidden = true
            nameLabel.text = tagDataModel.tag_name
            
            KingfisherManager.sharedManager.retrieveImageWithURL(NSURL(string: tagDataModel.icon_url)!, optionsInfo: nil, progressBlock: nil) {[weak self] (image, error, cacheType, imageURL) in
                guard let `self` = self where image != nil else {
                    return
                }
                
                self.imageView.zj_setCircleImage(image)
                
            }

        }
        else { return }
        

    }

    
    /**
     * 设置的frame为: imageView.width == imageView.height == nameLabel.width
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.whiteColor()
        nameLabel.adjustsFontSizeToFitWidth = true
    }

}
