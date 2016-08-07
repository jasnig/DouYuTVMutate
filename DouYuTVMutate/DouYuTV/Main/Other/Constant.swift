//
//  Constant.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
import ObjectMapper
import SnapKit

import RxCocoa
import RxSwift
/// 不用每个文件引入
typealias Driver = RxCocoa.Driver
typealias PublishSubject = RxSwift.PublishSubject
typealias Variable = RxSwift.Variable
typealias DisposeBag = RxSwift.DisposeBag

typealias Mapper = ObjectMapper.Mapper

struct URL {
    static let mainURL = "http://capi.douyucdn.cn/api/v1/gift_effects?aid=ios&client_sys=ios&auth=6e401ee0686a9623462a1c03bf336e0c&time="
    /// 轮播
    static let slideURL = "http://capi.douyucdn.cn/api/v1/slide/6?aid=ios&client_sys=ios&version=2.271&auth=bf1769c9b20a2776078c8c8c749db1d0&time="
    static let hotMostUrl = "http://capi.douyucdn.cn/api/v1/getbigDataRoom?aid=ios&client_sys=ios&auth=b2f3d56904f4341ea3520211c866af3f&time="
    /// 直播栏目列表 参数 ["offset": xx, "time": "xx", "limit": "xx"]
    static let liveURL = "http://capi.douyucdn.cn/api/v1/live/"
    static let loginURL = "http://www.douyutv.com/loginreq/"
    static let recommondURL = "http://capi.douyucdn.cn/api/v1/getHotCate?aid=ios&client_sys=ios&auth=8a584e30f64b7430d8df5f3870f82064&time="
    static let getColumnURL = "http://capi.douyucdn.cn/api/v1/getColumnList"
    static let getColumnDetailURL = "http://capi.douyucdn.cn/api/v1/getColumnDetail?"
    static let getColumnRoomURL = "http://capi.douyucdn.cn/api/v1/getColumnRoom/"
    static let getHotRoom = "http://capi.douyucdn.cn/api/v1/getHotRoom/2?aid=ios&client_sys=ios&time="
    // 竖屏播放的直播
    static let verticalRoomURL = "http://capi.douyucdn.cn/api/v1/getVerticalRoom?aid=ios&client_sys=ios&limit=4&offset=0&auth=c267b5f2a46ca11dbb8969ab3699eaf9&time="
}

struct Constant {
    static let screenWidth = UIScreen.mainScreen().bounds.width
    static let screenHeight = UIScreen.mainScreen().bounds.height
}
