//
//  SBDTestResultAnalyticsUtil.swift
//  SwByeDPI
//
//  Created by developer on 05.03.2026.
//

import Foundation

public final class SBDTestResultAnalyticsUtil {
    
    /// Generates the composite ByeDPI-evasion command-line arguments, which can be built with 3 optional parts:
    /// 1) ByeDPI bypass Second-Level Domains (SLDs) block. Inserts at the beginning
    /// 2) DPI-evasion command-line arguments with covered by 'profit' strategies Second-Level Domains (SLDs). Inserts at the middle
    /// 3) DPI-evasion command-line arguments with the universal (the best 'profit') strategy for the rest domains, which isn't included in ByeDPI bypass and covered blocks
    ///
    /// - Parameters:
    ///   - byedpiBypassDns: Bypass DNS resolve for byedpi (bypass port 53) flag
    ///   - testResults: Strategy tests results dictionary [Strategy ID: Strategy]
    ///   - byedpiBypassSLD: ByeDPI bypass Second-Level Domains (SLDs) set. If nil, no bypass block will be used
    ///   - explicitUseProfitStrategiesForDomains: Use 'covered' block in composite ByeDPI-evasion command-line arguments
    ///   - useBestUniversalStrategy: Use universal strategy in composite ByeDPI-evasion command-line arguments
    ///
    /// - Returns: Composite ByeDPI-evasion command-line arguments
    public static func retrieveCompositeByeDPIConfigCmdArgs(byedpiBypassDns: Bool, testResults: [Int: SBDStrategyTestResult], byedpiBypassSLD: Set<String>?, explicitUseProfitStrategiesForDomains: Bool, useBestUniversalStrategy: Bool) -> [String] {
        if (!explicitUseProfitStrategiesForDomains && !useBestUniversalStrategy) {
            return retrieveDPIBypassDomainsCmd(byedpiBypassSLD)
        }
        let profitStrategies = retrieveProfitStrategiesWithSuccessSLDs(testResults: testResults)
        
        return retrieveCompositeByeDPIConfigCmdArgs(byedpiBypassDns: byedpiBypassDns, profitStrategies: profitStrategies, byedpiBypassSLD: byedpiBypassSLD, explicitUseProfitStrategiesForDomains: explicitUseProfitStrategiesForDomains, useBestUniversalStrategy: useBestUniversalStrategy)
    }
    
    /// Generates the composite ByeDPI-evasion command-line arguments, which can be built with 3 optional parts:
    ///
    /// 1) ByeDPI bypass Second-Level Domains (SLDs) block. Inserts at the beginning
    /// 2) DPI-evasion command-line arguments with covered by 'profit' strategies Second-Level Domains (SLDs). Inserts at the middle
    /// 3) DPI-evasion command-line arguments with the universal (the best 'profit') strategy for the rest domains, which isn't included in ByeDPI bypass and covered blocks
    ///
    /// - Parameters:
    ///   - byedpiBypassDns: Bypass DNS resolve for byedpi (bypass port 53) flag
    ///   - profitStrategies: Dictionary with 'profit' strategies, which can cover all success domains
    ///   - byedpiBypassSLD: ByeDPI bypass Second-Level Domains (SLDs) set. If nil, no bypass block will be used
    ///   - explicitUseProfitStrategiesForDomains: Use 'covered' block in composite ByeDPI-evasion command-line arguments
    ///   - useBestUniversalStrategy: Use universal strategy in composite ByeDPI-evasion command-line arguments
    ///
    /// - Returns: Composite ByeDPI-evasion command-line arguments
    public static func retrieveCompositeByeDPIConfigCmdArgs(byedpiBypassDns: Bool, profitStrategies: [SBDStrategy: (universal: Bool, successSLDs: Set<String>)], byedpiBypassSLD: Set<String>?, explicitUseProfitStrategiesForDomains: Bool, useBestUniversalStrategy: Bool) -> [String] {
        var cmdArgs: [String] = []
        if (byedpiBypassDns) {
            cmdArgs.append(contentsOf: retrieveDPIBypassDnsCmd())
        }
        cmdArgs.append(contentsOf: retrieveDPIBypassDomainsCmd(byedpiBypassSLD))
        if (profitStrategies.isEmpty || (!explicitUseProfitStrategiesForDomains && !useBestUniversalStrategy)) {
            return cmdArgs
        }
        if (explicitUseProfitStrategiesForDomains && (profitStrategies.count > 1 || !useBestUniversalStrategy)) {
            // Use whitelisted strategies and profit ones count > 1 (not only universal strategy) -> Insert whitelisted (with DPI) second-level domains
            cmdArgs.append(contentsOf: SBDTestResultAnalyticsUtil.retrieveProfiStrategiesForDomainsCmd(profitStrategies: profitStrategies, withUniversal: useBestUniversalStrategy))
            if (useBestUniversalStrategy) {
                cmdArgs.append("-An")
            }
        }
        if (useBestUniversalStrategy) {
            var universalStrategy: SBDStrategy? = nil
            for entry in profitStrategies {
                if (!entry.value.universal) {
                    continue
                }
                universalStrategy = entry.key
                break
            }
            guard let safeUniversalStrategy = universalStrategy else {
                return cmdArgs
            }
            cmdArgs.append(contentsOf: safeUniversalStrategy.cmdArgs)
        }
        
        return cmdArgs
    }
    
