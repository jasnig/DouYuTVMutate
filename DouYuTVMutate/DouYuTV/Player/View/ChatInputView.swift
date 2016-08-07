//
//  ChatInputView.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/15.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class ChatInputView: UIView {

    static func loadChatInputViewFromNib() -> ChatInputView {
        return NSBundle.mainBundle().loadNibNamed(String(ChatInputView), owner: nil, options: nil).first as! ChatInputView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("nib...")
    }
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBAction func sendGiftBtnOnClick(sender: UIButton) {
        
    }
    
    @IBAction func rechargeBtnOnClick(sender: UIButton) {
        
    }
    
    @IBAction func emojiBtnOnClick(sender: UIButton) {
        
    }

}
