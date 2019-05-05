//
//  AnimationSwitchingTabBarLabelItem.swift
//  AnimationSwitchingTabBar_Example
//
//  Created by 辻林大揮 on 2019/05/05.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import AnimationSwitchingTabBar

final class AnimationSwitchingTabBarLabelItem: AnimationSwitchingTabBarItem {
    
    var label: UILabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "A"
        label.textAlignment = .center
        
        addSubview(label)
    }
    
    override func animateWhenHalfMove() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.duration = TimeInterval(0.5)
        label.layer.add(rotateAnimation, forKey: nil)
    }
    
    override func setConstraint() {
        let itemSize = CGSize(width: 30, height: 30)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
    }
    
    override func setSelectedConstraint() {
        let itemSize = CGSize(width: 30, height: 30)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
