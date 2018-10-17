Pod::Spec.new do |s|

  # 1
  s.platform              = :ios
  s.ios.deployment_target = '10.0'
  s.swift_version         = '4.2.0'
  s.name                  = 'Valley'
  s.summary               = 'A simple loading and caching system for Images, Data and JSONS'

  # 2
  s.version = '1.1.3'
  
  # 3
  s.license   = { :type => 'MIT', :file => "LICENSE" }

  # 4
  s.authors   = { 'Luciano Bohrer' => 'bohrerluciano@gmail.com' }

  # 5
  s.homepage  = 'https://github.com/lucianobohrer/Valley'

  # 6
  s.source    = { :git => 'https://github.com/lucianobohrer/Valley.git', :tag => s.version }

  # 7
  s.ios.framework = 'UIKit'
  s.ios.framework  = 'Foundation'

  # 8
  s.source_files  = 'Valley/Source/**/*'

end
