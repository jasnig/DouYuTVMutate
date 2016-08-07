//
//  WelcomeController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/19.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
//import IJKMediaFramework
import MediaPlayer
class WelcomeController: UIViewController {

//    var player: IJKMediaPlayback!
    var mediaPlayer: MPMoviePlayerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let path = NSBundle.mainBundle().pathForResource("movie.mp4", ofType: nil)
//            player = IJKAVMoviePlayerController(contentURL: NSURL.fileURLWithPath(path!))
//            player.view.frame = view.bounds
//            view.addSubview(player.view)
//            player.scalingMode = .AspectFill
//            player.shouldAutoplay = true
//            player.prepareToPlay()
            
            mediaPlayer = MPMoviePlayerController(contentURL: NSURL.fileURLWithPath(path!))
            mediaPlayer.shouldAutoplay = true
            /// 不显示播放进度条
            mediaPlayer.controlStyle = .None
            mediaPlayer.scalingMode = .AspectFill
            mediaPlayer.view.frame = view.bounds
            view.addSubview(mediaPlayer.view)
            mediaPlayer.prepareToPlay()
            
            
        }
        
        do {
            let btn = UIButton(frame: CGRect(x: 0.0, y: Constant.screenHeight - 60, width: 80, height: 44))
            btn.center.x = view.center.x
            btn.setTitle("点击进入", forState: .Normal)
            btn.addTarget(self, action: #selector(self.loginIn), forControlEvents: .TouchUpInside)
            btn.backgroundColor = UIColor.blueColor()
            btn.layer.cornerRadius = 20
            btn.layer.masksToBounds = true
            view.addSubview(btn)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self
            , selector: #selector(self.didPlaybackFinish), name: MPMoviePlayerPlaybackDidFinishNotification, object: mediaPlayer)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if mediaPlayer.playbackState != .Playing {
            mediaPlayer.play()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self
            , name: MPMoviePlayerPlaybackDidFinishNotification, object: mediaPlayer)
        
//        player.shutdown()
//        player = nil
        mediaPlayer.stop()
        mediaPlayer = nil
    }
    
    func didPlaybackFinish() {
        // 重播
        mediaPlayer.play()
    }
    
    func loginIn() {
        let rootVc = MainTabBarController()
        if let window = UIApplication.sharedApplication().keyWindow {
            window.rootViewController = rootVc
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
