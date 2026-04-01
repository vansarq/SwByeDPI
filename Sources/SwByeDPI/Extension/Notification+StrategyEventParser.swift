//
//  Notification+DomainEventParser.swift
//  SwByeDPI
//
//  Created by developer on 05.03.2026.
//

import Foundation

extension Notification {
    
    /// Parses strategies from notification
    /// - Returns: Parse result
    public func tryParseStrategiesSetFromNotification() -> (Bool, Set<SBDStrategy>?)  {
        switch (self.name) {
        case Notification.Name.SBDStrategiesAdd, Notification.Name.SBDStrategiesDelete, Notification.Name.SBDStrategiesCollectionUpdate:
            guard let safeDict = self.userInfo as? [String: Any], let safeSet = safeDict["strategies"] as? Set<SBDStrategy> else {
                return (false, nil)
            }
            return (true, safeSet)
        default:
            return (false, nil)
        }
    }

    /// Parses strategy lists' IDs from notification
    /// - Returns: Parse result
    public func tryParseStrategyListIDsSetFromNotification() -> (Bool, Set<String>?) {
        if (self.name != .SBDStrategyListsDelete) {
            return (false, nil)
        }
        guard let safeDict = self.userInfo as? [String: Any], let safeSet = safeDict["strategies"] as? Set<String> else {
            return (false, nil)
        }
        return (true, safeSet)
    }
    
    /// Parses strategy lists' dictionary from notification
    /// - Returns: Parse result
    public func tryParseStrategyListsFromNotification() -> (Bool, [String: SBDStrategyList]?) {
        switch (self.name) {
        case Notification.Name.SBDStrategyListsAdd, Notification.Name.SBDStrategyListsUpdate, Notification.Name.SBDStrategyListsCollectionUpdate:
            guard let safeDict = self.userInfo as? [String: Any], let safeLists = safeDict["strategies"] as? [String: SBDStrategyList] else {
                return (false, nil)
            }
            return (true, safeLists)
        default:
            return (false, nil)
        }
    }
}
