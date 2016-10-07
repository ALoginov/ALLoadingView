Pod::Spec.new do |s|
s.name             = 'ALLoadingView'
s.version          = '1.0.1'
s.summary          = 'Manager for loading views presentation'

s.description      = 'ALLoadingView is a class for displaying pop-up views to notify users that some work is in progress.'
s.homepage         = 'https://github.com/ALoginov/ALLoadingView'
s.screenshots      = 'http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot1-thumb.png', 'http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot2-thumb.png', 'http://dl.dropboxusercontent.com/u/72091593/Screenshots%20for%20GitHub/ALLV-screenshot3-thumb.png'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'ALoginov' => 'artemloginov@dilarc.com' }
s.source           = { :git => 'https://github.com/ALoginov/ALLoadingView.git', :tag => s.version.to_s }
s.source_files = 'ALLoadingView/Source/*.swift'
s.requires_arc = true

s.ios.deployment_target = '9.0'

end
