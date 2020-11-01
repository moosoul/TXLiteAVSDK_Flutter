#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tx_lite_av_sdk.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tx_lite_av_sdk'
  s.version          = '0.0.7'
  s.summary          = 'A new flutter plugin project.'
  s.description      = 'A new flutter plugin project.'
  s.homepage         = 'https://965work.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'com.965work' => 'm.moosoul@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'TXLiteAVSDK_Professional'

  s.platform = :ios, '8.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
