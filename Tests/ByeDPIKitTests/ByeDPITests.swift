//
//  SwByeDPITests.swift
//  ByeDPITests
//
//  Created by developer on 09.02.2026.
//

import XCTest
@testable import ByeDPIKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class ByeDPITests: XCTestCase {
    
    fileprivate static let _args: [String] = ["-i", "127.0.0.1", "-p", "10800", "--oob", "3"]
    
    func testDPISyncStartStop() async {
        let exp = self.expectation(description: "Test time-out expectation")
        let thread = Thread(block: {
            let status = ByeDPI.startSync(args: ByeDPITests._args)
            XCTAssertEqual(0, status, "Invalid start byeDPI process")
            exp.fulfill()
        })
        thread.name = "ByeDPI(ciadpi)"
        thread.start()
        sleep(1)
        XCTAssertTrue(ByeDPI.proxyStarted, "ByeDPI proxy not started")
        XCTAssertEqual(0, ByeDPI.stop(), "Invalid stop byeDPI process")
        XCTAssertFalse(ByeDPI.proxyStarted, "ByeDPI proxy still active after stop")
        await fulfillment(of: [exp], timeout: 3)
        XCTAssertTrue(thread.isFinished, "ByeDPI thread still active after stop")
        _ = ByeDPI.stop()
    }
    
    func testFailDPIStart() async {
        var args = [String].init(ByeDPITests._args)
        args.append(contentsOf: ["--invalid", "123"])
        let exp = self.expectation(description: "Wait time-out expectation")
        ByeDPI.start(args: args) { launchErr in
            print(launchErr)
            XCTAssertTrue(true)
            exp.fulfill()
        }
        await fulfillment(of: [exp], timeout: 1)
        _ = ByeDPI.stop()
    }
    
    func testFailDPIStartSync() {
        var args = [String].init(ByeDPITests._args)
        args.append(contentsOf: ["--invalid", "123"])
        let cmdOp = ByeDPI.startSync(args: args)
        XCTAssertLessThanOrEqual(cmdOp, -1, "Invalid launch args processed by byedpi as valid. Possible update")
    }
    
    func testFailDPIStartAsync() async {
        var args = [String].init(ByeDPITests._args)
        args.append(contentsOf: ["--invalid", "123"])
        let cmdOp = await ByeDPI.start(args: args)
        XCTAssertNotNil(cmdOp, "Invalid launch args processed by byedpi as valid. Possible update")
    }
    
    func testStopDPI() async {
        let exp = self.expectation(description: "Test time-out expectation")
        ByeDPI.start(args: ByeDPITests._args) { launchErr in
            print(launchErr)
            XCTAssertTrue(false)
            exp.fulfill()
        }
        sleep(1)
        print("Cancel iniated")
        XCTAssertTrue(ByeDPI.proxyStarted, "ByeDPI proxy not started")
        let stopStatusCode = ByeDPI.stop()
        XCTAssertEqual(stopStatusCode, 0, "Invalid stop byeDPI process")
        if (stopStatusCode == 0) {
            exp.fulfill()
        }
        XCTAssertFalse(ByeDPI.proxyStarted, "ByeDPI proxy still active after stop")
        await fulfillment(of: [exp], timeout: 3)
        XCTAssertTrue(ByeDPI.testableDpiThread?.isFinished == true, "ByeDPI thread still active after stop")
        _ = ByeDPI.stop()
    }
    
    func testDPIProxy() async {
        let exp = self.expectation(description: "Wait time-out expectation")
        ByeDPI.start(args: ["-i", "127.0.0.1", "-p", "10800"]) { launchErr in
            XCTAssertTrue(false, "Invalid launch args")
            exp.fulfill()
        }
        let req = URLRequest(url: URL(string: "https://google.com")!)
        let proxySession = URLSessionUtil.initSocksProxySession(addr: "127.0.0.1", port: 10800)
        let task = proxySession.dataTask(with: req) { (data, response, err) in
            guard let safeData = data else {
                XCTAssertTrue(false, "Received nil response data. Possible invalid proxy session settings or DPI blockings")
                exp.fulfill()
                return
            }
            XCTAssertGreaterThan(safeData.count, 0, "Received zero bytes of response data. Possible invalid proxy session settings or DPI blockings")
            exp.fulfill()
        }
        task.resume()
        await fulfillment(of: [exp], timeout: 5)
        _ = ByeDPI.stop()
    }
    
    func testDPIAsyncProxy() async {
        let exp = self.expectation(description: "Wait time-out expectation")
        let startRes = await ByeDPI.start(args: ByeDPITests._args)
        XCTAssertNil(startRes, "Async byedpi start error")
        let req = URLRequest(url: URL(string: "https://google.com")!)
        let proxySession = URLSessionUtil.initSocksProxySession(addr: "127.0.0.1", port: 10800)
        let task = proxySession.dataTask(with: req) { (data, response, err) in
            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertNotEqual(httpResponse.statusCode, 0, "Invalid response")
            }
            exp.fulfill()
        }
        task.resume()
        await fulfillment(of: [exp], timeout: 5)
        _ = ByeDPI.stop()
    }
}
