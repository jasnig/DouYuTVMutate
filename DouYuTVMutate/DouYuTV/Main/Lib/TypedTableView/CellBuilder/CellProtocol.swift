//
//  CellProtocol.swift
//  TypeTableView
//
//  Created by jasnig on 16/3/25.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles/

protocol CellProtocol {
    associatedtype DataModel
    associatedtype CellOnClickAction
    
    func updateCellWithData(data: DataModel, action: CellOnClickAction?)
    
    // 点击时响应的方法
    func cellDidClickAction(action: CellOnClickAction?)
    
}