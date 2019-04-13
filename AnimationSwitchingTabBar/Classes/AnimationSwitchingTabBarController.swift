//
//  AnimationSwitchingTabBarController.swift
//  AnimationSwitchingTabBar
//
//  Created by chocovayashi on 2019/04/13.
//

import UIKit

open class AnimationSwitchingTabBarController: UITabBarController {
    
    private var containers: [UIView] = []
    
    private var selectedTabCenterXConstraint: NSLayoutConstraint?
    
    private var tabSelectedView: TabSelectedView?
    
    open override var viewControllers: [UIViewController]? {
        didSet {
            initializeContainers()
        }
    }
    
    open override var selectedIndex: Int {
        didSet {
            tabSelected(index: selectedIndex, isAnimate: false)
        }
    }
    
    open override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        initializeContainers()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        initializeContainers()
        delegate = self
        
        view.backgroundColor = .red
        
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .white
        tabBar.shadowImage = UIImage()
    }
    
    private func initializeContainers() {
        containers.forEach { $0.removeFromSuperview() }
        containers = createViewContainers()
        
        if !containers.isEmpty {
            createCustomIcons(containers)
        }
    }
    
    private func createCustomIcons(_ containers: [UIView]) {
        
        if let items = tabBar.items, items.count > 5 { fatalError("More button not supported") }
        
        guard let items = tabBar.items as? [AnimationSwitchingTabBarItem] else {
            fatalError("items must inherit AnimationSwitchingTabBarItem")
        }
        
        for (index, item) in items.enumerated() {
            let container = containers[index]
            
            let iconImage = item.image ?? item.iconImageView?.image
            let icon = UIImageView(image: iconImage)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.highlightedImage = item.selectedImage
            container.addSubview(icon)
            
            let itemSize = item.image?.size ?? CGSize(width: 30, height: 30)
            icon.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            icon.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -8).isActive = true
            icon.widthAnchor.constraint(equalToConstant: itemSize.width).isActive = true
            icon.heightAnchor.constraint(equalToConstant: itemSize.height).isActive = true
            
            if item.isEnabled == false {
                icon.alpha = 0.5
            }
            item.iconImageView = icon
            
            item.image = nil
            item.title = ""
        }
    }
    
    private func createViewContainers() -> [UIView] {
        
        guard let items = tabBar.items, items.count > 0 else { return [] }
        
        var containers: [UIView] = []
        
        for _ in 0 ..< items.count {
            containers.append(createViewContainer())
        }
        
        let tabStack = UIStackView(arrangedSubviews: containers)
        tabStack.axis = .horizontal
        tabStack.distribution = .fillEqually
        tabStack.translatesAutoresizingMaskIntoConstraints = false
        tabStack.isUserInteractionEnabled = false
        view.addSubview(tabStack)
        tabStack.heightAnchor.constraint(equalToConstant: 49).isActive = true
        tabStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabStack.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        let tabSelectedView = TabSelectedView()
        self.tabSelectedView = tabSelectedView
        tabSelectedView.imageView.image = items[0].image
        tabSelectedView.translatesAutoresizingMaskIntoConstraints = false
        tabSelectedView.isUserInteractionEnabled = false
        view.addSubview(tabSelectedView)
        tabSelectedView.heightAnchor.constraint(equalTo: containers[0].heightAnchor, multiplier: 1).isActive = true
        tabSelectedView.widthAnchor.constraint(equalTo: containers[0].heightAnchor, multiplier: 2).isActive = true
        tabSelectedView.centerYAnchor.constraint(equalTo: containers[0].centerYAnchor).isActive = true
        selectedTabCenterXConstraint = tabSelectedView.centerXAnchor.constraint(equalTo: containers[0].centerXAnchor)
        selectedTabCenterXConstraint?.isActive = true
        
        return containers
    }
    
    private func createViewContainer() -> UIView {
        let viewContainer = UIView()
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.isUserInteractionEnabled = false
        
        return viewContainer
    }
    
    private func tabSelected(index: Int, isAnimate: Bool = true) {
        guard let selectedTabCenterXConstraint = selectedTabCenterXConstraint else { return }
        
        tabSelectedView?.removeConstraint(selectedTabCenterXConstraint)
        self.selectedTabCenterXConstraint = tabSelectedView?.centerXAnchor.constraint(equalTo: containers[index].centerXAnchor)
        self.selectedTabCenterXConstraint?.isActive = true
        
        if isAnimate {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.tabSelectedView?.imageView.alpha = 0
            }) { [weak self] _ in
                self?.tabSelectedView?.imageView.image = self?.containers[index].subviews.compactMap({ $0 as? UIImageView }).first?.image
                UIView.animate(withDuration: 0.15) { [weak self] in
                    self?.tabSelectedView?.imageView.alpha = 1
                }
            }
        } else {
            tabSelectedView?.imageView.image = containers[index].subviews.compactMap({ $0 as? UIImageView }).first?.image
        }
    }
}

extension AnimationSwitchingTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(where: { $0 == viewController }) else { return true }
        tabSelected(index: index)
        return true
    }
}
