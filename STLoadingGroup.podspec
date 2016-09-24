Pod::Spec.new do |s|
  s.name         = “STLoadingGroup”
  s.version      = “2.0”
  s.summary      = “Loading animations in Swift”
  s.homepage     = "http://www.saitjr.com"
  s.license      = "MIT"
  s.authors      = { ‘saitjr’ => 'tangjr.work@gmail.com'}
  s.platform     = :ios, “8.0”
  s.source       = { :git => "https://github.com/saitjr/STLoadingGroup/tree/master/STLoadingGroup", :tag => s.version }
  s.source_files = ‘STLoadingGroup’, 'STLoadingGroup/**/*.{swift}’
  s.requires_arc = true
end