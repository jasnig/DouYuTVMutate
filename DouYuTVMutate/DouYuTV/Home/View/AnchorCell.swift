//
//  AnchorCell.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
import Kingfisher
class AnchorCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
//            imageView.layer.cornerRadius = 20
//            imageView.layer.masksToBounds = true
            
            
        }
    }
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    
    
    func configCell(model: RoomModel?) {
        // 加载数据
        // 设置默认图片
        imageView.zj_setCircleImage(UIImage(named: "2"), radius: 20.0)
        
        if let data = model {
            
            KingfisherManager.sharedManager.retrieveImageWithURL(NSURL(string: data.room_src)!, optionsInfo: nil, progressBlock: nil) {[weak self] (image, error, cacheType, imageURL) in
                guard let validSelf = self where image != nil else {
                    return
                }
                validSelf.imageView.zj_setCircleImage(image, radius: 20.0)
                
                
            }
            
            var onlineString = String(data.online)
            if data.online > 10000 {
                // 1位小数
                onlineString = String(format: "%.1f万", Double(data.online)/10000.0)
            }
            
            nameLable.text = data.nickname
            onlineLabel.text = onlineString
            roomNameLabel.text = data.room_name
            
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.whiteColor()
    }

}
