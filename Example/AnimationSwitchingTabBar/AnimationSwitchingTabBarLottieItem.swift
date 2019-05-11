//
//  AnimationSwitchingTabBarLottieItem.swift
//  AnimationSwitchingTabBar_Example
//
//  Created by 辻林大揮 on 2019/05/05.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import AnimationSwitchingTabBar
import Lottie

final class AnimationSwitchingTabBarLottieItem: AnimationSwitchingTabBarItem {
    
    private let animationView: AnimationView
    
    public override init(frame: CGRect) {
        animationView = AnimationView(name: "Notification")
        super.init(frame: frame)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(animationView)
    }
    
    override func animate() {
        animationView.play()
    }
    
    override func setNotSelectedItem() {
        let itemSize = CGSize(width: 30, height: 30)
        animationView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
    }
    
    override func setSelectedItem() {
        let itemSize = CGSize(width: 250, height: 250)
        animationView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

