Pod::Spec.new do |s|
  s.name         = 'EMSocial'
  s.version      = '0.0.1'
  s.summary      = 'EMSocial'
  s.homepage     = 'https://github.com/aelam/EMSocial'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'nickcheng' => 'ryanwang@gmail.com' }

  s.source       = { :git => '.' }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.frameworks   = "UIKit","Foundation"
  s.source_files = 'EMSocial/**/*.{h,m}'
  non_arc_files = ['EMSocial/Vendors/SinaWeibo/**/*.{h,m}','EMSocial/Vendors/SBJSON/**/*.{h,m}']
  s.exclude_files = non_arc_files
  s.public_header_files = 'EMSocial/**/*.h'
  s.resource_bundles = { 'EMSocial' => 'EMSocial/*.xcassets'}
  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) USE_EM_ACTIVITY=1' }

  #s.preserve_paths = 'EMSocial/Vendors/libWeiboSDK/libWeiboSDK.a'
  # s.libraries = 'libWeiboSDK'
  s.vendored_libraries = 'EMSocial/Vendors/libWeiboSDK/libWeiboSDK.a'

  s.subspec 'no-arc' do |sna|
    sna.requires_arc = false
    sna.source_files = non_arc_files
  end


  s.dependency 'WeChatSDK', '0.0.1'
  #s.dependency 'SinaWeibo64', '2.4.0'
  # s.dependency 'WeiboSDK', '3.0.1'
  s.dependency 'UIImage-ResizeMagick', '0.0.1'
  s.dependency 'JSONKit-NoWarning', '1.2'

end
