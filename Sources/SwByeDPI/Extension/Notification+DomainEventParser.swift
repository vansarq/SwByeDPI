//
//  Notification+DomainEventParser.swift
//  SwByeDPI
//
//  Created by developer on 05.03.2026.
//

import Foundation

extension Notification {
    
    /// Parses domains from notification
    /// - Returns: Parse result
    public func tryParseDomainsSetFromNotification() -> (Bool, Set<String>?)  {
        switch (self.name) {
            case Notification.Name.SBDDomainsAdd, Notification.Name.SBDDomainsDelete, Notification.Name.SBDDomainsCollectionUpdate:
            guard let safeDict = self.userInfo as? [String: Any], let safeSet = safeDict[SBDDomainController.domainsPayloadKeyName] as? Set<String> else {
                return (false, nil)
            }
            return (true, safeSet)
        default:
            return (false, nil)
        }
    }

    /// Parses domain lists' IDs from notification
    /// - Returns: Parse result
    public func tryParseDomainListIDsSetFromNotification() -> (Bool, Set<String>?) {
        if (self.name != .SBDDomainListsDelete) {
            return (false, nil)
        }
        guard let safeDict = self.userInfo as? [String: Any], let safeSet = safeDict["domains"] as? Set<String> else {
            return (false, nil)
        }
        return (true, safeSet)
    }
    
    /// Parses domain lists dictionary from notification
    /// - Returns: Parse result
    public func tryParseDomainListsFromNotification() -> (Bool, [String: SBDDomainList]?) {
        switch (self.name) {
        case Notification.Name.SBDDomainListsAdd, Notification.Name.SBDDomainListsUpdate, Notification.Name.SBDDomainListsCollectionUpdate:
            guard let safeDict = self.userInfo as? [String: Any], let safeLists = safeDict["domains"] as? [String: SBDDomainList] else {
                return (false, nil)
            }
            return (true, safeLists)
        default:
            return (false, nil)
        }
    }
}
