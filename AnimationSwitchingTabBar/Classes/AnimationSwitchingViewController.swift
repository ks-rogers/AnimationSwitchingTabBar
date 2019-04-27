//
//  AnimationSwitchingViewController.swift
//  AnimationSwitchingTabBar
//
//  Created by 辻林大揮 on 2019/04/27.
//

import UIKit

open class AnimationSwitchingViewController: UIViewController {
    
    @IBInspectable private(set) var iconImage: UIImage?
    
    func setIcon(image: UIImage) {
        self.iconImage = image
    }
}
