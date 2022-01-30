Pod::Spec.new do |s|
s.name             = 'VD'
s.version          = '1.167.0'
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
s.swift_versions = '5.5'
s.source_files = 'Sources/VDKit/**/*'
s.module_name = 'VDKit'

# s.subspec 'VDKit' do |myLib|
#     myLib.source_files = 'Sources/VDKit/**/*.swift'
#     myLib.dependency 'VDKitRuntime'
#     myLib.dependency 'VDBuilders'
#     myLib.dependency 'VDChain'
#     myLib.dependency 'UIKitEnvironment'
#     myLib.dependency 'VDCommon'
#     myLib.dependency 'VDDates'
#     myLib.dependency 'WrappedDefaults'
#     myLib.dependency 'UIKitIntegration'
#     myLib.dependency 'VDLayout'
#     myLib.dependency 'VDSwiftUICommon'
#     myLib.dependency 'BindGeometry'
#     myLib.dependency 'DragNDrop'
#     myLib.dependency 'EnvironmentStateObject'
#     myLib.dependency 'Field'
#     myLib.dependency 'Pages'
#     myLib.dependency 'Scroll'
#     myLib.dependency 'VDUIKit'
#     myLib.dependency 'VDOptional'
#     myLib.dependency 'VDMirror'
#     myLib.dependency 'LinesStack'
#     myLib.dependency 'VDCoreGraphics'
# end

s.subspec 'VDSwiftUI' do |myLib|
    myLib.dependency 'UIKitIntegration'
    myLib.dependency 'VDSwiftUICommon'
    myLib.dependency 'BindGeometry'
    myLib.dependency 'DragNDrop'
    myLib.dependency 'EnvironmentStateObject'
    myLib.dependency 'Field'
    myLib.dependency 'Pages'
    myLib.dependency 'Scroll'
    myLib.dependency 'LinesStack'
    myLib.dependency 'VDCoreGraphics'
    myLib.source_files = 'Sources/VDSwiftUI/**/*.swift'
end

s.subspec 'UIKitIntegration' do |myLib|
    myLib.dependency 'VDLayout'
    myLib.source_files = 'Sources/UIKitIntegration/**/*.swift'
end

s.subspec 'VDLayout' do |myLib|
    myLib.dependency 'VDKitRuntime'
    myLib.dependency 'VDBuilders'
    myLib.dependency 'VDChain'
    myLib.source_files = 'Sources/VDLayout/**/*.swift'
end

s.subspec 'UIKitEnvironment' do |myLib|
    myLib.dependency 'VDKitRuntime'
    myLib.dependency 'VDChain'
    myLib.source_files = 'Sources/UIKitEnvironment/**/*.swift'
end

s.subspec 'VDKitRuntime' do |mySubLib|
    mySubLib.dependency 'VDKitRuntimeObjc'
    mySubLib.ios.public_header_files =  'Sources/VDKitRuntime/**/*.h'
    mySubLib.source_files = 'Sources/VDKitRuntime/**/*.swift'
end

s.subspec 'VDKitRuntimeObjc' do |mySubLib|
    mySubLib.ios.public_header_files =  'Sources/VDKitRuntimeObjc/**/*.h'
    mySubLib.source_files = 'Sources/VDKitRuntimeObjc/**/*.m'
end

s.subspec 'VDChain' do |myLib|
    myLib.dependency 'VDOptional'
    myLib.source_files = 'Sources/VDChain/**/*.swift'
end

s.subspec 'WrappedDefaults' do |myLib|
    myLib.dependency 'VDOptional'
    myLib.source_files = 'Sources/WrappedDefaults/**/*.swift'
end

s.subspec 'LinesStack' do |myLib|
    myLib.dependency 'BindGeometry'
    myLib.source_files = 'Sources/SwiftUI/LinesStack/**/*.swift'
end

s.subspec 'DragNDrop' do |myLib|
    myLib.dependency 'EnvironmentStateObject'
    myLib.dependency 'VDSwiftUICommon'
    myLib.dependency 'BindGeometry'
    myLib.source_files = 'Sources/SwiftUI/DragNDrop/**/*.swift'
end

s.subspec 'EnvironmentStateObject' do |myLib|
    myLib.dependency ''
    myLib.source_files = 'Sources/SwiftUI/EnvironmentStateObject/**/*.swift'
end

s.subspec 'Field' do |myLib|
    myLib.dependency 'VDSwiftUICommon'
    myLib.source_files = 'Sources/SwiftUI/Field/**/*.swift'
end

s.subspec 'Pages' do |myLib|
    myLib.dependency 'VDSwiftUICommon'
    myLib.source_files = 'Sources/SwiftUI/Pages/**/*.swift'
end

s.subspec 'Scroll' do |myLib|
    myLib.dependency 'VDCommon'
    myLib.dependency 'VDSwiftUICommon'
    myLib.dependency 'VDCoreGraphics'
    myLib.source_files = 'Sources/SwiftUI/Scroll/**/*.swift'
end

s.subspec 'VDSwiftUICommon' do |myLib|
    myLib.dependency 'VDMirror'
    myLib.dependency 'VDOptional'
    myLib.dependency 'VDBuilders'
    myLib.source_files = 'Sources/SwiftUI/VDSwiftUICommon'
end

s.subspec 'VDUIKit' do |myLib|
    myLib.dependency 'VDBuilders'
    myLib.dependency 'VDCoreGraphics'
    myLib.source_files = 'Sources/VDUIKit/**/*.swift'
end

s.subspec 'BindGeometry' do |myLib|
    myLib.dependency ''
    myLib.source_files = 'Sources/SwiftUI/BindGeometry/**/*.swift'
end

s.subspec 'VDCommon' do |myLib|
    myLib.dependency 'VDBuilders'
    myLib.source_files = 'Sources/VDCommon/**/*.swift'
end

s.subspec 'VDOptional' do |myLib|
    myLib.source_files = 'Sources/VDOptional/**/*.swift'
end

s.subspec 'VDMirror' do |myLib|
    myLib.source_files = 'Sources/VDMirror/**/*.swift'
end

s.subspec 'VDCoreGraphics' do |myLib|
    myLib.source_files = 'Sources/VDCoreGraphics/**/*.swift'
end	

s.subspec 'VDDates' do |myLib|
    myLib.source_files = 'Sources/VDDates/**/*.swift'
end

s.subspec 'VDBuilders' do |myLib|
    myLib.source_files = 'Sources/VDBuilders/**/*.swift'
end
end