    /// Generates the composite ByeDPI-evasion command-line arguments, which can be built with 3 optional parts:
    ///
    /// 1) ByeDPI bypass Second-Level Domains (SLDs) block. Inserts at the beginning
    /// 2) DPI-evasion command-line arguments with covered by 'profit' strategies Second-Level Domains (SLDs). Inserts at the middle
    /// 3) DPI-evasion command-line arguments with the universal strategy for the rest domains, which isn't included in ByeDPI bypass and covered blocks
    ///
    /// - Parameters:
    ///   - byedpiBypassSLDCmd: ByeDPI bypass Second-Level Domains (SLDs) set cmd. If nil, no bypass block will be used
    ///   - profitStrategiesWithDomainsCmd: 'covered' block in composite ByeDPI-evasion command-line arguments. If nil, the block won't be used
    ///   - universalStrategyCmd: Universal strategy cmd in composite ByeDPI-evasion command-line arguments
    ///
    /// - Returns: Composite ByeDPI-evasion command-line arguments
    public static func retrieveCompositeByeDPIConfigCmdArgs(byedpiBypassDns: Bool, byedpiBypassSLDCmd: [String]?, profitStrategiesWithDomainsCmd: [String]?, universalStrategyCmd: [String]?) -> [String] {
        var res: [String] = []
        if (byedpiBypassDns) {
            res.append(contentsOf: retrieveDPIBypassDnsCmd())
        }
        if let safeByedpiBypassSLDCmd = byedpiBypassSLDCmd, !safeByedpiBypassSLDCmd.isEmpty {
            res.append(contentsOf: safeByedpiBypassSLDCmd)
            if (safeByedpiBypassSLDCmd.last != "-An") {
                res.append("-An")
            }
        }
        if let safeProfitStrategiesWithDomainsCmd = profitStrategiesWithDomainsCmd, !safeProfitStrategiesWithDomainsCmd.isEmpty {
            res.append(contentsOf: safeProfitStrategiesWithDomainsCmd)
            if let safeLast = safeProfitStrategiesWithDomainsCmd.last {
                if (!safeLast.hasPrefix("-A") && !safeLast.hasPrefix("--auto") && universalStrategyCmd?.isEmpty == false) {
                    res.append("-An")
                }
            }
        }
        if let safeUniversalStrategyCmd = universalStrategyCmd, !safeUniversalStrategyCmd.isEmpty {
            res.append(contentsOf: safeUniversalStrategyCmd)
        }
        return res
    }
    
    /// Generates DPI-evasion command-line arguments based on DNS port filter (53), which won't be affected by ByeDPI
    /// - Returns: DPI-evasion command-line arguments for the further insertion (beginning of the composite DPI-evasion command-line arguments)
    public static func retrieveDPIBypassDnsCmd() -> [String] {
        // '-V53 -An ...Rest strategy' means 'Doesn't apply byedpi strategies for port 53'
        let cmdArgs: [String] = [
            SBDStrategy.generateDnsBypassArg(),
            "-An"
        ]
        return cmdArgs
    }

