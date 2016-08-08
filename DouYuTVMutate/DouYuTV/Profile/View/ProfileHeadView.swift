//
//  ProfileHeadView.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/19.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class ProfileHeadView: UIView {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var btnContaierView: UIView!
    @IBOutlet weak var wantLiveBtn: UIButton!
    
    var didTapImageViewHandler: ((imageView: UIImageView) -> Void)? {
        didSet {
            if didTapImageViewHandler != nil {
                headImageView.userInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapedImageView))
                headImageView.addGestureRecognizer(tap)
            }
        }
    }
    
    
    @IBAction func registBtnOnClick(sender: UIButton) {
    }

    @IBAction func loginBtnOnClick(sender: UIButton) {
    }
    
    @IBAction func wantLiveBtnOnClick(sender: UIButton) {
    }
    
    @IBAction func editBtnOnClick(sender: UIButton) {
    }
    
    
    class func LoadProfileHeadViewFormLib() -> ProfileHeadView {
        return NSBundle.mainBundle().loadNibNamed(String(self), owner: nil, options: nil).first as! ProfileHeadView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wantLiveBtn.layer.cornerRadius = wantLiveBtn.bounds.height/2
        wantLiveBtn.layer.masksToBounds = true
        headImageView.zj_setCircleImage(UIImage(named: "2"))
    }
    
    func tapedImageView() {
        didTapImageViewHandler?(imageView: headImageView)
    }
}
