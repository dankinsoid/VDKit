Pod::Spec.new do |s|
s.name             = 'VD'
s.version          = '0.2.0'
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
    ss.dependency	'VDUIExtensions', '~> 0.3.0'
    ss.dependency	'VDAsync', '~> 0.4.0'
    ss.dependency	'RxOperators', '~> 0.4.0'
    ss.dependency	'UnwrapOperator', '~> 0.1.0'
    ss.dependency	'ConstraintsOperators', '~> 0.1.0'
    ss.dependency	'SwiftLocalize', '~> 1.7.0'
end
s.subspec 'UIKit' do |ss|
    ss.dependency	'VDUIExtensions', '~> 0.3.0'
end
s.subspec 'Async' do |ss|
    ss.dependency	'VDAsync', '~> 0.4.0'
end
s.subspec 'RxSwift' do |ss|
    ss.dependency	'RxOperators', '~> 0.4.0'
end
s.subspec 'Optional' do |ss|
    ss.dependency	'UnwrapOperator', '~> 0.1.0'
end
s.subspec 'Constraints' do |ss|
    ss.dependency	'ConstraintsOperators', '~> 0.1.0'
end
s.subspec 'Localize' do |ss|
    ss.dependency	'SwiftLocalize', '~> 1.7.0'
end

end