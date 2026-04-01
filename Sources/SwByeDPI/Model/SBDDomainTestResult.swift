//
//  SBDTestDomainResult.swift
//  SwByeDPI
//
//  Created by developer on 20.02.2026.
//

import Foundation

/// DPI-evasion domain test result
public final class SBDDomainTestResult: Hashable, Codable, Cloneable  {
    
    /// Tested domain (Test result ID)
    public let domain: String
    
    /// Passed requests count
    public let successRequestsCount: UInt8
    
    /// Failed requests count
    public let failedRequestsCount: UInt8
    
    /// Total requests count
    public var requestsCount: UInt8 {
        get {
            return successRequestsCount + failedRequestsCount
        }
    }
    
    ///Test is successful flag
    public var successTest: Bool {
        get {
            return successRequestsCount >= failedRequestsCount
        }
    }
    
    /// Test is failed flag
    public var failedTest: Bool {
        get {
            return !successTest
        }
    }
    
    public init(domain: String, successRequestsCount: UInt8, failedRequestsCount: UInt8) {
        self.domain = domain
        self.successRequestsCount = successRequestsCount
        self.failedRequestsCount = failedRequestsCount
    }
    
    public init(source: SBDDomainTestResult) {
        self.domain = source.domain
        self.successRequestsCount = source.successRequestsCount
        self.failedRequestsCount = source.failedRequestsCount
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(domain)
    }
    
    /// Creates the new instance - clone with optinal edited values
    /// - Parameters:
    ///   - domain: New domain. Optional
    ///   - successRequestsCount: New success requests count. Optional
    ///   - failedRequestsCount: New fail requests count. Optional
    /// - Returns: Cloned domain test result
    public func copyWith(domain: String? = nil, successRequestsCount: UInt8? = nil, failedRequestsCount: UInt8? = nil) -> SBDDomainTestResult {
        return SBDDomainTestResult(domain: domain ?? self.domain, successRequestsCount: successRequestsCount ?? self.successRequestsCount, failedRequestsCount: failedRequestsCount ?? self.failedRequestsCount)
    }
    
    public static func == (lhs: SBDDomainTestResult, rhs: SBDDomainTestResult) -> Bool {
        return lhs.domain == rhs.domain
    }
    
}

#if swift(>=5.5)
extension SBDDomainTestResult: Sendable {}
#endif
