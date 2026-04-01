Pod::Spec.new do |spec|
  spec.name                      = "SwByeDPI"
  spec.version                   = "0.17.3"
  spec.summary                   = "Wrapper and a build workflow for hufrea/byedpi"
  spec.homepage                  = "https://github.com/mIwr/SwByeDPI"
  spec.license                   = { :type => "AGPL 3.0", :file => "LICENSE" }
  spec.author                    = { "mIwr" => "https://github.com/mIwr" }
  spec.osx.deployment_target     = "10.12"
  spec.ios.deployment_target     = "10.0"
  spec.tvos.deployment_target    = "10.0"
  spec.watchos.deployment_target = "3.0"
  spec.swift_versions            = ["5.3", "5.9", "5.10", "6.0"]
  spec.swift_version             = "5.3"
  spec.source                    = { :git => "https://github.com/mIwr/SwByeDPI.git", :tag => "#{spec.version}" }
  spec.source_files              = "Sources/SwByeDPI/*.swift", "Sources/SwByeDPI/**/*.swift"
  spec.framework                 = "Foundation"
  spec.dependency                  "ByeDPIKit"
  spec.resource_bundles          = {'SwByeDPI' => ['Sources/SwByeDPI/PrivacyInfo.xcprivacy']}
end
