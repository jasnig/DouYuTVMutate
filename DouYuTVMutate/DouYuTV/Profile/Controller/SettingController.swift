//
//  SettingController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/19.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class SettingController: BaseViewController {
    var delegator: CommonTableViewDelegator!

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)
        
        return tableView
    }()
    var data: [CommonTableSectionData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("appear --------  \(tableView.contentInset)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "设置"
        view.addSubview(tableView)
        
        setupData()
        
        delegator = CommonTableViewDelegator(tableView: tableView, data: {[unowned self] () -> [CommonTableSectionData] in
            return self.data
        })
        tableView.delegate = delegator
        tableView.dataSource = delegator
        


    }

    override func addConstraints() {
        tableView.snp_makeConstraints { (make) in
            make.leading.equalTo(view)
            make.top.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    
    func showHud() {
        EasyHUD.showHUD("未实现相关功能", autoHide: true, afterTime: 1.0)

    }
    
    func setupData() {
        let row1Data = TypedCellDataModel(name: "列表自动加载", isOn: false)
        let row2Data = TypedCellDataModel(name: "播放器手势", isOn: true)
        let row3Data = TypedCellDataModel(name: "清理缓存", detailValue: "44.0M")
        let row4Data = TypedCellDataModel(name: "关于我们")
        let row5Data = TypedCellDataModel(name: "意见反馈")
        let row6Data = TypedCellDataModel(name: "给我们评分")

        let row1 = CellBuilder<TitleWithSwitchCell>(dataModel: row1Data, cellDidClickAction: {[unowned self](switchS: UISwitch) -> Void in
            self.showHud()
        })
        let row2 = CellBuilder<TitleWithSwitchCell>(dataModel: row2Data, cellDidClickAction: {[unowned self](switchS: UISwitch) -> Void in
            self.showHud()
        })
        
        let row3 = CellBuilder<TitleWithDetailValueCell>(dataModel: row3Data, cellDidClickAction: {[unowned self] in
            self.showHud()
        })
        
        let row4 = CellBuilder<TitleOnlyCell>(dataModel: row4Data, cellHeight: 50, cellDidClickAction: {[unowned self] in
            
            self.showHud()
            
        })
        
        let row5 = CellBuilder<TitleOnlyCell>(dataModel: row5Data, cellDidClickAction: {[unowned self] in
            self.showHud()
        })
        
        let row6 = CellBuilder<TitleOnlyCell>(dataModel: row6Data, cellDidClickAction: {[unowned self] in
            self.showHud()
        })
        
        let section1 = CommonTableSectionData(headerTitle: "这是测试数据", footerTitle: "随便写的", headerHeight: 38, footerHeight: 38, rows: [row1,row2,row3,row4,row5,row6])
        data = [section1]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
