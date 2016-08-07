
//
//  ProfileController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/19.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
class ProfileController: BaseViewController {

    var delegator: CommonTableViewDelegator!
    lazy var profileHeadView: ProfileHeadView = ProfileHeadView.LoadProfileHeadViewFormLib()
    var headView = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 360))
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)

        return tableView
    }()
    
    var data: [CommonTableSectionData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人中心"
        view.addSubview(tableView)
        headView.addSubview(profileHeadView)
        tableView.tableHeaderView = headView
        
        setupData()
        
        delegator = CommonTableViewDelegator(tableView: tableView, data: {[unowned self] () -> [CommonTableSectionData] in
            return self.data
        })
        tableView.delegate = delegator
        tableView.dataSource = delegator

        
    }
    
    deinit {
        print("xiaohui--------")
    }
    
    func setupData() {
        let row1Data = TypedCellDataModel(name: "开播提示", iconName: "1")
        let row2Data = TypedCellDataModel(name: "票务查询", iconName: "1")
        let row3Data = TypedCellDataModel(name: "设置选项", iconName: "1")
        let row4Data = TypedCellDataModel(name: "手游中心", iconName: "1", detailValue: "玩游戏领鱼丸")

        let row1 = CellBuilder<TitleWithLeftImageCell>(dataModel: row1Data, cellDidClickAction: {
            SimpleHUD.showHUD("未实现相关功能", autoHide: true, afterTime: 1.0)
        })
        let row2 = CellBuilder<TitleWithLeftImageCell>(dataModel: row2Data, cellDidClickAction: {
            SimpleHUD.showHUD("未实现相关功能", autoHide: true, afterTime: 1.0)
        })

        let row3 = CellBuilder<TitleWithLeftImageCell>(dataModel: row3Data, cellDidClickAction: {[unowned self] in
            
            self.showViewController(SettingController(), sender: nil)

            
        })
        
        let row4 = CellBuilder<TitleWithLeftImageAndDetailCell>(dataModel: row4Data, cellHeight: 50, cellDidClickAction: {[unowned self] in
            
            self.showViewController(TestController(), sender: nil)
            
        })
        
        let section1 = CommonTableSectionData(headerTitle: nil, footerTitle: nil, headerHeight: 10, footerHeight: nil, rows: [row1, row2, row3])
        
        let section2 = CommonTableSectionData(headerTitle: nil, footerTitle: nil, headerHeight: 10, footerHeight: 10, rows: [row4])
        data = [section1, section2]

    }
    
    override func addConstraints() {
        super.addConstraints()
        
        tableView.snp_makeConstraints { (make) in
            make.leading.equalTo(view)
            make.top.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        profileHeadView.snp_makeConstraints { (make) in
            make.leading.equalTo(headView)
            make.top.equalTo(headView)
            make.trailing.equalTo(headView)
            make.bottom.equalTo(headView)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ProfileController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = "ceshi"
        return cell
    }
}
