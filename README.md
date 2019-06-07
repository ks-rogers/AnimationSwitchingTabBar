# AnimationSwitchingTabBar

[![Version](https://img.shields.io/cocoapods/v/AnimationSwitchingTabBar.svg?style=flat)](https://cocoapods.org/pods/AnimationSwitchingTabBar)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg?style=flat)](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/AnimationSwitchingTabBar.svg?style=flat)](https://cocoapods.org/pods/AnimationSwitchingTabBar)
[![Platform](https://img.shields.io/cocoapods/p/AnimationSwitchingTabBar.svg?style=flat)](https://cocoapods.org/pods/AnimationSwitchingTabBar)

## Overview
AnimationSwitchingTabBar is an animatable tab bar class in Swift.
This project is inspired by [the dribble project](https://dribbble.com/shots/6044647-Tab-Bar-Animation-nr-3). 

![alt text](https://github.com/ks-rogers/Assets/blob/master/AnimationSwitchingTabBar/demo.gif)

## Usage
### Basic
#### Define a tab view controller
Inherit `AnimationSwitchingTabBarController` . And set child view controllers.

```swift
class TabViewController: AnimationSwitchingTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1: AnimationSwitchingViewController = ...
        let vc2: AnimationSwitchingViewController = ...
        let vc3: AnimationSwitchingViewController = ...
        setViewControllers([vc1, vc2, vc3])
    }
}
```

#### Define child view controllers
Inherit `AnimationSwitchingViewController` . And set an icon image.

```swift
class Child1ViewController: AnimationSwitchingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setIcon(image: UIImage(named: "SearchIcon"))
    }
}
```

#### Implement delegate

```swift
extension TabViewController: AnimationSwitchingTabBarControllerDelegate {
    override func tabBarController(_ tabBarController: AnimationSwitchingTabBarController,
                                   shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    override func tabBarController(_ tabBarController: AnimationSwitchingTabBarController, 
                                   didSelect viewController: UIViewController) {
        // Called when an tab bar controller selected the child view controller.
    }
}
```

### Others
#### Set animatable icon
Define custom item class. And, configure constraints and an animation.

```swift
class CustomAnimatableItem: AnimationSwitchingTabBarItem {
    override func animate() {
        super.animate()
        // Define the item's animation to start.
    }
    
    override func setNotSelectedItem() {
        super.setNotSelectedItem()
        // Define constraints if the item is not selected.
    }
    
    override func setSelectedItem() {
        super.setNotSelectedItem()
        // Define constraints if the item is selected.
    }
}
```

## Requirements
- Swift 4.2 ~
- Xcode 10.x ~

## Installation
### CocoaPods

AnimationSwitchingTabBar will be available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AnimationSwitchingTabBar'
```

### Carthage
You can integrate via [Carthage](https://github.com/carthage/carthage), too.
Add the following line to your `Cartfile` :

```
github "ks-rogers/AnimationSwitchingTabBar"
```

and run `carthage update`

## Author

This framework was created by [K.S.Rogers](https://ks-rogers.co.jp)

## License

AnimationSwitchingTabBar is available under the MIT license. See the LICENSE file for more info.
