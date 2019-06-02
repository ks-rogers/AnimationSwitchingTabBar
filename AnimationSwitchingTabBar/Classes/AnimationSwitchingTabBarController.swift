//
//  AnimationSwitchingTabBarController.swift
//  AnimationSwitchingTabBar
//
//  Created by chocovayashi on 2019/04/13.
//

import UIKit

/// The `AnimationSwitchingTabBarControllerDelegate` protocol defines optional methods for a delegate of a `AnimationSwitchingTabBarController` object
public protocol AnimationSwitchingTabBarControllerDelegate: class {
    func tabBarController(_ tabBarController: AnimationSwitchingTabBarController, shouldSelect viewController: UIViewController) -> Bool
    func tabBarController(_ tabBarController: AnimationSwitchingTabBarController, didSelect viewController: UIViewController)
}

public extension AnimationSwitchingTabBarControllerDelegate {
    func tabBarController(_ tabBarController: AnimationSwitchingTabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    func tabBarController(_ tabBarController: AnimationSwitchingTabBarController, didSelect viewController: UIViewController) { }
}

///An animatable container view controller that manages a radio-style selection interface, where the selection determines which child view controller to display.
open class AnimationSwitchingTabBarController: UIViewController {

    /// The tab bar cobtroller’s delegate object.
    open weak var delegate: AnimationSwitchingTabBarControllerDelegate?

    /// tab bar controller's background color.
    @IBInspectable
    open var backgroundColor: UIColor! {
        didSet {
            viewControllers.forEach { $0.view.backgroundColor = backgroundColor }
            animationSwitchingTabBar?.changeSelectedView(color: backgroundColor)
        }
    }

    /// The tab bar view associated with this controller.
    open private(set) var animationSwitchingTabBar: AnimationSwitchingTabBar!


    /// The selected index of the tab bar controller.
    open var selectedIndex: Int {
        return _selectedIndex
    }

    fileprivate var _selectedIndex: Int = 0

    /// The child viewControllers of the tab bar controller.
    fileprivate var viewControllers: [AnimationSwitchingViewController] = []

    private lazy var tabBarDelegate = AnimationSwitchingTabBarControllerTabBarDelegate(viewController: self)

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setConstraint()
    }

    /// Sets the viewControllers in the tab bar controller.
    open func setViewControllers(_ viewControllers: [AnimationSwitchingViewController]) {
        setup(viewControllers)
    }
    

    /// Select an index in the tab bar controller.
    open func selectIndex(_ index: Int) {
        animationSwitchingTabBar.tabSelected(index: index, isAnimate: false)
    }
    
    private func setTabBar() {
        animationSwitchingTabBar = AnimationSwitchingTabBar()
        animationSwitchingTabBar.delegate = tabBarDelegate
        view.addSubview(animationSwitchingTabBar)
        animationSwitchingTabBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraint() {
        animationSwitchingTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        animationSwitchingTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        animationSwitchingTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            if let heightAnchor = animationSwitchingTabBar.constraints
                .filter({ $0.firstAnchor == animationSwitchingTabBar.heightAnchor }).first {
                animationSwitchingTabBar.removeConstraint(heightAnchor)
            }
            animationSwitchingTabBar.heightAnchor.constraint(equalToConstant: tabHeight + view.safeAreaInsets.bottom).isActive = true
        } else {
            animationSwitchingTabBar.heightAnchor.constraint(equalToConstant: tabHeight).isActive = true
        }
    }
    
    private func setup(_ viewControllers: [AnimationSwitchingViewController]) {
        self.viewControllers = viewControllers
        if let firstViewController = viewControllers.first {
            transition(to: firstViewController)
        }

        animationSwitchingTabBar.setup(viewControllers: viewControllers,
                                       selectedViewColor: backgroundColor)
    }
    
    fileprivate func transition(to viewController: UIViewController) {
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

final class AnimationSwitchingTabBarControllerTabBarDelegate: AnimationSwitchingTabBarDelegate {
    private weak var viewController: AnimationSwitchingTabBarController?

    init(viewController: AnimationSwitchingTabBarController) {
        self.viewController = viewController
    }

    func shouldTabSelected(index: Int) -> Bool {
        guard let viewController = viewController,
            let delegate = viewController.delegate else { return true }
        return delegate.tabBarController(viewController, shouldSelect: viewController.viewControllers[index])
    }

    func startAnimation(item: AnimationSwitchingTabBarItem, to: Int) { }

    func halfAnimation(item: AnimationSwitchingTabBarItem, to: Int) { }

    func finishAnimation(item: AnimationSwitchingTabBarItem, to: Int) { }

    func tabSelected(index: Int) {
        guard let viewController = viewController else { return }
        viewController._selectedIndex = index
        viewController.transition(to: viewController.viewControllers[index])
        viewController.delegate?.tabBarController(viewController, didSelect: viewController.viewControllers[index])
    }

}
