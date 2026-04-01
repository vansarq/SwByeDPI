//
//  SBDStrategyTestResult.swift
//  SwByeDPI
//
//  Created by developer on 20.02.2026.
//

import Foundation

/// DPI-evasion strategy test result
public final class SBDStrategyTestResult: Codable, Cloneable {
    
    /// DPI-evasion strategy
    public let strategy: SBDStrategy
    /// DPI-evasion domains tests result
    public let domainsTestsResult: [String: SBDDomainTestResult]
    
    /// Sorted DPI-evasion domains tests result (domain name ascending)
    public var sortedDomainsTestsResult: [SBDDomainTestResult] {
        get {
            var res = [SBDDomainTestResult].init(domainsTestsResult.values)
            res.sort { a, b in
                return SBDDomainController.comparator(domainA: a.domain, domainB: b.domain) == .orderedAscending
            }
            return res
        }
    }

    /// Unique Second-Level Domains (SLDs) from domains' tests result
    public var uniqueSLDs: Set<String> {
        get {
            var res = Set<String>()
            for key in domainsTestsResult.keys {
                guard let sld = SBDDomainUtil.retrieveSLD(key), !res.contains(sld) else {
                    continue
                }
                res.insert(sld)
            }
            return res;
        }
    }
    
    /// DPI-evasion passed domains' test results
    public var successDomainChecks: Set<SBDDomainTestResult> {
        get {
            var res = Set<SBDDomainTestResult>()
            for entry in domainsTestsResult {
                if (entry.value.failedTest) {
                    continue
                }
                res.insert(entry.value)
            }
            return res
        }
    }

    /// DPI-evasion passed domains
    public var successDomains: Set<String> {
        get {
            var res = Set<String>()
            for entry in domainsTestsResult {
                if (entry.value.failedTest) {
                    continue
                }
                res.insert(entry.value.domain)
            }
            return res
        }
    }

    public var successSLDs: Set<String> {
        get {
            var res = Set<String>()
            for entry in domainsTestsResult {
                if (entry.value.failedTest) {
                    continue;
                }
                guard let sld = SBDDomainUtil.retrieveSLD(entry.key), !res.contains(sld) else {
                    continue
                }
                res.insert(sld)
            }
            return res
        }
    }

    /// DPI-evasion passed domains count
    public var successDomainsCount: Int {
        get {
            var counter = 0
            for entry in domainsTestsResult {
                if (entry.value.failedTest) {
                    continue
                }
                counter += 1
            }
            return counter
        }
    }

    /// DPI-evasion passed domains' success requests count
    public var successDomainRequestsCount: Int {
        get {
            var res = 0
            for entry in domainsTestsResult {
                res += Int(entry.value.successRequestsCount)
            }
            return res
        }
    }

    /// DPI-evasion failed domains' test results
    public var failedDomainChecks: Set<SBDDomainTestResult> {
        get {
            var res = Set<SBDDomainTestResult>()
            for entry in domainsTestsResult {
                if (entry.value.successTest) {
                    continue
                }
                res.insert(entry.value)
            }
            return res
        }
    }

    /// DPI-evasion failed domains
    public var failedDomains: Set<String> {
        get {
            var res = Set<String>()
            for entry in domainsTestsResult {
                if (entry.value.successTest) {
                    continue
                }
                res.insert(entry.value.domain)
            }
            return res
        }
    }

    /// DPI-evasion failed domains count
    public var failedDomainsCount: Int {
        get {
            var counter = 0
            for entry in domainsTestsResult {
                if (entry.value.successTest) {
                    continue
                }
                counter += 1
            }
            return counter
        }
    }

    /// DPI-evasion failed domains' requests count
    public var failedDomainRequestsCount: Int {
        get {
            var res = 0
            for entry in domainsTestsResult {
                res += Int(entry.value.failedRequestsCount)
            }
            return res
        }
    }
    
    /// The strategy is successful according tests flag (success domains count > failed domains count)
    public var successStrategy: Bool {
        get {
            return successDomainsCount >= failedDomainsCount
        }
    }

    /// The strategy is fail according tests flag (failed domains count > success domains count)
    public var failStrategy: Bool {
        get {
            return failedDomainsCount >= successDomainsCount
        }
    }
    
    public init(strategy: SBDStrategy, domainsTestResult: [String: SBDDomainTestResult]) {
        self.strategy = strategy
        self.domainsTestsResult = domainsTestResult
    }
    
    public init(source: SBDStrategyTestResult) {
        self.strategy = source.strategy
        var dict: [String: SBDDomainTestResult] = [:]
        for entry in source.domainsTestsResult {
            dict[entry.key] = entry.value.copyWith()
        }
        self.domainsTestsResult = dict
    }
    
    /// Creates the new instance - clone with optinal edited values
    /// - Parameters:
    ///   - strategy: New strategy. Optiona
    ///   - domainsTestsResult: New domains' test results. Optional
    /// - Returns: Cloned strategy test result
    public func copyWith(strategy: SBDStrategy? = nil, domainsTestsResult: [String: SBDDomainTestResult]? = nil) -> SBDStrategyTestResult {
        return SBDStrategyTestResult(strategy: strategy ?? self.strategy, domainsTestResult: domainsTestsResult ?? self.domainsTestsResult)
    }
    
}

#if swift(>=5.5)
extension SBDStrategyTestResult: Sendable {}
#endif
