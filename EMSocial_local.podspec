Pod::Spec.new do |s|
  s.name         = 'EMSocial'
  s.version      = '0.0.1'
  s.summary      = 'EMSocial'
  s.homepage     = 'https://github.com/aelam/EMSocial'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'aelam' => 'ryanwang@gmail.com' }

  s.source       = { :git => '.' }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.frameworks   = "UIKit","Foundation","SystemConfiguration","ImageIO"
  s.libraries    = "z","c++"
  s.source_files = 'EMSocial/**/*.{h,m}'
  s.public_header_files = 'EMSocial/**/*.h'
  s.resource_bundles = { 'EMSocial' => 'EMSocial/EMSocial.bundle'}
  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) USE_EM_ACTIVITY=1' }


  s.exclude_files = non_arc_files
  s.subspec 'Core' do |core|
    sna.requires_arc = false
    sna.source_files = non_arc_files
  end

  s.dependency 'DXYWeChatSDK', '1.5.1'
  s.dependency 'WeiboSDK', '3.0.1'
  s.dependency 'UIImage-ResizeMagick', '0.0.1'
  s.dependency 'JSONKit-NoWarning', '1.2'

end
