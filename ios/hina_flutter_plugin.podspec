#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint hina_flutter_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'hina_flutter_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://github.com/dequal/HinaCloudSDK'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Hina' => 'denghao@hinadt.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.dependency 'HinaCloudSDK', ">= 1.0.3"
  # # 你可以像这样依赖你自己的框架:写入plugin的podspec文件：
  # s.ios.vendored_frameworks = 'libs/HinaCloudSDK.framework'
  # s.vendored_frameworks = 'HinaCloudSDK.framework'

  # s.ios.vendored_frameworks = 'libs/HinaCloudSDK.framework'
  # s.vendored_frameworks = 'HinaCloudSDK.framework'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
