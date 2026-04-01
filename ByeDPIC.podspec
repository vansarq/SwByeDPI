Pod::Spec.new do |spec|
  spec.name                      = "ByeDPIC"
  spec.version                   = "0.17.3"
  spec.summary                   = "Wrapper and a build workflow for hufrea/byedpi"
  spec.homepage                  = "https://github.com/mIwr/SwByeDPI"
  spec.license                   = { :type => "AGPL 3.0", :file => "LICENSE" }
  spec.author                    = { "mIwr" => "https://github.com/mIwr" }
  spec.osx.deployment_target     = "10.12"
  spec.ios.deployment_target     = "9.0"
  spec.tvos.deployment_target    = "9.0"
  spec.watchos.deployment_target = "2.0"
  spec.source                    = { :git => "https://github.com/mIwr/SwByeDPI.git", :tag => "#{spec.version}" }
  spec.exclude_files             = "Sources/ByeDPIC/byedpi/win_service.c", "Sources/ByeDPIC/byedpi/win_service.h", "Sources/ByeDPIC/byedpi/.gitignore"
  spec.source_files              = "Sources/ByeDPIC/*.{c,h}", "Sources/ByeDPIC/byedpi/*.{c,h}", "Sources/ByeDPIC/include/*.h"
  spec.public_header_files       = "Sources/ByeDPIC/include/*.h"
  spec.private_header_files      = "Sources/ByeDPIC/byedpi/*.h", "Sources/ByeDPIC/ciadpi_bridge.h"
  spec.library                   = 'c'
  spec.pod_target_xcconfig       = {
    'ENABLE_USER_SCRIPT_SANDBOXING' => 'NO',
    'CLANG_C_LANGUAGE_STANDARD'     => 'c17',
    'CLANG_C_LIBRARY'               => 'libc',
    'HEADER_SEARCH_PATHS'           => '${PODS_ROOT}/SwByeDPI/Sources/ByeDPIC/include',
    'OTHER_CFLAGS'                  => '-UDAEMON -Dmain=ciadpi_main -Wno-implicit-function-declaration'
  }
  spec.resource_bundles          = {'ByeDPIC' => ['Sources/ByeDPIC/PrivacyInfo.xcprivacy', "Sources/ByeDPIC/byedpi/LICENSE"]}
end