    /// Generates DPI-evasion command-line arguments based on Second-Level Domains (SLDs), which won't be affected by ByeDPI
    /// - Parameter dpiBypassSLD: Second-Level Domains (SLDs) set
    /// - Returns: DPI-evasion command-line arguments for the further insertion (beginning of the composite DPI-evasion command-line arguments)
    public static func retrieveDPIBypassDomainsCmd(_ dpiBypassSLD: Set<String>?) -> [String] {
        guard let safeDpiBypassSLD = dpiBypassSLD, !safeDpiBypassSLD.isEmpty else {
            return []
        }
        var cmdArgs: [String] = [SBDStrategy.generateSLDsHostsArg(sldSet: safeDpiBypassSLD)]
        // -H:"site.com site2.com site3.co site4.co.uk" -auto=none
        cmdArgs.append("-An")
        return cmdArgs
    }
    
    /// Generates DPI-evasion command-line arguments based on the profit strategies and covered by them domain lists
    /// - Parameter profitStrategies: Dictionary with 'profit' strategies, which can cover all domain lists
    /// - Returns: DPI-evasion command-line arguments for the further insertion (middle of the composite DPI-evasion command-line arguments), which applicable only for covered Second-Level Domains (SLDs) from domain lists
    public static func retrieveProfiStrategiesForDomainsCmd(profitStrategies: [SBDStrategy: (universal: Bool, successSLDs: Set<String>)], withUniversal: Bool) -> [String] {
        if (profitStrategies.isEmpty) {
            return []
        }
        // Insert whitelisted (with DPI) second-level domains
        var cmdArgs: [String] = []
        let strategiesCmdDivider = "-An"
        for entry in profitStrategies {
            if (entry.value.universal && !withUniversal) {
                continue
            }
            let hostsAppliedStrategy = entry.key.generateWithAppliedSLDs(sldSet: entry.value.successSLDs)
#if DEBUG
            print("Strategy before -> " + entry.key.cmdArgsLine)
            print("Strategy after -> " + hostsAppliedStrategy.cmdArgsLine)
#endif
            cmdArgs.append(contentsOf: hostsAppliedStrategy.cmdArgs)
            guard let safeLastCmdArg = hostsAppliedStrategy.cmdArgs.last else {
                continue
            }
            if (safeLastCmdArg.hasPrefix("-A") || safeLastCmdArg.hasPrefix("--auto")) {
                continue
            }
            //Insert strategy divider
            cmdArgs.append(strategiesCmdDivider)
        }
        if (!cmdArgs.isEmpty && cmdArgs.last == strategiesCmdDivider) {
            //Remove the last divider
            cmdArgs.removeLast()
        }
        return cmdArgs
    }

    /// Retrieves strategy with the biggest success domains count -> universal strategy
    /// - Parameter testResults: Strategies' testings results
    /// - Returns: Universal strategy with affected success SLDs
    public static func retrieveBestUniversalStrategyWithSuccessSLDs(testResults: [Int: SBDStrategyTestResult]) -> (strategy: SBDStrategy, successSLDs: Set<String>)? {
        if (testResults.isEmpty) {
            return nil
        }
        var bestStrategy: SBDStrategy?
        var bestSuccessSLDs = Set<String>()
        for testResult in testResults.values {
            // Stage 1 - check success slds count
            let successSLDs = testResult.successSLDs
            if (bestSuccessSLDs.count > successSLDs.count) {
                continue
            }
            if (bestSuccessSLDs.count < successSLDs.count) {
                bestSuccessSLDs = testResult.successSLDs
                bestStrategy = testResult.strategy
                continue
            }
            //Current strategy is the same by success domains and SLDs count
            // Stage 2 - check strategy args length
            guard let safeBestStrategy = bestStrategy, safeBestStrategy.cmdArgs.count <= testResult.strategy.cmdArgs.count else {
                bestSuccessSLDs = testResult.successSLDs
                bestStrategy = testResult.strategy
                continue
            }
        }
        guard let safeBestStrategy = bestStrategy else {
            return nil
        }
        return (strategy: safeBestStrategy, successSLDs: bestSuccessSLDs)
    }

