#
# Be sure to run `pod lib lint MOCommonTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MOCommonTools'
  s.version          = '0.1.2'
  s.summary          = '伙伴常用组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
伙伴常用组件大全
                       DESC

  s.homepage         = 'https://github.com/Caprioce/MOCommonTools'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Caprioce' => '742666613@qq.com' }
  s.source           = { :git => 'https://github.com/Caprioce/MOCommonTools.git', :tag => s.version.to_s }
#   s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'MOCommonTools/Classes/**/*'
  
   s.resource_bundles = {
     'MOCommonTools' => ['MOCommonTools/Assets/*.png']
   }

#  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'SnapKit', '~> 4.2.0'
end
