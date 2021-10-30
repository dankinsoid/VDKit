Pod::Spec.new do |s|
s.name             = 'VD'
s.version          = '1.121.0'
s.summary          = 'This repository contains useful extensions on Foundation and UIKit'

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://github.com/dankinsoid/VDKit'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'voidilov' => 'voidilov@gmail.com' }
s.source           = { :git => 'https://github.com/dankinsoid/VDKit.git', :tag => s.version.to_s }

s.ios.deployment_target = '11.0'
s.ios.public_header_files =  'Sources/VDKit/Runtime/**/*.h'
s.swift_versions = '5.4'
s.source_files = 'Sources/**/*'
s.module_name = 'VDKit'

end
