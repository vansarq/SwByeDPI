//
//  SBDStrategyTests.swift
//  SwByeDPI
//
//  Created by developer on 31.03.2026.
//

import XCTest
@testable import SwByeDPI

final class SBDStrategyTests: XCTestCase {
    
    func testCmdLineDomainsParseInit() {
        var sourceCmdArgs: [String] = ["-H:\"site1.com site2.com\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        var expectedCmdArgs: [String] = ["-H:site1.com site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        var strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:site1.com site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:\"site1.com\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:site1.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H domainOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H", "domainOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H", "domainOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H", "domainOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:\"site1.com", "site2.com\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:\"site1.com", "site2.com", "site3.com\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com site2.com site3.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:site1.com", "site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
    }
    
    func testCmdLineIPSetParseInit() {
        var sourceCmdArgs: [String] = ["-j:\"173.245.48.0/20 103.21.244.0/22\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        var expectedCmdArgs: [String] = ["-j:173.245.48.0/20 103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        var strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:173.245.48.0/20 103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20 103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:\"173.245.48.0/20\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:173.245.48.0/20", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j ipOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j", "ipOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j", "ipOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j", "ipOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:\"173.245.48.0/20", "103.21.244.0/22\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20 103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:\"173.245.48.0/20", "103.21.244.0/22", "103.22.200.0/22\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20 103.21.244.0/22 103.22.200.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:173.245.48.0/20", "103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20 103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdLine: sourceCmdArgs.joined(separator: " "))
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
    }
    
    func testCmdArgsDomainsParseInit() {
        var sourceCmdArgs: [String] = ["-H:\"site1.com site2.com\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        var expectedCmdArgs: [String] = ["-H:site1.com site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        var strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:site1.com site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:\"site1.com\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:site1.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H domainOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H", "domainOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H", "domainOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H", "domainOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:\"site1.com", "site2.com\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:\"site1.com", "site2.com", "site3.com\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com site2.com site3.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-H:site1.com", "site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-H:site1.com site2.com", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
    }
    
    func testCmdArgsIPSetParseInit() {
        var sourceCmdArgs: [String] = ["-j:\"173.245.48.0/20 103.21.244.0/22\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        var expectedCmdArgs: [String] = ["-j:173.245.48.0/20 103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        var strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:173.245.48.0/20 103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20 103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:\"173.245.48.0/20\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:173.245.48.0/20", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j ipOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j", "ipOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j", "ipOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j", "ipOrFile", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:\"173.245.48.0/20", "103.21.244.0/22\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20 103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:\"173.245.48.0/20", "103.21.244.0/22", "103.22.200.0/22\"", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20 103.21.244.0/22 103.22.200.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
        
        sourceCmdArgs = ["-j:173.245.48.0/20", "103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        expectedCmdArgs = ["-j:173.245.48.0/20 103.21.244.0/22", "-d1", "-r1+s", "-f-1", "-S", "-t8", "-o3+s", "-a1"]
        strategy = SBDStrategy(cmdArgs: sourceCmdArgs)
        XCTAssertEqual(strategy.cmdArgs, expectedCmdArgs, "Invalid byedpi strategy cmd args parser")
    }
}
