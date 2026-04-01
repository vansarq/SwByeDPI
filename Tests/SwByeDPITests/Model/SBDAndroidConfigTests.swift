//
//  SBDAndroid.swift
//  SwByeDPI
//
//  Created by developer on 25.03.2026.
//

import XCTest
@testable import SwByeDPI

final class SBDAndroidConfigTests: XCTestCase {
    
    func testConfigParseSerialize() {
        let data = try! JSONSerialization.data(withJSONObject: TestConstants.androidBBDConfigDict)
        let config = try! JSONDecoder().decode(SBDByeDPIAndroidConfig.self, from: data)
        XCTAssertNotNil(config, "Invalid Android BBD config parser")
        let serializedDict = config.asExportDictionary()
        XCTAssertEqual(TestConstants.androidBBDConfigDict.count, serializedDict.count, "Invalid Android BBD config serializer")
        for entry in serializedDict {
            guard let _ = TestConstants.androidBBDConfigDict[entry.key] else {
                XCTAssertTrue(false, "Not found in stock config key " + entry.key)
                return
            }
        }
        for entry in TestConstants.androidBBDConfigDict {
            guard let _ = serializedDict[entry.key] else {
                XCTAssertTrue(false, "Not found in serialized config key " + entry.key)
                return
            }
        }
    }
}
