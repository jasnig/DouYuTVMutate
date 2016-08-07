//
//  TitleWithLeftImageAndDetailCell.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/19.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class TitleWithLeftImageAndDetailCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius = 10
        iconView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    typealias DataModel = TypedCellDataModel
    
    // 可以添加一个type参数来区分点击的是cell还是控件
    typealias CellOnClickAction = () -> Void
    //    typealias CellOnClickAction = (cell: TitleWithSwitchCell, switchS: UISwitch) -> Void
    
    
    func updateCellWithData(data: DataModel, action: CellOnClickAction?) {
        titleLabel.text = data.name
        detailLabel.text = data.detailValue
        if let iconName = data.iconName {
            iconView.image = UIImage(named: iconName)
            
        }
    }
    
    func cellDidClickAction(action: CellOnClickAction?) {
        action?()
    }
    
}
extension TitleWithLeftImageAndDetailCell: CellProtocol {

    
}