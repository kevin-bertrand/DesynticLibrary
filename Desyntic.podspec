Pod::Spec.new do |s|
  s.name             = 'Desyntic'
  s.version          = '1.0.0'
  s.summary          = 'A brief description of Desyntic.'
  s.description      = <<-DESC
                       Desyntic is a library for simplifying the process of XYZ.
                       DESC
  s.homepage         = 'https://github.com/kevin-bertrand-digimobee/Desyntic'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kevin Bertrand' => 'kevin.bertrand@digimobee.com' }
  s.source           = { :git => 'https://github.com/kevin-bertrand-digimobee/Desyntic.git', :tag => s.version.to_s }
  s.swift_version    = '5.3'
  s.platform         = :ios, '14.0'
  s.source_files     = 'Sources/**/*.swift'
  s.swift_versions   = ['5.3']
  s.ios.deployment_target = '14.0'
  s.module_name      = 'Desyntic'
  s.swift_version    = '5.3'
  s.ios.vendored_frameworks = 'Framework/Desyntic.xcframework'
end
