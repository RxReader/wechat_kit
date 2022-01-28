#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wechat_kit.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'wechat_kit'
  s.version          = '3.0.0'
  s.summary          = 'WeChat SDKs as Flutter plugin.'
  s.description      = <<-DESC
A powerful Flutter plugin allowing developers to auth/share/pay with natvie Android & iOS WeChat SDKs.
                       DESC
  s.homepage         = 'https://github.com/RxReader/wechat_kit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'RxReader' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  s.static_framework = true
  s.subspec 'vendor' do |sp|
#    sp.source_files = 'Libraries/OpenSDK1.9.2/*.h' # For regular pay
#    sp.public_header_files = 'Libraries/OpenSDK1.9.2/*.h' # For regular pay
#    sp.vendored_libraries = 'Libraries/OpenSDK1.9.2/*.a' # For regular pay
    sp.source_files = 'Libraries/OpenSDK1.9.2_NoPay/*.h' # For NoPay
    sp.public_header_files = 'Libraries/OpenSDK1.9.2_NoPay/*.h' # For NoPay
    sp.vendored_libraries = 'Libraries/OpenSDK1.9.2_NoPay/*.a' # For NoPay
    sp.frameworks = 'CoreGraphics', 'Security', 'WebKit'
    sp.libraries = 'c++', 'z', 'sqlite3.0'
    sp.pod_target_xcconfig = {
        'OTHER_LDFLAGS' => '$(inherited) -ObjC -all_load',
        'GCC_PREPROCESSOR_DEFINITIONS' => 'NO_PAY=1' # For NoPay
    }
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
