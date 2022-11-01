#
# Be sure to run `pod lib lint FastAppService.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FastAppService'
  s.version          = '0.1.0'
  s.summary          = 'Fast access to Apple services (快速接入苹果服务)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Fast access to Apple services (快速接入苹果服务):
  1. Sign with Apple
  2. Core Data
                       DESC

  s.homepage         = 'https://github.com/Pandaliya/FastAppService'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhangpan' => 'zhangpan@cls.cn' }
  s.source           = { :git => 'https://github.com/zhangpan/FastAppService.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'FastAppService/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FastAppService' => ['FastAppService/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency "FastExtension"
  s.dependency "FastLocalize"
  
end
