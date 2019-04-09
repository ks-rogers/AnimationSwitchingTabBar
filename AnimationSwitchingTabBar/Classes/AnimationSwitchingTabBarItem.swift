//
//  AnimationSwitchingTab.swift
//  AnimationSwitchingTabBar
//
//  Created by chocovayashi on 2019/04/09.
//

import UIKit

open class AnimationSwitchingTabBarItem: UITabBarItem {
    
    open override var isEnabled: Bool {
        didSet {
            iconImageView?.alpha = isEnabled == true ? 1 : 0.5
        }
    }
    
    open var iconImageView: UIImageView?
}
