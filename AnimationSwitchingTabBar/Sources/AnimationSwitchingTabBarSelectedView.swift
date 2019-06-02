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

    private var selectedColor: UIColor
    
    private let whiteCircle: UIView
    
    init(selectedColor: UIColor) {
        self.selectedColor = selectedColor
        whiteCircle = UIView(frame: CGRect(origin: .zero, size: .init(width: 50, height: 50)))
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func change(color: UIColor) {
        selectedColor = color
        setNeedsDisplay()
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
        whiteCircle.layer.position = CGPoint(x: rect.maxX / 2, y: rect.maxY / 2 - 10)
        whiteCircle.backgroundColor = .white
        whiteCircle.layer.cornerRadius = 25
        addSubview(whiteCircle)
        
        addItem(item)
        item?.setSelectedItem()
    }
    
    func setItem(index: Int) {
        self.item?.removeFromSuperview()
        self.item = items[index]
        self.item?.alpha = 0
        addItem(self.item)
        item?.setSelectedItem()
    }
    
    func setTabItems(viewControllers: [AnimationSwitchingViewController]) {
        items = viewControllers.map { createTabItem(viewController: $0) }
        item = items.first
    }
    
    func springAnimation() {
        let springAnimation = CABasicAnimation(keyPath: "position.x")
        springAnimation.fromValue = whiteCircle.layer.position.x + 4
        springAnimation.toValue = whiteCircle.layer.position.x - 4
        springAnimation.duration = 0.1
        springAnimation.autoreverses = true
        whiteCircle.layer.add(springAnimation, forKey: "springAnimation")
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
