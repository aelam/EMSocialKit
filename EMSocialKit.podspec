Pod::Spec.new do |s|
  s.name         = 'EMSocialKit'
  s.version      = '0.0.1'
  s.summary      = 'EMSocialKit'
  s.homepage     = 'https://github.com/aelam/EMSocial'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'aelam' => 'ryanwang@gmail.com' }

  s.source       = { :git => 'https://github.com/aelam/emsocial.git' }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.frameworks   = "UIKit","Foundation","SystemConfiguration","ImageIO"
  s.libraries    = "z","c++","sqlite3"
  s.source_files = 'EMSocialKit/**/*.{h,m}'
  s.exclude_files= 'EMSocialKit/Vendors/'
  # s.public_header_files = 'EMSocialKit/Core/*.h' ,'EMSocialKit/Share/*.h'
  s.resource_bundles = { 'EMSocialKit' => 'EMSocialKit/resources/EMSocialKit.bundle/**/*'}
  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) USE_EM_ACTIVITY=1' }

  s.dependency 'DXYWeChatSDK', '~> 1.5.1'
  s.dependency 'WeiboSDK', '~> 3.0.1'
  s.dependency 'UIImage-ResizeMagick', '~> 0.0.1'
  s.dependency 'TencentOpenApiSDK', '~> 2.9.0'
end
