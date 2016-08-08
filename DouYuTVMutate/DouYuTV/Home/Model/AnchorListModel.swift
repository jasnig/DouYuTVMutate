//
//  AnchorListModel.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/15.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
import ObjectMapper
class RoomModel: Mappable {
    /// 房间号
    var room_id: String = ""
    /// 房间名
    var room_name: String = ""
    /// 房间图片url
    var room_src: String = ""
    var cate_id: String = ""
    var url: String = ""
    var game_url: String = ""
    /// 是否是竖屏播放直播 1 -> true
    var isVertical: Int = 0
    /// 在线数
    var online: Int = 0
    /// 主播名字
    var nickname: String = ""
    /// 所属分类
    var game_name: String = ""
    var game_icon_url: String = ""
    /// 头像
    var owner_avatar: String = ""
    /// 主播地址
    var anchor_city: String = ""
    /// 粉丝
    var fans: String = ""
    var owner_weight: String = ""
    /// 直播地址
    var hls_url: String = ""
    /// 直播公告
    var show_details: String = ""
    var data: [RoomModel] = []
    required init?(_ map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        room_id <- map["room_id"]
        room_name <- map["room_name"]
        room_src <- map["room_src"]
        cate_id <- map["cate_id"]
        url <- map["url"]
        game_url <- map["game_url"]
        isVertical <- map["isVertical"]
        online <- map["online"]
        nickname <- map["nickname"]
        game_name <- map["game_name"]
        game_icon_url <- map["game_icon_url"]
        owner_avatar <- map["owner_avatar"]
        anchor_city <- map["anchor_city"]
        fans <- map["fans"]
        owner_weight <- map["owner_weight"]
        hls_url <- map["hls_url"]
        show_details <- map["show_details"]
        data <- map["data"]
    }

}

class TagModel: Mappable {
    /// 标签名字
    var tag_name: String = ""
    /// 这个用于服务器类型是String
    var tagIdString: String = ""
    /// 这个用于服务器类型是Int
    var tagIdInt: Int = 0
    /// 图片地址
    var icon_url: String = ""
    /// 房间列表
    var room_list: [RoomModel] = []
    var data: [TagModel] = []
    required init?(_ map: Map) {
        
    }
    init() {
        
    }
    
    func mapping(map: Map) {
        tag_name <- map["tag_name"]
        tagIdInt <- map["tag_id"]
        tagIdString <- map["tag_id"]
        icon_url <- map["icon_url"]
        room_list <- map["room_list"]
        data <- map["data"]
        
    }

}

class ScrollPhotoModel: Mappable {
    var id: Int = 0
    var title: String = ""
    var pic_url: String = ""
    var tv_pic_url: String = ""

    var room: RoomModel = RoomModel()
    var data: [ScrollPhotoModel] = []
    required init?(_ map: Map) {
        
    }
    
    
    init() {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        pic_url <- map["pic_url"]
        tv_pic_url <- map["tv_pic_url"]
        room <- map["room"]
        data <- map["data"]
        
    }
    
}

class ColumnModel: Mappable {
    /// 频道名字
    var cate_name: String = ""
    /// 频道简称
    var short_name: String = ""
    var cate_id: String = ""

    var data: [ColumnModel] = []
    required init?(_ map: Map) {
        
    }
    
    
    init() {
        
    }
    func mapping(map: Map) {
        cate_name <- map["cate_name"]
        short_name <- map["short_name"]
        cate_id <- map["cate_id"]

        data <- map["data"]
        
    }
    
}

class DetailColumnModel: Mappable {
    /// 频道名字
    var icon_url: String = ""
    /// 频道简称
    var pic_url: String = ""
    var short_name: String = ""
    var tag_id: String = ""
    var tag_name: String = ""
    var data: [DetailColumnModel] = []
    var cate_id: String = ""

    required init?(_ map: Map) {
        
    }
    
    init() {
        
    }
    func mapping(map: Map) {
        icon_url <- map["icon_url"]
        pic_url <- map["pic_url"]
        short_name <- map["short_name"]
        tag_id <- map["tag_id"]
        tag_name <- map["tag_name"]
        data <- map["data"]
        cate_id <- map["cate_id"]

    }
    
}