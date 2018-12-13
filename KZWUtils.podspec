#
# Be sure to run `pod lib lint KZWUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KZWUtils'
  s.version          = '1.0.2'
  s.summary          = 'A short description of KZWUtils.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ouyrp/KZWUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ouyrp' => 'rp.ouyang001@bkjk.com' }
  s.source           = { :git => 'https://github.com/ouyrp/KZWUtils.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'KZWUtils/Classes/KZWUtils.h'
  s.subspec 'Content' do |ss|
      ss.source_files = 'KZWUtils/Classes/*'
      ss.exclude_files = 'KZWUtils/Classes/KZWUtils.h'
      ss.resource_bundles = {
          'KZWUI' => 'KZWUtils/Assets/*.xcassets'
      }
      ss.dependency 'MJRefresh'
      ss.frameworks = 'UIKit', 'Security','MapKit' , 'WebKit' , 'AudioToolbox'
  end
  
 
end
