Pod::Spec.new do |s|

  s.name         = "JYForm"
  s.version      = "0.0.4"
  s.summary      = "JYForm是一个强大的，能够灵活、动态创建和修改表单的iOS库"
  s.homepage     = "https://github.com/kikido/JYForm.git"
  s.license      = "MIT"
  s.author             = { "DuQianHang" => "kikido1992@gmail.com" }
  s.source       = { :git => "https://github.com/kikido/JYForm.git", :tag => "v#{s.version}" }
  s.source_files  = "JYForm", "JYForm/**/*.{h,m}"
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.resource = 'JYForm/JYForm.bundle'

end