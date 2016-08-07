//
//  DetailColumnController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/18.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
class DetailColumnController: UIViewController {
    var titles:[String] = []
    var childVcs: [UIViewController] = []
    var dataModel: ColumnModel = ColumnModel()

    lazy var scrollPageView: ScrollPageView = {
        var style = SegmentStyle()
        style.showCover = true
        style.normalTitleColor = UIColor(red: 105.0/255.0, green: 106.0/255.0, blue: 107.0/255.0, alpha: 1)
        style.selectedTitleColor = UIColor(red: 248.0/255.0, green: 122.0/255.0, blue: 8.0/255.0, alpha: 1)
        style.scrollLineColor = UIColor(red: 248.0/255.0, green: 122.0/255.0, blue: 8.0/255.0, alpha: 1)
        style.gradualChangeTitleColor = true
        
        let scrollPageView = ScrollPageView(frame: CGRect(x:0.0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), segmentStyle: style, titles: self.titles, childVcs: self.childVcs, parentViewController: self)
        scrollPageView.segmentView.backgroundColor = UIColor.lightTextColor()
        scrollPageView.contentView.collectionView.scrollEnabled = false

        return scrollPageView
    }()
    var detailColumnData: [DetailColumnModel]! {
        didSet {
            if detailColumnData != nil {
                detailColumnData.forEach({ (detailColumnModel) in
                    self.titles.append(detailColumnModel.tag_name)
                    let detailViewModel = DetailColumnListViewModel(tagID: detailColumnModel.tag_id)
                    let childVc = DetailColumnListController(viewModel: detailViewModel)
                    childVc.title = title
                    self.childVcs.append(childVc)
                })
                view.addSubview(scrollPageView)
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        loadData()
    }

    
    func loadData() {
        let parameters:[String : AnyObject] = ["shortName": dataModel.short_name, "time": String.getNowTimeString()]
        NetworkTool.GET(URL.getColumnDetailURL, parameters: parameters, successHandler: { (result) in
            if let resultJSON = result {
                print(resultJSON)
                if let data = Mapper<DetailColumnModel>().map(resultJSON)?.data {
                    
                    self.detailColumnData = data
                }
                
            }
            
        }) { (error) in
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
