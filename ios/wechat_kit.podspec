#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wechat_kit.podspec` to validate before publishing.
#

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

current_dir = Dir.pwd
calling_dir = File.dirname(__FILE__)
project_dir = calling_dir.slice(0..(calling_dir.index('/.symlinks')))
flutter_project_dir = calling_dir.slice(0..(calling_dir.index('/ios/.symlinks')))
cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'))
if cfg['wechat_kit'] && cfg['wechat_kit']['ios'] == 'no_pay'
    wechat_kit_subspec = 'no_pay'
else
    wechat_kit_subspec = 'pay'
end
Pod::UI.puts "wechatsdk #{wechat_kit_subspec}"
if cfg['wechat_kit'] && (cfg['wechat_kit']['app_id'] && cfg['wechat_kit']['universal_link'])
    app_id = cfg['wechat_kit']['app_id']
    universal_link = cfg['wechat_kit']['universal_link']
    system("ruby #{current_dir}/wechat_setup.rb -a #{app_id} -u #{universal_link} -p #{project_dir} -n Runner.xcodeproj")
else
    abort("wechat app_id/universal_link is null, add code in pubspec.yaml:\nwechat_kit:\n  app_id: ${your wechat app id}\n  universal_link: https://${your applinks domain}/universal_link/${example_app}/wechat/\n")
end

Pod::Spec.new do |s|
  s.name             = 'wechat_kit'
  s.version          = library_version
  s.summary          = pubspec['description']
  s.description      = pubspec['description']
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # s.default_subspecs = :none
  s.default_subspecs = wechat_kit_subspec, 'vendor'

  s.subspec 'pay' do |sp|
    sp.vendored_frameworks = 'Libraries/Pay/*.xcframework'
  end

  s.subspec 'no_pay' do |sp|
    sp.vendored_frameworks = 'Libraries/NoPay/*.xcframework'
    sp.pod_target_xcconfig = {
        'GCC_PREPROCESSOR_DEFINITIONS' => 'NO_PAY=1',
    }
  end

  s.subspec 'vendor' do |sp|
    sp.frameworks = 'CoreGraphics', 'Security', 'WebKit'
    sp.libraries = 'c++', 'z', 'sqlite3.0'
    sp.pod_target_xcconfig = {
        'OTHER_LDFLAGS' => '$(inherited) -ObjC -all_load',
    }
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
