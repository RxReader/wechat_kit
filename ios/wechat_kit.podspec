#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wechat_kit.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'wechat_kit'
  s.version          = '1.1.2'
  s.summary          = 'A powerful Flutter plugin allowing developers to auth/share/pay with natvie Android & iOS Wechat SDKs.'
  s.description      = <<-DESC
A powerful Flutter plugin allowing developers to auth/share/pay with natvie Android & iOS Wechat SDKs.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # v1.8.7.1
  s.static_framework = true
  s.subspec 'vendor' do |sp|
    sp.source_files = 'Libraries/**/*.h'
    sp.public_header_files = 'Libraries/**/*.h'
    sp.vendored_libraries = 'Libraries/**/*.a'
    sp.frameworks = 'CoreGraphics', 'Security', 'WebKit'
    sp.libraries = 'c++', 'z', 'sqlite3.0'
    sp.pod_target_xcconfig = {
        'OTHER_LDFLAGS' => '$(inherited) -ObjC -all_load'
    }
  end

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
