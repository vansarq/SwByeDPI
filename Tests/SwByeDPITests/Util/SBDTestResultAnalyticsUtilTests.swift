//
//  SBDTestResultAnalyticsUtilTests.swift
//  SwByeDPI
//
//  Created by developer on 09.03.2026.
//

import XCTest
@testable import SwByeDPI

final class SBDTestResultAnalyticsUtilTests: XCTestCase {
    
    nonisolated(unsafe) fileprivate static var _testResult: [Int: SBDStrategyTestResult] = [:]
    
    override class func setUp() {
        super.setUp()
        for testRes in TestConstants.testResults {
            _testResult[testRes.strategy.id] = testRes
        }
    }

    func testRetrieveProfitStrategiesWithSuccessSLDs() {
        let profitStrategies = SBDTestResultAnalyticsUtil.retrieveProfitStrategiesWithSuccessSLDs(testResults: SBDTestResultAnalyticsUtilTests._testResult)
        XCTAssertEqual(profitStrategies.count, 2, "Invalid profit strategy retriever")
    }
    
    func testRetrieveUniversalStrategy() {
        // 1st variant: from profit strategies (max domains list count -> universal strategy)
        let profitStrategies = SBDTestResultAnalyticsUtil.retrieveProfitStrategiesWithSuccessSLDs(testResults: SBDTestResultAnalyticsUtilTests._testResult)
        var universalStrategy: (strategy: SBDStrategy, successSLDs: Set<String>)? = nil
        for entry in profitStrategies {
            if (!entry.value.universal) {
                continue
            }
            universalStrategy = (strategy: entry.key, successSLDs: entry.value.successSLDs)
            break
        }
        XCTAssertNotNil(universalStrategy, "Undefined universal strategy - nil")
        // 2nd variant: direct retrieve
        let universalStrategy2 = SBDTestResultAnalyticsUtil.retrieveBestUniversalStrategyWithSuccessSLDs(testResults: SBDTestResultAnalyticsUtilTests._testResult)
        XCTAssertNotNil(universalStrategy2, "Undefined universal strategy #2 - nil")
        let expectedLine = TestConstants.expectedUniversalStrategy.cmdArgsLine
        var actualLine = universalStrategy?.strategy.cmdArgsLine ?? ""
        XCTAssertEqual(actualLine, expectedLine, "Invalid profit strategies retriever - invalid universal strategy")
        actualLine = universalStrategy2?.strategy.cmdArgsLine ?? ""
        XCTAssertEqual(actualLine, expectedLine, "Invalid direct universal strategy retriever")
    }
    
    func testRetrieveProfitStrategiesForDomainsCmd() {
        let profitStrategies = SBDTestResultAnalyticsUtil.retrieveProfitStrategiesWithSuccessSLDs(testResults: SBDTestResultAnalyticsUtilTests._testResult)
        let cmd = SBDTestResultAnalyticsUtil.retrieveProfiStrategiesForDomainsCmd(profitStrategies: profitStrategies, withUniversal: true)
        print("Combined profit strategies with applied domains -> " + cmd.joined(separator: " "))
        XCTAssertFalse(cmd.isEmpty, "Invalid composite strategy generator")
    }
}
