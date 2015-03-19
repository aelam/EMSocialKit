Pod::Spec.new do |s|
  s.name         = 'EMSocial'
  s.version      = '0.0.1'
  s.summary      = 'Unify multi share channels.'
  s.homepage     = 'https://github.com/aelam/EMSocial'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'nickcheng' => 'ryanwang@gmail.com' }

  s.source       = { :git => 'https://github.com/aelam/emsocial.git' }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.frameworks   = "UIKit","Foundation","SystemConfiguration","ImageIO"
  s.source_files = 'EMSocial/**/*.{h,m}'
  s.public_header_files = 'EMSocial/**/*.h'
  s.resource_bundles = { 'EMSocial' => 'EMSocial/*.xcassets'}
  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) USE_EM_ACTIVITY=1' }

  #non_arc_files = ['EMSocial/Vendors/SinaWeibo/**/*.{h,m}','EMSocial/Vendors/SBJSON/**/*.{h,m}']
  non_arc_files = ['EMSocial/Vendors/SBJSON/**/*.{h,m}']
  s.exclude_files = non_arc_files
  s.subspec 'no-arc' do |sna|
    sna.requires_arc = false
    sna.source_files = non_arc_files
  end

  s.dependency 'WeChatSDK', '0.0.1'
  s.dependency 'WeiboSDK', '3.0.1'
  s.dependency 'UIImage-ResizeMagick', '0.0.1'
  s.dependency 'JSONKit-NoWarning', '1.2'

end
