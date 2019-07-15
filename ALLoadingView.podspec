Pod::Spec.new do |s|
s.name             = 'ALLoadingView'
s.version          = '1.1.5'
s.summary          = 'Manager for loading views presentation'

s.description      = 'ALLoadingView is a class for displaying pop-up views to notify users that some work is in progress.'
s.homepage         = 'https://github.com/ALoginov/ALLoadingView'
s.screenshots      = 'https://raw.githubusercontent.com/ALoginov/ALLoadingView/master/images/ALLV-screenshot1-thumb.png', 'https://raw.githubusercontent.com/ALoginov/ALLoadingView/master/images/ALLV-screenshot2-thumb.png', 'https://raw.githubusercontent.com/ALoginov/ALLoadingView/master/images/ALLV-screenshot3-thumb.png'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'ALoginov' => 'artemloginov@dilarc.com' }
s.source           = { :git => 'https://github.com/ALoginov/ALLoadingView.git', :tag => s.version.to_s }
s.source_files = 'ALLoadingView/Source/ALLoadingView.swift'

s.requires_arc = true

s.ios.deployment_target = '9.0'

end
