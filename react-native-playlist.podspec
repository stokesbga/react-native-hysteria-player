require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-playlist"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-playlist
                   DESC
  s.homepage     = "https://github.com/stokesbga/react-native-playlist"
  s.license      = "MIT"
  s.authors      = { "Alex Yosef" => "alex@quadio.com" }
  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/stokesbga/react-native-playlist.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true
  s.frameworks   = "CoreMedia", "AudioToolbox", "AVFoundation"
  s.swift_versions = "5"

  s.dependency "React"
  s.dependency "ObjectMapper", "~> 3.5.0"
  s.dependency "AlamofireImage", "~> 4.0.0"
end

