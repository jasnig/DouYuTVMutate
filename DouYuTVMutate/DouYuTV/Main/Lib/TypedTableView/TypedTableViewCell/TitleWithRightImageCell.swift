//
//  TitleWithRightImageCell.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/19.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class TitleWithRightImageCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius = 10
        iconView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension TitleWithRightImageCell: CellProtocol {
    typealias DataModel = TypedCellDataModel
    
    // 可以添加一个type参数来区分点击的是cell还是控件
    typealias CellOnClickAction = () -> Void
    //    typealias CellOnClickAction = (cell: TitleWithSwitchCell, switchS: UISwitch) -> Void
    
    
    func updateCellWithData(data: DataModel, action: CellOnClickAction?) {
        titleLabel.text = data.name
        if let iconName = data.iconName {
            iconView.image = UIImage(named: iconName)
            
        }
    }
    
    func cellDidClickAction(action: CellOnClickAction?) {
        action?()
    }
    
}