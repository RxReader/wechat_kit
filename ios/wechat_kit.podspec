#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'wechat_kit'
  s.version          = '1.0.1'
  s.summary          = 'A powerful Flutter plugin allowing developers to share with natvie android & iOS Wechat SDKs.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  # 微信
  s.static_framework = true
  s.dependency 'WechatOpenSDK', '~> 1.8.6'

  s.ios.deployment_target = '8.0'
end

