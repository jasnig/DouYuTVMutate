//
//  EntertainmentViewModel.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/8/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class EntertainmentViewModel: BaseViewModel {
    
    var data: [TagModel] = []

    func loadDataWithHandler(handler: (loadState: LoadState) -> ()) {
        let url = URL.getHotRoom + String.getNowTimeString()
        
        NetworkTool.GET(url, successHandler: {[weak self] (result) in
            
            if let resultJSON = result {
                
                if let data = Mapper<TagModel>().map(resultJSON)?.data {
                    self?.data = data
                    handler(loadState: .success)
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
