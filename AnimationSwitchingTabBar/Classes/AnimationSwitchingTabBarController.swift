//
//  AnimationSwitchingTabBarController.swift
//  AnimationSwitchingTabBar
//
//  Created by chocovayashi on 2019/04/13.
//

import UIKit

public protocol AnimationSwitchingTabBarControllerDelegate: class {
    func animationSwitchingTabBarController(_ toTabBarItem: AnimationSwitchingTabBarItem, willAnimated to: Int)
    func animationSwitchingTabBarController(_ toTabBarItem: AnimationSwitchingTabBarItem, halfAnimated to: Int)
    func animationSwitchingTabBarController(_ toTabBarItem: AnimationSwitchingTabBarItem, didAnimated to: Int)
}

public extension AnimationSwitchingTabBarControllerDelegate {
    func animationSwitchingTabBarController(_ toTabBarItem: AnimationSwitchingTabBarItem, willAnimated to: Int) { }
    func animationSwitchingTabBarController(_ toTabBarItem: AnimationSwitchingTabBarItem, halfAnimated to: Int) { }
    func animationSwitchingTabBarController(_ toTabBarItem: AnimationSwitchingTabBarItem, didAnimated to: Int) { }
}

open class AnimationSwitchingTabBarController: UIViewController {
    
    open private(set) var selectedIndex: Int = 0
    
    open weak var delegate: AnimationSwitchingTabBarControllerDelegate?
    
    open private(set) var animationSwitchingTabBar: AnimationSwitchingTabBar!
    
    @IBInspectable open var backgroundColor: UIColor!
    
    private var viewControllers: [AnimationSwitchingViewController] = []
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    
    open func setViewControllers(_ viewControllers: [AnimationSwitchingViewController]) {
        setUp(viewControllers)
    }
    
    open func selectIndex(_ index: Int) {
        animationSwitchingTabBar.tabSelected(index: index, isAnimate: false)
    }
    
    private func setTabBar() {
        animationSwitchingTabBar = AnimationSwitchingTabBar()
        animationSwitchingTabBar.delegate = self
        view.addSubview(animationSwitchingTabBar)
        animationSwitchingTabBar.translatesAutoresizingMaskIntoConstraints = false
        animationSwitchingTabBar.heightAnchor.constraint(equalToConstant: tabHeight).isActive = true
        animationSwitchingTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        animationSwitchingTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            animationSwitchingTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            animationSwitchingTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
    private func setUp(_ viewControllers: [AnimationSwitchingViewController]) {
        self.viewControllers = viewControllers
        if let firstViewController = viewControllers.first {
            transition(to: firstViewController)
        }
        animationSwitchingTabBar.setUp(viewControllers: viewControllers, selectedViewColor: backgroundColor)
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

extension AnimationSwitchingTabBarController: AnimationSwitchingTabBarDelegate {
    func startAnimation(item: AnimationSwitchingTabBarItem, to: Int) {
        delegate?.animationSwitchingTabBarController(item, willAnimated: to)
    }
    
    func halfAnimation(item: AnimationSwitchingTabBarItem, to: Int) {
        delegate?.animationSwitchingTabBarController(item, halfAnimated: to)
    }
    
    func finishAnimation(item: AnimationSwitchingTabBarItem, to: Int) {
        delegate?.animationSwitchingTabBarController(item, didAnimated: to)
    }
    
    func tabSelected(index: Int) {
        self.selectedIndex = index
        transition(to: viewControllers[index])
    }
}
