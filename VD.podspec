Pod::Spec.new do |s|
s.name             = 'VD'
s.version          = '0.8.0'
s.summary          = 'A short description of VD.'

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://github.com/dankinsoid/VD'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'voidilov' => 'voidilov@gmail.com' }
s.source           = { :git => 'https://github.com/dankinsoid/VD.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'
s.swift_versions = '5.0'
s.source_files = 'Sources/VD/**/*'

s.dependency 'UnwrapOperator', '~> 0.1.0'

s.default_subspec = 'All'

s.subspec 'All' do |ss|
    ss.dependency	'VDUIExtensions'
    ss.dependency	'VDAsync/RxSwift'
    ss.dependency	'RxOperators'
    ss.dependency	'UnwrapOperator'
    ss.dependency	'ConstraintsOperators'
    ss.dependency	'SwiftLocalize'
    ss.dependency	'VDCodable'
    ss.source_files = 'Sources/**/*'
end
s.subspec 'Core' do |ss|
  ss.source_files = 'Sources/VD/**/*'
end
s.subspec 'UIKit' do |ss|
    ss.dependency	'VDUIExtensions'
    ss.dependency 	'VD/Core'
    ss.source_files = 'Sources/UI/**/*'
end
s.subspec 'Async' do |ss|
    ss.dependency	'VDAsync'
    ss.dependency 	'VD/Core'
    ss.source_files = 'Sources/Async/**/*'
end
s.subspec 'RxSwift' do |ss|
    ss.dependency	'RxOperators'
    ss.dependency 	'VD/Core'
    ss.source_files = 'Sources/Rx/**/*'
end
s.subspec 'Optional' do |ss|
    ss.dependency	'UnwrapOperator'
    ss.dependency 	'VD/Core'
    ss.source_files = 'Sources/Optional/**/*'
end
s.subspec 'Constraints' do |ss|
    ss.dependency	'ConstraintsOperators'
    ss.dependency 	'VD/Core'
    ss.source_files = 'Sources/Constraints/**/*'
end
s.subspec 'Localize' do |ss|
    ss.dependency	'SwiftLocalize'
    ss.dependency 	'VD/Core'
    ss.source_files = 'Sources/Localize/**/*'
end
s.subspec 'Codable' do |ss|
    ss.dependency	'VDCodable'
    ss.dependency 	'VD/Core'
    ss.source_files = 'Sources/Codable/**/*'
end


end