    /// Retrieves strategies optimal cover for tested success Second-Level Domains (SLDs)
    /// - Parameter testResults: Strategies' testings results
    /// - Returns: Domains coverage by strategies
    public static func retrieveProfitStrategiesWithSuccessSLDs(testResults: [Int: SBDStrategyTestResult]) -> [SBDStrategy: (universal: Bool, successSLDs: Set<String>)] {
        if (testResults.isEmpty) {
            return [:]
        }
        var profitStrategies: [SBDStrategy: (universal: Bool, successSLDs: Set<String>)] = [:]
        
        var strategySuccessDomains: [SBDStrategy: Set<String>] = [:]
        var strategySuccessSLDs: [SBDStrategy: Set<String>] = [:]
        
        var allSuccessDomains = Set<String>()
        var allSuccessTestSLDs = Set<String>()
        var sldsWithDomains: [String: Set<String>] = [:]
        var domainsWithSLDs: [String: String] = [:]
        
        // Stage 1 - Define universal strategy
        var bestStrategy: SBDStrategy?
        var bestStrategySuccessDomains = Set<String>()
        var bestStrategySuccessTestSLDs = Set<String>()
        for testResult in testResults.values {
            let successDomains = testResult.successDomains
            strategySuccessDomains[testResult.strategy] = successDomains
            var successSLDs = Set<String>()
            for successDomain in successDomains {
                //Scanning unique domains and SLDs in test results
                if (!allSuccessDomains.contains(successDomain)) {
                    allSuccessDomains.insert(successDomain)
                }
                guard let sld = SBDDomainUtil.retrieveSLD(successDomain) else {
                    continue
                }
                domainsWithSLDs[successDomain] = sld
                if (!successSLDs.contains(sld)) {
                    successSLDs.insert(sld)
                }
                if (!allSuccessTestSLDs.contains(sld)) {
                    allSuccessTestSLDs.insert(sld)
                }
                if let safeDomains = sldsWithDomains[sld] {
                    if (!safeDomains.contains(successDomain)) {
                        sldsWithDomains[sld]?.insert(successDomain)
                    }
                } else {
                    sldsWithDomains[sld] = Set<String>([successDomain])
                }
            }
            strategySuccessSLDs[testResult.strategy] = successSLDs
            // Check success slds count
            if (bestStrategySuccessTestSLDs.count > successSLDs.count) {
                continue
            }
            if (bestStrategySuccessTestSLDs.count < successSLDs.count) {
                bestStrategySuccessDomains = successDomains
                bestStrategySuccessTestSLDs = successSLDs
                bestStrategy = testResult.strategy
                continue
            }
            //Current strategy is the same by SLDs count -> check success domains count
            if (bestStrategySuccessDomains.count > successDomains.count) {
                continue
            }
            if (bestStrategySuccessDomains.count < successDomains.count) {
                bestStrategySuccessDomains = successDomains
                bestStrategySuccessTestSLDs = successSLDs
                bestStrategy = testResult.strategy
                continue
            }
            //Current strategy is the same by success SLDs and domains count -> check args length
            guard let safeBestStrategy = bestStrategy, safeBestStrategy.cmdArgs.count <= testResult.strategy.cmdArgs.count else {
                // No best strategy yet or current strategy has less args count than best one -> set new
                bestStrategySuccessDomains = successDomains
                bestStrategySuccessTestSLDs = testResult.successSLDs
                bestStrategy = testResult.strategy
                continue
            }
        }
        if let safeBestStrategy = bestStrategy {
            // Universal strategy has only SLDs
            profitStrategies[safeBestStrategy] = (universal: true, successSLDs: bestStrategySuccessTestSLDs)
            // Remove covered by universal strategy domains and SLDs from unique sets
            for successDomain in bestStrategySuccessDomains {
                // 1 - Remove domain
                allSuccessDomains.remove(successDomain)
                // 2 - Remove link with SLD
                guard let sld = domainsWithSLDs.removeValue(forKey: successDomain) ?? SBDDomainUtil.retrieveSLD(successDomain) else {
                    continue
                }
                guard let _ = sldsWithDomains[sld]?.remove(successDomain) else {
                    continue
                }
                if (sldsWithDomains[sld]?.isEmpty == false) {
                    continue
                }
                // No success domains for SLD remain -> Universal strategy covers all and may use only SLD for ByeDPI cmdArg -> Remove SLD
                allSuccessTestSLDs.remove(sld)
                sldsWithDomains.removeValue(forKey: sld)
            }
        }
        if (allSuccessDomains.isEmpty && allSuccessTestSLDs.isEmpty) {
            // All SLDs and its domains are covered by universal strategy -> finish
            return profitStrategies
        }
        // Stage 2 - Define whitelisted strategies for remain domains and its SLDs
        var strategyCoverRemainDomainsCounter: [SBDStrategy: Int] = [:]
        for successDomain in allSuccessDomains {
            for entry in strategySuccessDomains {
                if (!entry.value.contains(successDomain)) {
                    // Domain doesn't exist in the current strategy test success domains (failed) -> skip
                    continue
                }
                guard let _ = strategyCoverRemainDomainsCounter[entry.key] else {
                    strategyCoverRemainDomainsCounter[entry.key] = 1
                    continue
                }
                strategyCoverRemainDomainsCounter[entry.key]? += 1
            }
        }
        // Define strategy for each domain with max frequency
        var domainFrequentStrategy: [String: SBDStrategy] = [:]
        for successDomain in allSuccessDomains {
            var maxFreq = 0
            var maxFreqStrategy: SBDStrategy? = nil
            for entry in strategyCoverRemainDomainsCounter {
                if (maxFreq >= entry.value || strategySuccessDomains[entry.key]?.contains(successDomain) == false) {
                    // Current strategy is worse than the best one (by frequency) or doesn't have success test for domain -> skip
                    continue
                }
                maxFreq = entry.value
                maxFreqStrategy = entry.key
            }
            guard let safeMaxFreqStrategy = maxFreqStrategy else {
                continue
            }
            domainFrequentStrategy[successDomain] = safeMaxFreqStrategy
        }
        // Combine domains with the same max freq strategies
        var whitelistedStrategies: [SBDStrategy: Set<String>] = [:]
        for entry in domainFrequentStrategy {
            guard let _ = whitelistedStrategies[entry.value] else {
                whitelistedStrategies[entry.value] = Set<String>([entry.key])
                continue
            }
            whitelistedStrategies[entry.value]?.insert(entry.key)
        }
        // Transform strategies with domains into strategies with SLDs
        for entry in whitelistedStrategies {
            var sldSet = Set<String>()
            for successDomain in entry.value {
                guard let sld = domainsWithSLDs[successDomain] ?? SBDDomainUtil.retrieveSLD(successDomain) else {
                    sldSet.insert(successDomain)
                    continue
                }
                if (sldSet.contains(sld)) {
                    continue
                }
                sldSet.insert(sld)
            }
            profitStrategies[entry.key] = (universal: false, successSLDs: sldSet)
        }
        return profitStrategies
    }

