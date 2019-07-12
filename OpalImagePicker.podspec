Pod::Spec.new do |s|
  s.name         = "OpalImagePicker"
  s.version      = "2.1.0"
  s.summary      = "Multiple Selection Image Picker for iOS written in Swift"
  s.homepage     = "https://github.com/opalorange/OpalImagePicker"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "opalorange" => "kris@opalorange.com" }
  s.requires_arc = true
  s.platform     = :ios
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/opalorange/OpalImagePicker.git", :tag => s.version }
  s.source_files  = "OpalImagePicker/Source/*.swift"
  s.resource_bundles = { 'OpalImagePickerResources' => ['OpalImagePicker/SupportingFiles/**/*.xcassets'] }
  s.swift_version = '5.0'
end
