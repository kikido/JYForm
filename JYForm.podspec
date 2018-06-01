#
#  Be sure to run `pod spec lint JYForm.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "JYForm"
  s.version      = "0.0.1"
  s.summary      = "JYForm是一个能够灵活，动态创建表单的iOS库"
  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/kikido/JYForm"
  s.license      = "MIT"
  s.author             = { "kikido1992" => "kikido1992@gmail.com" }
  s.source       = { :git => "http://EXAMPLE/JYForm.git", :tag => "#{s.version}" }
  s.source_files  = "JYForm/**/*.{h,m}"
  s.requires_arc = true
  s.ios.deployment_target = '8.0'



end
