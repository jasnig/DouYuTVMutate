//
//  MainNavigationController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/14.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 开启全屏pop手势
        zj_enableFullScreenPop(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // 拦截 统一处理
    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        vc.hidesBottomBarWhenPushed = true
        super.showViewController(vc, sender: sender)
    }


}