    /// Computes coverage for domain list from strategy test result across second-level domains (SLDs) (Extracts success domain tests according domain list in the parent strategy test result). The base function for the analytics ops
    /// - Parameters:
    ///   - list: Domain list for coverage compute
    ///   - strategyTestResult: Strategy test result
    /// - Returns: Strategy coverage info
    public static func computeStrategyCoverageForDomainList(_ list: SBDDomainList, strategyTestResult: SBDStrategyTestResult) -> SBDStrategyCoverage {
        if (list.items.isEmpty) {
            return SBDStrategyCoverage(strategy: strategyTestResult.strategy, sldCoverage: [:])
        }
        let sldList = list.retrieveSLDList()
        return computeStrategyCoverageForSLDList(sldList, strategyTestResult: strategyTestResult)
    }

    /// Computes coverage for domain list from strategy test result across second-level domains (SLDs) (Extracts success domain tests according domain list in the parent strategy test result). The base function for the analytics ops
    /// - Parameters:
    ///   - sldList: Domain list (SLD) for coverage compute
    ///   - strategyTestResult: Strategy test result
    /// - Returns: Strategy coverage info
    public static func computeStrategyCoverageForSLDList(_ sldList: SBDDomainList, strategyTestResult: SBDStrategyTestResult) -> SBDStrategyCoverage {
        if (sldList.items.isEmpty) {
            return SBDStrategyCoverage(strategy: strategyTestResult.strategy, sldCoverage: [:])
        }
        var successTestCoverage: [String: Bool] = [:]
        // 1st stage - Retrieve success domain (SLD) tests from strategy test result
        for domain in strategyTestResult.successDomains {
            guard let sld = SBDDomainUtil.retrieveSLD(domain) else {
                continue
            }
            successTestCoverage[sld] = true
        }

        // 2nd stage - Match success domain (SLD) tests with defined domain list (SLDs)
        var coveredSlds = Set<String>()
        var uncoveredSlds = Set<String>()
        for sld in sldList.domains {
            if (successTestCoverage[sld] == true) {
                coveredSlds.insert(sld)
                continue
            }
            uncoveredSlds.insert(sld)
        }
        return SBDStrategyCoverage(strategy: strategyTestResult.strategy, sldCoverage: [
            true: coveredSlds,
            false: uncoveredSlds,
        ])
    }    
    
    fileprivate init() {}
}
