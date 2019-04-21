//
//  AnimationSwitchingTabBarController.swift
//  AnimationSwitchingTabBar
//
//  Created by chocovayashi on 2019/04/13.
//

import UIKit

private let duration: Double = 0.3
private let tabHeight: CGFloat = 49

open class AnimationSwitchingTabBarController: UIViewController {
    
    private var tabItems: [UIView] = []
    
    private var selectedTabCenterXConstraint: NSLayoutConstraint?
    
    private var tabSelectedView: TabSelectedView?
    
    private var tabStackView: UIStackView?
    
    @IBInspectable private var backgroundColor: UIColor!
    
    private var viewControllers: [UIViewController] = []
    
    open private(set) var selectedIndex: Int = 0
    
    open func setViewControllers(_ viewControllers: [UIViewController]) {
        setup(viewControllers)
    }
    
    open func selectIndex(_ index: Int) {
        tabSelected(index: index, isAnimate: false)
    }
    
    private func setup(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        if let firstViewController = viewControllers.first {
            transition(to: firstViewController)
        }
        tabItems.forEach { $0.removeFromSuperview() }
        tabItems = createTabItems()
        
        if !tabItems.isEmpty {
            createCustomIcons(tabItems)
        }
    }
    
    private func transition(to viewController: UIViewController) {
        viewControllers.forEach { customRemoveFromParent($0) }
        customAddChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            viewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -tabHeight).isActive = true
        } else {
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabHeight).isActive = true
        }
        viewController.didMove(toParent: self)
    }
    
    private func createTabItems() -> [UIView] {
        
        guard viewControllers.count > 0 else { return [] }
        
        var tabItems: [UIView] = []
        
        for _ in 0 ..< viewControllers.count {
            tabItems.append(createTabItem())
        }
        
        let tabStack = UIStackView(arrangedSubviews: tabItems)
        self.tabStackView = tabStack
        tabStack.backgroundColor = .white
        tabStack.axis = .horizontal
        tabStack.distribution = .fillEqually
        tabStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabStack)
        tabStack.heightAnchor.constraint(equalToConstant: tabHeight).isActive = true
        tabStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabStack.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        let tabSelectedView = TabSelectedView(selectedColor: backgroundColor)
        self.tabSelectedView = tabSelectedView
        tabSelectedView.imageView.image = viewControllers.first?.tabBarItem.image
        tabSelectedView.translatesAutoresizingMaskIntoConstraints = false
        tabSelectedView.isUserInteractionEnabled = false
        tabStack.addSubview(tabSelectedView)
        tabSelectedView.heightAnchor.constraint(equalTo: tabItems[0].heightAnchor, multiplier: 1).isActive = true
        tabSelectedView.widthAnchor.constraint(equalTo: tabItems[0].heightAnchor, multiplier: 2).isActive = true
        tabSelectedView.centerYAnchor.constraint(equalTo: tabItems[0].centerYAnchor).isActive = true
        selectedTabCenterXConstraint = tabSelectedView.centerXAnchor.constraint(equalTo: tabItems[0].centerXAnchor)
        selectedTabCenterXConstraint?.isActive = true
        
        return tabItems
    }
    
    private func createTabItem() -> UIView {
        let tabItem = UIView()
        tabItem.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapTabItem))
        tabItem.addGestureRecognizer(tap)
        return tabItem
    }
    
    @objc private func tapTabItem(_ gesture: UIGestureRecognizer) {
        guard let index = tabItems.firstIndex(where: { $0 == gesture.view }) else { return }
        tabSelected(index: index)
    }
    
    private func createCustomIcons(_ tabItems: [UIView]) {
        
        if viewControllers.count > 5 { fatalError("More button not supported") }
        
        guard let items = viewControllers.map({ $0.tabBarItem }) as? [AnimationSwitchingTabBarItem] else {
            fatalError("items must inherit AnimationSwitchingTabBarItem")
        }
        
        for (index, item) in items.enumerated() {
            let tabItem = tabItems[index]
            
            let iconImage = item.image ?? item.iconImageView?.image
            let icon = UIImageView(image: iconImage)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.highlightedImage = item.selectedImage
            tabItem.addSubview(icon)
            
            let itemSize = item.image?.size ?? CGSize(width: 30, height: 30)
            icon.centerXAnchor.constraint(equalTo: tabItem.centerXAnchor).isActive = true
            icon.centerYAnchor.constraint(equalTo: tabItem.centerYAnchor, constant: -8).isActive = true
            icon.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
            icon.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
            item.iconImageView = icon
            
            item.image = nil
            item.title = ""
        }
    }
    
    private func tabSelected(index: Int, isAnimate: Bool = true) {
        guard let selectedTabCenterXConstraint = selectedTabCenterXConstraint, index != selectedIndex else { return }
        transition(to: viewControllers[index])
        tabSelectedView?.removeConstraint(selectedTabCenterXConstraint)
        self.selectedTabCenterXConstraint = tabSelectedView?.centerXAnchor.constraint(equalTo: tabItems[index].centerXAnchor)
        self.selectedTabCenterXConstraint?.isActive = true
        tabItems[selectedIndex].alpha = 0
        tabItems.enumerated()
            .filter { $0.offset == selectedIndex }
            .forEach { $0.element.alpha = 1 }
        
        if isAnimate {
            UIView.animate(withDuration: duration) { [weak self] in
                self?.tabStackView?.layoutIfNeeded()
            }
            UIView.animate(withDuration: duration / 2, animations: { [weak self] in
                self?.tabSelectedView?.imageView.alpha = 0
            }) { [weak self] _ in
                self?.tabSelectedView?.imageView.image = self?.tabItems[index].subviews.compactMap({ $0 as? UIImageView }).first?.image
                UIView.animate(withDuration: duration / 2) { [weak self] in
                    self?.tabSelectedView?.imageView.alpha = 1
                }
            }
            let indexArray = selectedIndex < index ? selectedIndex...index : index...selectedIndex
            let indices = selectedIndex < index ? Array<Int>(indexArray) : Array<Int>(indexArray.reversed())
            for value in indices {
                if value == indices.first {
                    UIView.animate(withDuration: duration / Double(indices.count) / 2, delay: duration / Double(indices.count), animations: { [weak self] in
                        self?.tabItems[value].alpha = 1
                    })
                } else {
                    let index = Double(indices.firstIndex(of: value) ?? 0)
                    UIView.animate(
                        withDuration: duration / Double(indices.count) / 2,
                        delay: duration * (2 * index - 1) / Double(indices.count) / 2,
                        animations: { [weak self] in
                            self?.tabItems[value].alpha = 0
                    }) { [ weak self] _ in
                        UIView.animate(
                            withDuration: duration / Double(indices.count) / 2,
                            delay: duration / Double(indices.count),
                            animations: { [ weak self] in
                                self?.tabItems[value].alpha = 1
                        })
                    }
                }
            }
        } else {
            tabSelectedView?.imageView.image = tabItems[index].subviews.compactMap({ $0 as? UIImageView }).first?.image
        }
        selectedIndex = index
    }
    
    private func customRemoveFromParent(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func customAddChild(_ viewController: UIViewController) {
        viewController.view.backgroundColor = backgroundColor
        addChild(viewController)
        view.addSubview(viewController.view)
        view.sendSubviewToBack(viewController.view)
    }
}
