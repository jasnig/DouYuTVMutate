//
//  LiveController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/14.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
class LiveColumnController: UIViewController {

    var titles:[String] = []
    var childVcs: [UIViewController] = []
    
    lazy var scrollPageView: ScrollPageView = {
        var style = SegmentStyle()
        style.showLine = true
        style.normalTitleColor = UIColor(red: 105.0/255.0, green: 106.0/255.0, blue: 107.0/255.0, alpha: 1)
        style.selectedTitleColor = UIColor(red: 248.0/255.0, green: 122.0/255.0, blue: 8.0/255.0, alpha: 1)
        style.scrollLineColor = UIColor(red: 248.0/255.0, green: 122.0/255.0, blue: 8.0/255.0, alpha: 1)
        style.gradualChangeTitleColor = true
        
        let scrollPageView = ScrollPageView(frame: CGRect(x:0.0, y: 64.0, width: self.view.bounds.width, height: self.view.bounds.height - 64.0 - 44.0), segmentStyle: style, titles: self.titles, childVcs: self.childVcs, parentViewController: self)
        scrollPageView.segmentView.backgroundColor = UIColor.lightTextColor()
        return scrollPageView
    }()
    
    var data: [ColumnModel]! {
        didSet {
            if data != nil {
                data.forEach({ (columnModel) in
                    self.titles.append(columnModel.cate_name)
                    
                    let childVc = DetailColumnController()
                    childVc.title = title
                    childVc.dataModel = columnModel
                    self.childVcs.append(childVc)
                })
                view.addSubview(scrollPageView)

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        title = "直播"
        NetworkTool.GET(URL.getColumnURL, successHandler: {[unowned self] (result) in
                print(result)
            if let data = Mapper<ColumnModel>().map(result)?.data {
                self.data = data
            }
            
            }) { (error) in
                
        }

    }

}
