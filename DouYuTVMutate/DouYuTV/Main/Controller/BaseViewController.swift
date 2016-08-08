//
//  MainViewController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/18.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    /// 用于RxSwift
    var disposeBag = DisposeBag()
    /// 标记是否更新了布局
    private var didUpdateConstraints = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()

    }
    
    /// 重写方法
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            addConstraints()
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    /// 子类重写, 用于添加自动布局
    func addConstraints() {
        /// default do nothing
    }
}
