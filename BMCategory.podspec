Pod::Spec.new do |s|
  s.name             = "BMCategory"
  s.version          = "0.0.1"
  s.summary          = "Custom Category used on iOS."
  s.description      = <<-DESC
                       Custom Category used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/android/BMCategory"
  s.license          = 'MIT'
  s.author           = { "androidmao" => "androidmao@163.com" }
  s.platform         = :ios, '8.0'
  s.source           = { :git => "https://github.com/android/BMCategory.git", :tag => s.version }
  s.source_files     = 'BMCategory/**/*.{h,m}'
  s.requires_arc     = true
end