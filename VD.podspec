Pod::Spec.new do |s|
s.name             = 'VD'
s.version          = '0.10.0'
s.summary          = 'A short description of VD.'

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://github.com/dankinsoid/VD'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'voidilov' => 'voidilov@gmail.com' }
s.source           = { :git => 'https://github.com/dankinsoid/VD.git', :tag => s.version.to_s }

s.ios.deployment_target = '11.0'
s.swift_versions = '5.1'
s.source_files = 'Sources/**/*'

end