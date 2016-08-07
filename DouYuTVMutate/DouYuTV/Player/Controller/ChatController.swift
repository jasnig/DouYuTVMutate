//
//  ChatController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/14.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class ChatController: BaseViewController {
    
    struct ConstantValue {
        static let chatInputViewHeight: CGFloat = 44.0
    }
    lazy var chatInputView: ChatInputView = {
        let chatInputView = ChatInputView.loadChatInputViewFromNib()
        chatInputView.backgroundColor = UIColor.whiteColor()
        return chatInputView
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "弹幕....XXXX"
        label.textAlignment = .Center
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)

        view.addSubview(chatInputView)

    }
    
    // 首先要添加到superview上才能添加约束
    override func addConstraints() {
        chatInputView.snp_makeConstraints(closure: { (make) in
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(ConstantValue.chatInputViewHeight)
        })
        label.snp_makeConstraints { (make) in
            make.leading.equalTo(view)
            make.top.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(chatInputView.snp_top)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
