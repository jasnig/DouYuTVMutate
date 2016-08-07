//
//  TitleWithDetailValueCell.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/19.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class TitleWithDetailValueCell: UITableViewCell {

    @IBOutlet weak var detailValueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension TitleWithDetailValueCell: CellProtocol {
    typealias DataModel = TypedCellDataModel
    typealias CellOnClickAction = () -> Void
    
    
    func updateCellWithData(data: DataModel, action: CellOnClickAction?) {
        titleLabel.text = data.name
        detailValueLabel.text = data.detailValue
    }
    
    func cellDidClickAction(action: CellOnClickAction?) {
        action?()
        //        print("haoha")
    }
    
}