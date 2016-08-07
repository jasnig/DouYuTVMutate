//
//  MainTabBarController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildVcs()
        setTabBarItemColor()
    }
    
    func setTabBarItemColor() {
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()], forState: .Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor()], forState: .Normal)
    }
    
    func setupChildVcs() {
        let homeVc = addChildVc(HomeController(), title: "首页", imageName: "btn_home_normal_24x24_", selectedImageName: "btn_home_selected_24x24_")
        let liveVc = addChildVc(LiveColumnController(), title: "直播", imageName: "btn_column_normal_24x24_", selectedImageName: "btn_column_selected_24x24_")
        let concernVc = addChildVc(ConcernController(), title: "关注", imageName: "btn_live_normal_30x24_", selectedImageName: "btn_live_selected_30x24_")
        let profileVc = addChildVc(ProfileController(), title: "我的", imageName: "btn_user_normal_24x24_", selectedImageName: "btn_user_selected_24x24_")
        viewControllers = [homeVc, liveVc, concernVc, profileVc]

    }
    
    func addChildVc(childVc: UIViewController, title: String, imageName: String, selectedImageName: String) -> UINavigationController {
        let navi = MainNavigationController(rootViewController: childVc)
        
        let image = UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysOriginal)
        let selectedImage = UIImage(named: selectedImageName)?.imageWithRenderingMode(.AlwaysOriginal)

        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        navi.tabBarItem = tabBarItem
        
        return navi
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
