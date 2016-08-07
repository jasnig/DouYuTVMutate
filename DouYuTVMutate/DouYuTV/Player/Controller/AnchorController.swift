//
//  AnchorController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/14.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
class AnchorController: UIViewController {
    ///
    var dataModel: RoomModel! {
        didSet {
            if dataModel != nil {
                anchorView.dataModel = dataModel;

            }
        }
    }
    
    lazy var anchorView: AnchorView = {
        let anchorView = AnchorView.loadAnchorViewFromNib()
        return anchorView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(anchorView)
        anchorView.snp_makeConstraints { (make) in
            make.leading.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.trailing.equalTo(view)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
