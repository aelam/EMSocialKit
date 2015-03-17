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

  s.source_files = 'EMSocial/**/*.{h,m}'
  s.public_header_files = 'EMSocial/**/*.h'
  s.resource_bundles = { 'EMSocial' => 'EMSocial/*.xcassets'}
  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) USE_EM_ACTIVITY=1' }
  
  s.dependency 'WeChatSDK', '0.0.1'
  s.dependency 'SinaWeibo64', '2.4.0'
  s.dependency 'UIImage-ResizeMagick', '0.0.1'

end
