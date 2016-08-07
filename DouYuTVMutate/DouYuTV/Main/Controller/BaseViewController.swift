//
//  MainViewController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/18.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    private var didUpdateConstraints = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()

    }
    
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            addConstraints()
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func addConstraints() {
        
    }
}
