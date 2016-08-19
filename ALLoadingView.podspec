#
# Be sure to run `pod lib lint ALLoadingView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'ALLoadingView'
s.version          = '0.1.3'
s.summary          = 'Manager for loading views presentation'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = 'ALLoadingView is a class for displaying pop-up views to notify users that some work is in progress.'
s.homepage         = 'https://github.com/ALoginov/ALLoadingView'
s.screenshots     = 'http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot1-thumb.png', 'http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot2-thumb.png', 'http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot3-thumb.png'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'ALoginov' => 'artemloginov@me.com' }
s.source           = { :git => 'https://github.com/ALoginov/ALLoadingView.git', :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/ibvene'

s.ios.deployment_target = '8.0'

s.source_files = "ALLoadingView/**/*.{swift}"

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
