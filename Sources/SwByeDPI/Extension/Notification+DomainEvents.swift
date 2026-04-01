//
//  Notification+DomainEvents.swift
//  SwByeDPI
//
//  Created by developer on 01.03.2026.
//

import Foundation

extension Notification.Name {
    
    /// Domain lists add event. Payload (User info) contains "domains": [String: SBDDomainList]
    public static let SBDDomainListsAdd = Notification.Name(SBDDomainListController.domainListsAddEventName)
    
    /// Domains add event. Payload (User info) contains "domains": Set<String>
    public static let SBDDomainsAdd = Notification.Name(SBDDomainController.domainsAddEventName)
    
    /// Domain lists update event. Payload (User info) contains "domains: [String: SBDDomainList]
    public static let SBDDomainListsUpdate = Notification.Name(SBDDomainListController.domainListsUpdateEventName)
    
    /// Domains update event. Payload (User info) contains "domains": Set<String>
    public static let SBDDomainsUpdate = Notification.Name(SBDDomainController.domainsUpdateEventName)
    
    /// Domain lists delete event. Payload (User info) contains "domains": Set<String>
    public static let SBDDomainListsDelete = Notification.Name(SBDDomainListController.domainListsDeleteEventName)
    
    /// Domains delete event. Payload (User info) contains "domains": Set<String>
    public static let SBDDomainsDelete = Notification.Name(SBDDomainController.domainsDeleteEventName)
    
    /// Domains collection update event. Payload (User info) contains "domains": Set<String>
    public static let SBDDomainsCollectionUpdate = Notification.Name(SBDDomainController.domainsCollectionUpdateEventName)
    
    /// Domain lists collection update event. Payload (User info) contains "domains": [String: SBDDomainList]
    public static let SBDDomainListsCollectionUpdate = Notification.Name(SBDDomainListController.domainListsCollectionUpdateEventName)
}
