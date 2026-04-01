// swift-tools-version:5.3
import PackageDescription

var cSettings: [CSetting] = [
    .headerSearchPath("byedpi"),
    .define("main", to: "ciadpi_main"),// bypass executable product/target type
    // On iOS/macOS we need BSD sockets, not Linux-specific
    .unsafeFlags([
        "-UDAEMON",
        "-Wno-implicit-function-declaration"
    ])
]

var cExclude: [String] = [
    "byedpi/.gitignore",
    "byedpi/win_service.c",
    "byedpi/win_service.h"
]

#if os(Windows)
cExclude = [
    "byedpi/.gitignore"
]
#endif

#if os(Linux)
cSettings.append(.define("_POSIX_C_SOURCE", to: "200809L"))
#endif

let package = Package(
    name: "SwByeDPI",
    platforms: [
        .macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3),
    ],
    products: [
        .library(name: "ByeDPIC", type: .static, targets: ["ByeDPIC"]),
        .library(name: "ByeDPIKit", targets: ["ByeDPIKit"]),
        .library(name: "SwByeDPI", targets: ["SwByeDPI"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "ByeDPIC", exclude: cExclude,
                resources: [
                    .copy("PrivacyInfo.xcprivacy"),
                    .copy("byedpi/LICENSE")
                ],
                publicHeadersPath: "include",
                cSettings: cSettings),
        .target(name: "ByeDPIKit", dependencies: ["ByeDPIC"], resources: [.copy("PrivacyInfo.xcprivacy")]),
        .target(name: "SwByeDPI", dependencies: ["ByeDPIKit"], resources: [.copy("PrivacyInfo.xcprivacy")]),
        .testTarget(name: "ByeDPIKitTests", dependencies: ["ByeDPIKit"]),
        .testTarget(name: "SwByeDPITests", dependencies: ["SwByeDPI"]),
    ],
    swiftLanguageVersions: [.v5],
    cLanguageStandard: .c11
)
