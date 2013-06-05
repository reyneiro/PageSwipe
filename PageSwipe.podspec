Pod::Spec.new do |s|
  s.name         = "PageSwipe"
  s.version      = "0.1"
  s.summary      = "Scroll."
  s.homepage     = ""
  s.license      = 'MIT'
  s.author       = { "Reyneiro Hernandez"}
  s.source       = { :git => "https://github.com/reyneiro/PageSwipe.git", :tag => "0.1" }
  s.platform     = :ios, '5.0'
  s.source_files = 'Page Swipe/Page Swipe/Classes/*.{h,m}'
  s.requires_arc = true
end
