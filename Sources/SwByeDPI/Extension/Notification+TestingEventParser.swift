//
//  Notification+DomainEventParser.swift
//  SwByeDPI
//
//  Created by developer on 05.03.2026.
//

import Foundation

extension Notification {
    
    /// Parses testing global progress from notification
    /// - Returns: Parse result
    public func tryParseTestingProgressFromNotification() -> (Bool, (tested: Int, total: Int)?)  {
        switch (self.name) {
        case Notification.Name.SBDTestingProgressUpdate, Notification.Name.SBDTestingStrategyDomainsProgressUpdate, Notification.Name.SBDTestingDomainProgress:
            guard let safeDict = self.userInfo as? [String: Any], let safeTestedCount = safeDict["tested"] as? Int, let safeTotalCount = safeDict["total"] as? Int else {
                return (false, nil)
            }
            return (true, (tested: safeTestedCount, total: safeTotalCount))
        default:
            return (false, nil)
        }
    }
    
    /// Parses domain testing progress (for strategy) from notification
    /// - Returns: Parse result
    public func tryParseTestingDomainProgressFromNotification() -> (Bool, (success: UInt8, fail: UInt8, tested: Int, total: Int)?)  {
        if (self.name != .SBDTestingDomainProgress) {
            return (false, nil)
        }
        guard let safeProgressInfo = tryParseTestingProgressFromNotification().1 else {
            return (false, nil)
        }
        guard let safeDict = self.userInfo as? [String: Any], let safeSuccessCount = safeDict["success"] as? UInt8, let safeFailCount = safeDict["fail"] as? UInt8 else {
            return (false, nil)
        }
        return (true, (success: safeSuccessCount, fail: safeFailCount, tested: safeProgressInfo.tested, total: safeProgressInfo.total))
    }
    
    /// Parses currently testing strategy from notification
    /// - Returns: Parse result
    public func tryParseTestingStrategyFromNotification() -> (Bool, SBDStrategy?) {
        switch (self.name) {
        case Notification.Name.SBDNoTestingStrategy:
            return (true, nil)
        case Notification.Name.SBDTestingStrategyUpdate:
            guard let safeDict = self.userInfo as? [String: Any], let safeStrategy = safeDict["strategy"] as? SBDStrategy else {
                return (false, nil)
            }
            return (true, safeStrategy)
        default:
            return (false, nil)
        }
    }
    
    /// Parses tested strategy and its test result from notification
    /// - Returns: Parse result
    public func tryParseTestedStrategyFromNotification() -> (Bool, SBDStrategyTestResult?) {
        if (self.name != Notification.Name.SBDTestedStrategy) {
            return (false, nil)
        }
        guard let safeDict = self.userInfo as? [String: Any], let safeTestResult = safeDict["result"] as? SBDStrategyTestResult else {
            return (false, nil)
        }
        return (true, safeTestResult)
    }
    
    /// Parses tested domain (for strategy) and its test result from notification
    /// - Returns: Parse result
    public func tryParseTestedStrategyDomainFromNotification() -> (Bool, SBDDomainTestResult?) {
        if (self.name != Notification.Name.SBDTestedStrategyDomain) {
            return (false, nil)
        }
        guard let safeDict = self.userInfo as? [String: Any], let safeTestResult = safeDict["result"] as? SBDDomainTestResult else {
            return (false, nil)
        }
        return (true, safeTestResult)
    }
}
