//
//  PlayerController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/14.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
//import IJKMediaFramework
class PlayerController: UIViewController {
    
    struct ConstantValue {
        static let playViewHeight = CGFloat(300.0)
        static let segmentViewHeight = CGFloat(44.0)
        static let careBtnWidth = CGFloat(100.0)
        static let contentViewHeight = Constant.screenHeight - ConstantValue.playViewHeight - ConstantValue.segmentViewHeight
    }
    
    lazy var childVcs: [UIViewController] = {
        let anchorVc = AnchorController()
        let chatVc = ChatController()
        let giftContributeVc = GiftContributeController()
        return [anchorVc, chatVc, giftContributeVc]
    }()
    
    lazy var playView: UIView = {
       let playView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Constant.screenWidth, height: ConstantValue.playViewHeight))
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        playView.addGestureRecognizer(tapGes)
        playView.backgroundColor = UIColor.redColor()
        return playView
    }()
    
    lazy var segmentTitleView: ScrollSegmentView = {
        
        let titles = ["主播", "聊天", "贡献榜"]
        var style = SegmentStyle()
        style.showLine = true
        style.normalTitleColor = UIColor(red: 105.0/255.0, green: 106.0/255.0, blue: 107.0/255.0, alpha: 1)
        style.selectedTitleColor = UIColor(red: 248.0/255.0, green: 122.0/255.0, blue: 8.0/255.0, alpha: 1)
        style.scrollLineColor = UIColor(red: 248.0/255.0, green: 122.0/255.0, blue: 8.0/255.0, alpha: 1)
        style.gradualChangeTitleColor = true
        style.scrollTitle = false
        style.extraBtnWidth = ConstantValue.careBtnWidth
        style.showExtraButton = true
        let segmentTitleView = ScrollSegmentView(frame: CGRect(x: 0, y: self.playView.frame.maxY, width: Constant.screenWidth, height: ConstantValue.segmentViewHeight), segmentStyle: style, titles: titles)
        // weak self
        segmentTitleView.titleBtnOnClick = {[unowned self](label: UILabel, index: Int) -> Void in
            self.contentView.setContentOffSet(CGPoint(x: self.contentView.bounds.width * CGFloat(index), y: 0) , animated: true)
            
        }
        // 设置附加按钮
        segmentTitleView.extraButton?.titleLabel?.font = UIFont.systemFontOfSize(12.0)
        segmentTitleView.extraButton?.setTitle("关注", forState: .Normal)
        segmentTitleView.extraButton?.setTitleColor(UIColor.redColor(), forState: .Normal)

        return segmentTitleView
    }()
    
    lazy var contentView: ContentView = {
        let contentView = ContentView(frame: CGRect(x: 0, y: self.segmentView.frame.maxY, width: Constant.screenWidth, height: ConstantValue.contentViewHeight), childVcs: self.childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
//    var player: IJKMediaPlayback!
    /// 使用!达到依赖注入的效果
    var roomID: String!
    
    var dataModel: RoomModel = RoomModel() {
        didSet {

            segmentTitleView.extraButton?.setTitle("关注\(dataModel.fans)", forState: .Normal)
            
            setupChildVcData()
            setupPlayer()
        }
    }
    
    func setupChildVcData() {
        
        childVcs.forEach { (childVc) in
            if childVc is AnchorController {
                let anchorVc = childVc as! AnchorController
                anchorVc.dataModel = dataModel
            }
        }
        
    }
    
    func setupPlayer() {
        
//        if player != nil {
//            removePlayer()
//        } else {
//            addPlayer()
//        }
    }
    
    func removePlayer() {
//        removeObserver()
//        if player != nil {
//            player.shutdown()
//            player.view.removeFromSuperview()
//            player = nil
//        }
   
    }
    
    func addPlayer() {
//        let option = IJKFFOptions.optionsByDefault()
//        option.setPlayerOptionIntValue(30, forKey: "r")
//        option.setPlayerOptionIntValue(512, forKey: "vol")
//        option.setPlayerOptionIntValue(1, forKey: "videotoolbox")
//        player = IJKFFMoviePlayerController(contentURLString: dataModel.hls_url, withOptions: option)
//        player.scalingMode = .AspectFill
//        
//        player.prepareToPlay()
//        player.view.frame = playView.bounds
//        playView.addSubview(player.view)
//
//        addObserver()
    }
    
    func handleTap(tap: UITapGestureRecognizer) {
        if let navi = self.navigationController {
            navi.navigationBarHidden = !navi.navigationBarHidden
        }
    }
    
    func loadRoomData() {
        
        
        //"room/"+roomid+"?aid=android&clientsys=android&time="+1231
        let nowTime = String.getNowTimeString()
        let auth = "room/"+roomID+"?aid=android&client_sys=android&time=" + nowTime + "1231"
        let authMD5 = auth.zj_MD5
        // <room_id>?aid=android&client_sys=android&time=<time>
        let roomURL = "http://capi.douyucdn.cn/api/v1/room/\(roomID)?ne=1&support_pwd=1"
        let param = ["aid": "android", "client_sys": "android", "auth": authMD5, "time": nowTime]
        NetworkTool.GET(roomURL, parameters: param, successHandler: {[weak self] (result) in
            if let resultJSON = result?.valueForKey("data") {
                                    print(resultJSON)
                if let data = Mapper<RoomModel>().map(resultJSON) {
                    self?.dataModel = data
                }
            }
            }) { (error) in
        
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(playView)
        view.addSubview(segmentTitleView)
        view.addSubview(contentView)
        
        // 请求房间信息
        loadRoomData()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBarHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit {
        removePlayer()
        print("play -- 销毁")
    }

}

// MARK:- NSNotification--------通知处理
extension PlayerController {
    
    func removeObserver() {
//        let notiCenter = NSNotificationCenter.defaultCenter()
//        notiCenter.removeObserver(self, name: IJKMPMoviePlayerLoadStateDidChangeNotification, object: player)
//        notiCenter.removeObserver(self, name: IJKMPMoviePlayerPlaybackStateDidChangeNotification, object: player)
//        notiCenter.removeObserver(self, name: IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification, object: player)
//        notiCenter.removeObserver(self, name: IJKMPMoviePlayerPlaybackDidFinishNotification, object: player)
//        
    }
    
    func addObserver() {
//        let notiCenter = NSNotificationCenter.defaultCenter()
//        notiCenter.addObserver(self, selector: #selector(self.playbackStateDidChange(_:)), name: IJKMPMoviePlayerPlaybackStateDidChangeNotification, object: player)
//        notiCenter.addObserver(self, selector: #selector(self.loadStateDidChange(_:)), name: IJKMPMoviePlayerLoadStateDidChangeNotification, object: player)
//        notiCenter.addObserver(self, selector: #selector(self.playbackIsPreparedToPlayDidChange(_:)), name: IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification, object: player)
//        
//        notiCenter.addObserver(self, selector: #selector(self.playbackDidFinish(_:)), name: IJKMPMoviePlayerPlaybackDidFinishNotification, object: player)
    }
    
    /// 播放状态改变
    func playbackStateDidChange(noti: NSNotification) {
//        switch player.playbackState {
//        case .Interrupted:
//            break
//        case .Paused:
//            break
//        case .Playing:
//            break
//        case .SeekingBackward:
//            break
//        case .SeekingForward:
//            break
//        case .Stopped:
//            break
//        }
    }
    /// 加载状态
    func loadStateDidChange(noti: NSNotification) {
//        let state = player.loadState
//        if state.contains(.Playable) {// 可播放
//            print("加载成功")
//        } else if state.contains(.Stalled) {// 会自动暂停
//            print("加载失败")
//            
//        } else if state.contains(.PlaythroughOK) {// 会自动播放
//            print("播放成功")
//            
//        }
    }
    /// 准备播放
    func playbackIsPreparedToPlayDidChange(noti: NSNotification) {
        
    }
    /// 播放完成
    func playbackDidFinish(noti: NSNotification) {
        
    }
}

extension PlayerController: ContentViewDelegate {
    var segmentView: ScrollSegmentView {
        return segmentTitleView
    }

}
