Pod::Spec.new do |s|
  s.name             = 'AnimationSwitchingTabBar'
  s.version          = '0.1.0'
  s.summary          = 'AnimationSwitchingTabBar is an animatable tab bar class in Swift.'

  s.description      = <<-DESC
AnimationSwitchingTabBar is an animatable tab bar class in Swift.
This project is inspired by [the dribble project](https://dribbble.com/shots/6044647-Tab-Bar-Animation-nr-3).
                       DESC

  s.homepage         = 'https://github.com/ks-rogers/animation-switching-tab-bar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'K.S.Rogers' => 'info@ks-rogers.co.jp' }
  s.source           = { :git => 'https://github.com/ks-rogers/animation-switching-tab-bar.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'AnimationSwitchingTabBar/Sources/**/*'

  s.public_header_files = 'AnimationSwitchingTabBar/Sources/AnimationSwitchingTabBar.h'
  s.frameworks = 'UIKit'
  s.swift_version = '5.0'
end
