//
//  TitleWithSwitchCell.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/19.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class TitleWithSwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchS: UISwitch!
    var switchOnClickAction: CellOnClickAction?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension TitleWithSwitchCell: CellProtocol {
    typealias DataModel = TypedCellDataModel
    typealias CellOnClickAction = (switchS: UISwitch) -> Void
    //    typealias CellOnClickAction = (cell: TitleWithSwitchCell, switchS: UISwitch) -> Void
    
    
    func updateCellWithData(data: DataModel, action: CellOnClickAction?) {
        titleLabel.text = data.name
        switchS.on = data.isOn
        switchOnClickAction = action
    }
    
    func cellDidClickAction(action: CellOnClickAction?) {
        action?(switchS: self.switchS)
    }
    
}