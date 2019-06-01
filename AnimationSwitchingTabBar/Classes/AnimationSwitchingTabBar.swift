//
//  AnimationSwitchingTabBar.swift
//  AnimationSwitchingTabBar
//
//  Created by 辻林大揮 on 2019/04/25.
//

import UIKit

let tabHeight: CGFloat = 49

/// The `AnimationSwitchingTabBarDelegate` protocol defines optional methods for a delegate of a `AnimationSwitchingTabBar` object
public protocol AnimationSwitchingTabBarDelegate: class {
    func shouldTabSelected(index: Int) -> Bool
    func tabSelected(index: Int)
    func startAnimation(item: AnimationSwitchingTabBarItem, to: Int)
    func halfAnimation(item: AnimationSwitchingTabBarItem, to: Int)
    func finishAnimation(item: AnimationSwitchingTabBarItem, to: Int)
}

extension AnimationSwitchingTabBarDelegate {
    public func shouldTabSelected(index: Int) -> Bool {
        return true
    }

    public func tabSelected(index: Int) {}

    public func startAnimation(item: AnimationSwitchingTabBarItem, to: Int) {}

    public func halfAnimation(item: AnimationSwitchingTabBarItem, to: Int) {}

    public func finishAnimation(item: AnimationSwitchingTabBarItem, to: Int) {}
}

/// An animatable control that displays one or more buttons in a tab bar for selecting between different subtasks, views, or modes in an app.
open class AnimationSwitchingTabBar: UIView {

    /// The tab bar’s delegate object.
    weak var delegate: AnimationSwitchingTabBarDelegate?

    /// The tab bar’s animation duration.
    ///
    /// The default value is 0.3.
    open var animationDuration: Double = 0.3

    /// The tab bar’s animation options.
    ///
    /// The default value is empty.
    open var animationOptions: UIView.AnimationOptions = []

    private var tabItems: [AnimationSwitchingTabBarItem] = []
    
    private var tabStackView: UIStackView?
    
    private var tabSelectedView: AnimationSwitchingTabBarSelectedView?
    
    private var selectedTabCenterXConstraint: NSLayoutConstraint?
    
    private var selectedIndex: Int = 0

    /// Setup the tab bar layouts.
    public func setup(viewControllers: [AnimationSwitchingViewController], selectedViewColor: UIColor) {
        tabItems.forEach { $0.removeFromSuperview() }
        tabItems = createTabItems(viewControllers: viewControllers)
        tabStackView?.removeFromSuperview()
        tabStackView = createStackView(tabItems: tabItems)
        tabSelectedView = createTabSelectedView(selectedViewColor: selectedViewColor)
        tabSelectedView?.setTabItems(viewControllers: viewControllers)
        tabStackView?.addSubview(tabSelectedView!)
        addSubview(tabStackView!)
        
        setConstraint()
    }
    
    internal func changeSelectedView(color: UIColor) {
        tabSelectedView?.change(color: color)
    }
    
    private func createTabItems(viewControllers: [AnimationSwitchingViewController]) -> [AnimationSwitchingTabBarItem] {
        return viewControllers.map { createTabItem(viewController: $0) }
    }
    
