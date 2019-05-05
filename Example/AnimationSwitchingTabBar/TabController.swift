//
//  TabController.swift
//  AnimationSwitchingTabBar_Example
//
//  Created by 辻林大揮 on 2019/04/21.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import AnimationSwitchingTabBar

final class TabController: AnimationSwitchingTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let screen1 = storyboard.instantiateViewController(withIdentifier: "Screen1") as! AnimationSwitchingViewController
        let screen2 = storyboard.instantiateViewController(withIdentifier: "Screen2") as! AnimationSwitchingViewController
        let screen3 = storyboard.instantiateViewController(withIdentifier: "Screen3") as! AnimationSwitchingViewController
        let screen4 = storyboard.instantiateViewController(withIdentifier: "Screen4") as! AnimationSwitchingViewController
        let screen5 = storyboard.instantiateViewController(withIdentifier: "Screen5") as! AnimationSwitchingViewController
        screen4.setItem(selectedItem: AnimationSwitchingTabBarLottieItem())
        screen5.setItem(item: AnimationSwitchingTabBarLabelItem(), selectedItem: AnimationSwitchingTabBarLabelItem())
        setViewControllers([screen1, screen2, screen3, screen4, screen5])
    }
}
