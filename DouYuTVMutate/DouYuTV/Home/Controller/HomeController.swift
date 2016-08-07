//
//  HomeController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    lazy var childVcs: [UIViewController] = {
        let recommendVc = RecommendController()
//        recommendVc.view.backgroundColor = UIColor.redColor()
        let gameVc = GameController()
        let entertainmentVc = EntertainmentController()
        let interestingVc = InterestingController()
        return [recommendVc, gameVc, entertainmentVc, interestingVc]
    }()
    
    
    lazy var scrollPageView: ScrollPageView = {
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        var style = SegmentStyle()
        style.showLine = true
        style.normalTitleColor = UIColor(red: 105.0/255.0, green: 106.0/255.0, blue: 107.0/255.0, alpha: 1)
        style.selectedTitleColor = UIColor(red: 248.0/255.0, green: 122.0/255.0, blue: 8.0/255.0, alpha: 1)
        style.scrollLineColor = UIColor(red: 248.0/255.0, green: 122.0/255.0, blue: 8.0/255.0, alpha: 1)
        style.gradualChangeTitleColor = true
        style.scrollTitle = false
        
        
        let scrollPageView = ScrollPageView(frame: CGRect(x:0.0, y: 64.0, width: self.view.bounds.width, height: self.view.bounds.height - 64.0 - 44.0), segmentStyle: style, titles: titles, childVcs: self.childVcs, parentViewController: self)
        scrollPageView.segmentView.backgroundColor = UIColor.lightTextColor()
        return scrollPageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(scrollPageView)
        navigationItem.title = "首页"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
