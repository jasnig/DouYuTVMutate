//
//  TitleCellData.swift
//  TypeTableView
//
//  Created by jasnig on 16/3/29.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles/

import Foundation


struct TypedCellDataModel {
    /// cell的标题
    var name: String
    /// cell右侧的文字
    var detailValue:String?
    /// cell 左边或者右边的图片名字或者URL
    var iconName: String?
    
    /// cell 右侧的开关的状态
    var isOn: Bool
    
    init(name: String, detailValue: String? = nil, iconName: String? = nil, isOn: Bool = true) {
        self.name = name
        self.detailValue = detailValue
        self.iconName = iconName
        self.isOn = isOn
    }
}
