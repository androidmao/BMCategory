Pod::Spec.new do |s|
  s.name             = "BMCategory"
  s.version          = "0.0.9"
  s.summary          = "Custom Category used on iOS."
  s.description      = <<-DESC
                       Custom Category used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/androidmao/BMCategory"
  s.license          = 'MIT'
  s.author           = { "androidmao" => "androidmao@163.com" }
  s.platform         = :ios, '8.0'
  s.source           = { :git => "https://github.com/androidmao/BMCategory.git", :tag => s.version }
  s.source_files     = 'BMCategory/**/*.{h,m}'
  s.requires_arc     = true

  s.resource         = 'BMCategory/QRCodeBundle.bundle'
  s.dependency "Masonry"

end