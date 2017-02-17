Pod::Spec.new do |s|
  s.name         = 'EMSocialKit'
  s.version      = '1.0.0-beta.5'
  s.summary      = 'EMSocialKit'
  s.homepage     = 'http://ph.benemind.com/diffusion/EMSK'
  s.license      = { :type => 'Apache License', :file => 'LICENSE' }
  s.author       = { 'aelam' => 'ryanwang@gmail.com' }

  s.source       = { :git => 'http://ph.benemind.com/diffusion/EMSK/emsocialkit-ios.git', :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.frameworks   = "UIKit","Foundation"
  s.source_files = 'EMSocialKit/**/*.{h,m,mm,swift,c}'
  s.public_header_files = 'EMSocialKit/{Core,Share}/**/*.{h}'
  s.resource_bundles = { 'EMSocialKit' => 'EMSocialKit/resources/EMSocialKit.bundle/**/*.{png}'}
  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) USE_EM_ACTIVITY=1' }

end
