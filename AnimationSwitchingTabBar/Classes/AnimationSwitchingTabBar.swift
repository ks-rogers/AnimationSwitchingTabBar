//
//  AnimationSwitchingTabBar.swift
//  AnimationSwitchingTabBar
//
//  Created by 辻林大揮 on 2019/04/25.
//

import UIKit

let tabHeight: CGFloat = 49
private let duration: Double = 0.3

protocol AnimationSwitchingTabBarDelegate: class {
    func tabSelected(index: Int)
}

open class AnimationSwitchingTabBar: UIView {
    
    private var tabItems: [AnimationSwitchingTabBarItem] = []
    
    private var tabStackView: UIStackView?
    
    private var tabSelectedView: AnimationSwitchingTabBarSelectedView?
    
    private var selectedTabCenterXConstraint: NSLayoutConstraint?
    
    open private(set) var selectedIndex: Int = 0
    
    weak var delegate: AnimationSwitchingTabBarDelegate?
    
    func setUp(viewControllers: [AnimationSwitchingViewController], selectedViewColor: UIColor) {
        tabItems.forEach { $0.removeFromSuperview() }
        tabItems = createTabItems(viewControllers: viewControllers)
        tabStackView?.removeFromSuperview()
        tabStackView = createStackView(tabItems: tabItems)
        tabSelectedView = createTabSelectedView(firstImage: viewControllers.first?.iconImage, selectedViewColor: selectedViewColor)
        tabStackView?.addSubview(tabSelectedView!)
        addSubview(tabStackView!)
        
        setConstraint()
    }
    
    private func createTabItems(viewControllers: [AnimationSwitchingViewController]) -> [AnimationSwitchingTabBarItem] {
        return viewControllers.map { createTabItem(viewController: $0) }
    }
    
    private func createTabItem(viewController: AnimationSwitchingViewController) -> AnimationSwitchingTabBarItem {
        let tabItem = AnimationSwitchingTabBarItem()
        tabItem.iconImage = viewController.iconImage
        tabItem.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapTabItem))
        tabItem.addGestureRecognizer(tap)
        return tabItem
    }
    
    private func createStackView(tabItems: [UIView]) -> UIStackView {
        let tabStack = UIStackView(arrangedSubviews: tabItems)
        tabStack.backgroundColor = .white
        tabStack.axis = .horizontal
        tabStack.distribution = .fillEqually
        tabStack.translatesAutoresizingMaskIntoConstraints = false
        return tabStack
    }
    
    private func createTabSelectedView(firstImage: UIImage?, selectedViewColor: UIColor) -> AnimationSwitchingTabBarSelectedView {
        let tabSelectedView = AnimationSwitchingTabBarSelectedView(selectedColor: selectedViewColor)
        tabSelectedView.imageView.image = firstImage
        tabSelectedView.translatesAutoresizingMaskIntoConstraints = false
        tabSelectedView.isUserInteractionEnabled = false
        return tabSelectedView
    }
    
    private func setConstraint() {
        tabStackView?.heightAnchor.constraint(equalToConstant: tabHeight).isActive = true
        tabStackView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tabStackView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tabStackView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
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
    
    func tabSelected(index: Int, isAnimate: Bool = true) {
        guard let selectedTabCenterXConstraint = selectedTabCenterXConstraint, index != selectedIndex else { return }
        self.delegate?.tabSelected(index: index)
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
}
