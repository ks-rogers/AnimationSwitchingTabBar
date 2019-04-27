//
//  AnimationSwitchingViewController.swift
//  AnimationSwitchingTabBar
//
//  Created by 辻林大揮 on 2019/04/27.
//

import UIKit

open class AnimationSwitchingViewController: UIViewController {
    
    @IBInspectable private(set) var iconImage: UIImage?
    
    var customItem: AnimationSwitchingTabBarItem?
    
    open func setIcon(image: UIImage) {
        self.iconImage = image
    }
    
    open func setCustomItem(item: AnimationSwitchingTabBarItem) {
        customItem = item
    }
}
