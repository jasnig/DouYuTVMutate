//
//  CellGurator.swift
//  TypeTableView
//
//  Created by jasnig on 16/3/25.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles/

import UIKit

// sectionData
class CommonTableSectionData {
    let headerTitle: String?
    let footerTitle: String?
    let headerHeight: Int?
    let footerHeight: Int?
    var rows: [CellConfiguratorType] = []
    
    init(headerTitle: String?, footerTitle: String?, headerHeight: Int? ,footerHeight : Int?, rows: [CellConfiguratorType]) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
        self.rows = rows
    }
}

// configurated cellMessage (Generic)
protocol CellConfiguratorType {
    var reusedIndentifier: String { get }
    var cellClass: AnyClass { get }
    var canSelected: Bool { get }
    var cellHeight: Int { get }
    func updateCell(cell: UITableViewCell)
    func cellOnClickAction(cell: UITableViewCell)
}

// cellBuilder -- to create every cell
struct CellBuilder<Cell where Cell: CellProtocol, Cell: UITableViewCell> {
    
    let dataModel: Cell.DataModel
    let cellDidClickAction: Cell.CellOnClickAction?
    
    let reusedIndentifier: String = String(Cell)
    let cellClass: AnyClass = Cell.self
    /// default is true
    var canSelected: Bool
    /// default is 44
    var cellHeight: Int
    
    init(dataModel: Cell.DataModel, canSelected: Bool = true , cellHeight: Int = 44, cellDidClickAction : Cell.CellOnClickAction?) {
        self.dataModel = dataModel
        self.cellDidClickAction = cellDidClickAction
        self.canSelected = canSelected
        self.cellHeight = cellHeight
    }
}

extension CellBuilder: CellConfiguratorType {
    func updateCell(cell: UITableViewCell) {
        if let cell = cell as? Cell {
            cell.updateCellWithData(dataModel, action: cellDidClickAction)
        }
    }
    func cellOnClickAction(cell: UITableViewCell) {
        if let cell = cell as? Cell {
            cell.cellDidClickAction(cellDidClickAction)
        }
    }
}

