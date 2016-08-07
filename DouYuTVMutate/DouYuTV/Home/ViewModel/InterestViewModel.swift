//
//  InterestViewModel.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/8/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
enum LoadState {
    case success
    case failure(errorMessage: String)
}

class InterestViewModel: BaseViewModel {

    var data = [RoomModel]()
    private var currentPage = 0
    
    func headerRefreshWithHandler(handler: (loadState: LoadState) -> Void) {
        currentPage = 0
        loadDataWithHandler(handler)
    }
    
    func footerRefreshWithHandler(handler: (loadState: LoadState) -> Void) {
        currentPage += 1
        loadDataWithHandler(handler)
    }
    
    private func loadDataWithHandler(handler: (loadState: LoadState) -> Void) {
        let parameters:[String : AnyObject] = ["offset": 20*currentPage, "limit": 20, "time": String.getNowTimeString()]
        let url = URL.getColumnRoomURL + "3?"
        NetworkTool.GET(url, parameters: parameters, successHandler: {[weak self] (result) in
            if let resultJSON = result {
                //                    print(resultJSON)
                if let data = Mapper<RoomModel>().map(resultJSON)?.data {
                    guard let `self` = self else { return }
                    if self.currentPage == 0 {
                        self.data = data
                    }
                    else {
                        self.data += data
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        handler(loadState: .success)
                    })
                }
                else {
                    handler(loadState: LoadState.failure(errorMessage: "数据解析错误"))
                }
                
            }
            else {
                handler(loadState: .failure(errorMessage: "服务器返回的错误"))
            }
        }) { (error) in
            handler(loadState: .failure(errorMessage: "网络错误"))
            
        }

    }

}
