//
//  SBDDomainController.swift
//  SwByeDPI
//
//  Created by developer on 01.03.2026.
//

import Foundation

/// Domains controller
public class SBDDomainController: SBDObjControllerImpl<String> {

    static let domainsPayloadKeyName = "domains"
    static let domainsAddEventName = "SBDDomainsAdd"
    static let domainsUpdateEventName = "SBDDomainsUpdate"
    static let domainsCollectionUpdateEventName = "SBDDomainsCollectionUpdate"
    static let domainsDeleteEventName = "SBDDomainsDelete"
    
    ///Unique domains
    public var domains: Set<String> {
        get {
            return uniqueItems
        }
    }

    public init() {
        super.init(itemNotificationPayloadKeyName: SBDDomainController.domainsPayloadKeyName, itemsAddNotificationEventName: SBDDomainController.domainsAddEventName, itemsUpdateNotificationEventName: SBDDomainController.domainsUpdateEventName, itemsDeleteNotificationEventName: SBDDomainController.domainsDeleteEventName, itemsCollectionUpdateNotificationEventName: SBDDomainController.domainsCollectionUpdateEventName, itemsSortCompareFunc: SBDDomainController.comparator)
    }
    
    /// Retrieves sorted by alphabet (ascending) domains array
    /// - Parameter domains: Domains set without order
    /// - Returns: Sorted domains
    public static func retrieveSortedDomains(_ domains: Set<String>) -> [String] {
        return retrieveSortedUniqueItems(domains, comparator: comparator)
    }
    
    /// Domain sort comparator func
    /// - Parameters:
    ///   - domainA: Domain 'A'
    ///   - domainB: Domain 'B'
    /// - Returns: Domains comparison result
    static func comparator(domainA: String, domainB: String) -> ComparisonResult {
        return domainA.compare(domainB)
    }
}