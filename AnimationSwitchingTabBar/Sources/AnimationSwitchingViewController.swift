//
//  AnimationSwitchingViewController.swift
//  AnimationSwitchingTabBar
//
//  Created by 辻林大揮 on 2019/04/27.
//

import UIKit

/// A child view controller in a tab bar controller.
open class AnimationSwitchingViewController: UIViewController {
    
    @IBInspectable private(set) var iconImage: UIImage?
    
    var customItem: AnimationSwitchingTabBarItem?
    var selectedCustomItem: AnimationSwitchingTabBarItem?

    /// Sets the icon image in the child view controller.
    open func setIcon(image: UIImage) {
        self.iconImage = image
    }

    /// Sets the custom icon in the child view controller.
    open func setItem(item: AnimationSwitchingTabBarItem? = nil, selectedItem: AnimationSwitchingTabBarItem? = nil) {
        customItem = item
        selectedCustomItem = selectedItem
    }
}
