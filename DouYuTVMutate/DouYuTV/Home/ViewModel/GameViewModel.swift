//
//  GameViewModel.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/8/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class GameViewModel: BaseViewModel {
    var data = [DetailColumnModel]()
  
    func loadDataWithHandler(handler: (loadState: LoadState) -> Void) {
        let parameters:[String : AnyObject] = ["shortName": "game", "time": String.getNowTimeString()]
        NetworkTool.GET(URL.getColumnDetailURL, parameters: parameters, successHandler: {[weak self] (result) in
            if let resultJSON = result {
                if let resultModel = Mapper<DetailColumnModel>().map(resultJSON) {
                    guard let `self` = self else { return }
                    self.data = resultModel.data
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
