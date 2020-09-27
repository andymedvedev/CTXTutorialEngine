#
#  Be sure to run `pod spec lint CTXTutorialEngine.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name                  = "CTXTutorialEngine"
  spec.version               = "1.0.2"
  spec.summary               = "CTXTutorialEngine lets to create contextual hints and tutorials."
  spec.description           = "CTXTutorialEngine is the framework that allows to show contextual hints and tutorials."

  spec.homepage              = "https://github.com/andymedvedev/CTXTutorialEngine"
  spec.license               = { :type => "MIT", :file => "LICENSE.md" }
  spec.author                = { "Andrey Medvedev" => "andertsk@gmail.com" }
  spec.source                = { :git => "https://github.com/andymedvedev/CTXTutorialEngine.git", :tag => "#{spec.version}" }

  spec.swift_version         = '5.2' 
  spec.source_files          = 'Sources/**/*.{swift,h}'
  spec.resources             = "Sources/**/*.{xcassets}"
  spec.platform              = :ios, '11.0'
end
