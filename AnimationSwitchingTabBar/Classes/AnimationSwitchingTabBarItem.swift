//
//  AnimationSwitchingTab.swift
//  AnimationSwitchingTabBar
//
//  Created by chocovayashi on 2019/04/09.
//

import UIKit

open class AnimationSwitchingTabBarItem: UITabBarItem {
    
    open var iconImageView: UIImageView? {
        didSet {
            iconImageView?.alpha = 0.5
        }
    }
}
