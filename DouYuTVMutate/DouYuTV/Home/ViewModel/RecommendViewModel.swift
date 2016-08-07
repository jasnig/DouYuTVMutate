//
//  RecommendViewModel.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/8/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
import RxSwift
class RecommendViewModel: BaseViewModel {
    /// 是否加载完毕
    private(set) var isLoadFinished: Observable<Bool>
    var isBeginLoad: Variable<Bool> = Variable(false)
    var pptData: [ScrollPhotoModel] {
        return pptDataVariable.value ?? []
    }
    var data: [TagModel] {
        return dataVariable.value ?? []
    }
    
    private var pptDataVariable: Variable<([ScrollPhotoModel]?)> = Variable(nil)
    private var dataVariable: Variable<[TagModel]?> = Variable(nil)
    
    override init() {
        /// 两次请求都完成才标识结束
        isLoadFinished = Observable.combineLatest(pptDataVariable.asObservable(), dataVariable.asObservable()) {ppt, data in
            return ppt != nil && data != nil
        }
 
        super.init()
        
        isBeginLoad.asObservable().subscribeNext { (begin) in
            if begin {
                self.loadData()
                self.loadScrollPhotoData()
            }
        }
        .addDisposableTo(disposeBag)
    }
    
    func loadData() {
        let url: String = URL.recommondURL + String.getNowTimeString()
        
        NetworkTool.GET(url, successHandler: {[weak self] (result) in
            
            if let resultJSON = result {
                
                if let data = Mapper<TagModel>().map(resultJSON)?.data {
                    guard let `self` = self else { return }

                    self.dataVariable.value = data
                    
                }
                
            }
        }) { (error) in
            
        }
        
    }
    
    func loadScrollPhotoData() {
        let url: String = URL.slideURL + String.getNowTimeString()
        
        NetworkTool.GET(url, successHandler: {[weak self] (result) in
            if let resultJSON = result {
                if let data = Mapper<ScrollPhotoModel>().map(resultJSON)?.data {
                    guard let `self` = self else { return }
                    
                    self.pptDataVariable.value = data
                }
            }
        }) { (error) in
            
        }
        
        
    }
    
}

class RecommendViewModel1: BaseViewModel {
    /// 是否加载完毕

    var pptData: [ScrollPhotoModel] = []
    var data: [TagModel] = []

    typealias Handler = (loadState: LoadState) -> Void
    
    func loadDataWithHandler(handler: Handler) {
        let url: String = URL.recommondURL + String.getNowTimeString()
        
        NetworkTool.GET(url, successHandler: {[weak self] (result) in
            
            if let resultJSON = result {
                
                if let data = Mapper<TagModel>().map(resultJSON)?.data {
                    guard let `self` = self else { return }
                    self.data = data
                    /// 加载pptData
                    self.loadPPTViewDataWithHandler(handler)
                    
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
    
    private func loadPPTViewDataWithHandler(handler: Handler) {
        let url: String = URL.slideURL + String.getNowTimeString()
        
        NetworkTool.GET(url, successHandler: {[weak self] (result) in
            if let resultJSON = result {
                if let data = Mapper<ScrollPhotoModel>().map(resultJSON)?.data {
                    guard let `self` = self else { return }
                    
                    self.pptData = data
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