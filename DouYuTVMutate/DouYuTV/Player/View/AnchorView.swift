//
//  AnchorView.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/17.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
import Kingfisher

/// 设置文字居上
class UPSetLabel: UILabel {
    
    /// 设置文字居上
    var isTextAlignmentTop = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
        if isTextAlignmentTop {
            rect.origin.y = bounds.origin.y

        }
        return rect
    }
    
    
    override func drawTextInRect(rect: CGRect) {
        let actualRect = textRectForBounds(rect, limitedToNumberOfLines: numberOfLines)
        super.drawTextInRect(actualRect)
    }
    
}

class AnchorView: UIView {

    var dataModel: RoomModel = RoomModel() {
        didSet {
            KingfisherManager.sharedManager.retrieveImageWithURL(NSURL(string: dataModel.owner_avatar)!, optionsInfo: nil, progressBlock: nil) {[weak self] (image, error, cacheType, imageURL) in
                
                if let validSelf = self where image != nil {
                    validSelf.headImageView.zj_setCircleImage(image)

                }
            }
            
            roomNameLabel.text = dataModel.room_name
            anchorNameLabel.text = dataModel.nickname
            weightLabel.text = dataModel.owner_weight
            typeLabel.text = dataModel.game_name
            noticeLabel.text = dataModel.show_details
        }
    }
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var anchorNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var noticeLabel: UPSetLabel! {
        didSet {
            noticeLabel.isTextAlignmentTop = true
            noticeLabel.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /// 设置默认图片
        headImageView.zj_setCircleImage(UIImage(named: "2"))

        
    }

    
    class func loadAnchorViewFromNib() -> AnchorView {
        return NSBundle.mainBundle().loadNibNamed(String(self), owner: nil, options: nil).first as! AnchorView
    }
    
    
}
