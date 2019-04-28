//
//  AnimationSwitchingTabBarSelectedView.swift
//  AnimationSwitchingTabBar
//
//  Created by chocovayashi on 2019/04/13.
//

import UIKit

final class AnimationSwitchingTabBarSelectedView: UIView {
    
    var items: [AnimationSwitchingTabBarItem] = []
    
    private(set) var item: AnimationSwitchingTabBarItem?
    let selectedColor: UIColor
    
    init(selectedColor: UIColor) {
        self.selectedColor = selectedColor
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(selectedColor.cgColor)
        
        // Bezier curve
        context.move(to: .zero)
        context.addCurve(to: CGPoint(x: rect.maxX / 2, y: rect.maxY),
                         control1: CGPoint(x: rect.maxX / 4, y: 0),
                         control2: CGPoint(x: rect.maxX / 8, y: rect.maxY))
        context.addCurve(to: CGPoint(x: rect.maxX, y: 0),
                         control1: CGPoint(x: rect.maxX * 7 / 8, y: rect.maxY),
                         control2: CGPoint(x: rect.maxX * 3 / 4, y: 0))
        context.drawPath(using: .fill)
        
        // White Circle
        let whiteCircle = UIView(frame: CGRect(origin: .zero, size: .init(width: 50, height: 50)))
        whiteCircle.layer.position = CGPoint(x: rect.maxX / 2, y: rect.maxY / 2 - 10)
        whiteCircle.backgroundColor = .white
        whiteCircle.layer.cornerRadius = 25
        addSubview(whiteCircle)
        
        addItem(item)
        item?.setSelectedConstraint()
    }
    
    func setItem(index: Int) {
        self.item?.removeFromSuperview()
        self.item = items[index]
        addItem(self.item)
        item?.setSelectedConstraint()
    }
    
    func setTabItems(viewControllers: [AnimationSwitchingViewController]) {
        items = viewControllers.map { createTabItem(viewController: $0) }
        item = items.first
    }
    
    private func addItem(_ item: AnimationSwitchingTabBarItem?) {
        guard let item = item else { return }
        addSubview(item)
        let itemSize = CGSize(width: 50, height: 50)
        item.frame = CGRect(origin: .zero, size: itemSize)
        item.layer.position = CGPoint(x: frame.width / 2, y: frame.height / 2 - 10)
    }
    
    private func createTabItem(viewController: AnimationSwitchingViewController) -> AnimationSwitchingTabBarItem {
        if viewController.selectedCustomItem == nil {
            let tabItem = AnimationSwitchingTabBarDefaultItem()
            tabItem.iconImage = viewController.iconImage
            viewController.selectedCustomItem = tabItem
        }
        return viewController.selectedCustomItem!
    }
}