    private func createTabItem(viewController: AnimationSwitchingViewController) -> AnimationSwitchingTabBarItem {
        if viewController.customItem == nil {
            let tabItem = AnimationSwitchingTabBarDefaultItem()
            tabItem.iconImage = viewController.iconImage
            viewController.customItem = tabItem
        }
        viewController.customItem?.setNotSelectedItem()
        viewController.customItem?.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapTabItem))
        viewController.customItem?.addGestureRecognizer(tap)
        return viewController.customItem!
    }
    
    private func createStackView(tabItems: [UIView]) -> UIStackView {
        let tabStack = UIStackView(arrangedSubviews: tabItems)
        tabStack.backgroundColor = .white
        tabStack.axis = .horizontal
        tabStack.distribution = .fillEqually
        tabStack.translatesAutoresizingMaskIntoConstraints = false
        return tabStack
    }
    
    private func createTabSelectedView(selectedViewColor: UIColor) -> AnimationSwitchingTabBarSelectedView {
        let tabSelectedView = AnimationSwitchingTabBarSelectedView(selectedColor: selectedViewColor)
        tabSelectedView.translatesAutoresizingMaskIntoConstraints = false
        tabSelectedView.isUserInteractionEnabled = false
        return tabSelectedView
    }
    
    private func setConstraint() {
        tabStackView?.heightAnchor.constraint(equalToConstant: tabHeight).isActive = true
        if #available(iOS 11.0, *) {
            tabStackView?.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
            tabStackView?.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
            tabStackView?.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tabStackView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            tabStackView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            tabStackView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
        tabSelectedView?.heightAnchor.constraint(equalTo: tabItems[0].heightAnchor, multiplier: 1).isActive = true
        tabSelectedView?.widthAnchor.constraint(equalTo: tabItems[0].heightAnchor, multiplier: 2).isActive = true
        tabSelectedView?.centerYAnchor.constraint(equalTo: tabItems[0].centerYAnchor).isActive = true
        selectedTabCenterXConstraint = tabSelectedView?.centerXAnchor.constraint(equalTo: tabItems[0].centerXAnchor)
        selectedTabCenterXConstraint?.isActive = true
    }
    
    @objc private func tapTabItem(_ gesture: UIGestureRecognizer) {
        guard let index = tabItems.firstIndex(where: { $0 == gesture.view }) else { return }
        tabSelected(index: index)
    }
    
    internal func tabSelected(index: Int, isAnimate: Bool = true) {
        guard let selectedTabCenterXConstraint = selectedTabCenterXConstraint, index != selectedIndex else { return }
        if let delegate = delegate, !delegate.shouldTabSelected(index: index) {
            return
        }
        self.delegate?.tabSelected(index: index)
        tabSelectedView?.removeConstraint(selectedTabCenterXConstraint)
        self.selectedTabCenterXConstraint = tabSelectedView?.centerXAnchor.constraint(equalTo: tabItems[index].centerXAnchor)
        self.selectedTabCenterXConstraint?.isActive = true
        tabItems[selectedIndex].alpha = 0
        tabItems.enumerated()
            .filter { $0.offset != selectedIndex }
            .forEach { $0.element.alpha = 1 }

        if isAnimate {
            guard let item = self.tabSelectedView?.items[index] else { return }
            delegate?.startAnimation(item: item, to: index)
            UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions, animations: { [weak self] in
                self?.tabStackView?.layoutIfNeeded()
            }) { [weak self] _ in
                guard let self = self, let item = self.tabSelectedView?.items[index] else { return }
                self.delegate?.finishAnimation(item: item, to: index)
            }
            UIView.animate(withDuration: animationDuration / 2,
                           delay: 0,
                           options: animationOptions,
                           animations: { [weak self] in
                            self?.tabSelectedView?.item?.alpha = 0
            }) { [weak self] _ in
                guard let self = self, let item = self.tabSelectedView?.items[index] else { return }
                self.delegate?.halfAnimation(item: item, to: index)
                item.animate()
                self.tabSelectedView?.setItem(index: index)
                if item.isGraduallyUpAlpha {
                    UIView.animate(withDuration: self.animationDuration / 2,
                                   delay: 0,
                                   options: self.animationOptions,
                                   animations: { [weak self] in
                                    self?.tabSelectedView?.item?.alpha = 1
                    })
                } else {
                    self.tabSelectedView?.item?.alpha = 1
                }
            }
            let indexArray = selectedIndex < index ? selectedIndex...index : index...selectedIndex
            let indices = selectedIndex < index ? Array<Int>(indexArray) : Array<Int>(indexArray.reversed())
            for value in indices {
                if value == indices.first {
                    UIView.animate(withDuration: animationDuration / Double(indices.count) / 2,
                                   delay: self.animationDuration / Double(indices.count),
                                   options: self.animationOptions,
                                   animations: { [weak self] in
                                    self?.tabItems[value].alpha = 1
                    })
                } else {
                    let index = Double(indices.firstIndex(of: value) ?? 0)
                    UIView.animate(
                        withDuration: animationDuration / Double(indices.count) / 2,
                        delay: animationDuration * (2 * index - 1) / Double(indices.count) / 2,
                        options: self.animationOptions,
                        animations: { [weak self] in
                            self?.tabItems[value].alpha = 0
                    }) { [ weak self] _ in
                        guard let self = self else { return }
                        UIView.animate(
                            withDuration: self.animationDuration / Double(indices.count) / 2,
                            delay: self.animationDuration / Double(indices.count),
                            options: self.animationOptions,
                            animations: { [ weak self] in
                                self?.tabItems[value].alpha = 1
                        })
                    }
                }
            }
        } else {
            tabSelectedView?.setItem(index: index)
        }
        selectedIndex = index
    }
}
