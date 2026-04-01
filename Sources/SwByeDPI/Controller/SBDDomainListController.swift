//
//  SBDDomainController.swift
//  SwByeDPI
//
//  Created by developer on 01.03.2026.
//

import Foundation

/// Domain lists controller
public class SBDDomainListController: SBDObjNamedListControllerImpl<String, SBDDomainList, String> {

    static let domainListsAddEventName = "SBDDomainListsAdd"
    static let domainListsUpdateEventName = "SBDDomainListsUpdate"
    static let domainListsDeleteEventName = "SBDDomainListsDelete"
    static let domainListsCollectionUpdateEventName = "SBDDomainListsCollectionUpdate"
    
    ///Unique domain lists
    public var domainLists: [String: SBDDomainList] {
        get {
            return uniqueItemLists
        }
    }

    public init() {
        super.init(itemNotificationPayloadKeyName: SBDDomainController.domainsPayloadKeyName, itemsAddNotificationEventName: SBDDomainController.domainsAddEventName, itemsUpdateNotificationEventName: SBDDomainController.domainsUpdateEventName, itemsDeleteNotificationEventName: SBDDomainController.domainsDeleteEventName, itemsCollectionUpdateNotificationEventName: SBDDomainController.domainsCollectionUpdateEventName, itemsSortCompareFunc: SBDDomainController.comparator, itemListsAddNotificationEventName: SBDDomainListController.domainListsAddEventName, itemListsUpdateNotificationEventName: SBDDomainListController.domainListsUpdateEventName, itemListsDeleteNotificationEventName: SBDDomainListController.domainListsDeleteEventName, itemListsCollectionUpdateNotificationEventName: SBDDomainListController.domainListsCollectionUpdateEventName, listKeyRetrieveFunc: { list in
            return list.id
        }, listItemsRetrieveFunc: { list in
            return list.items
        }, listNameMutateFunc: {list, newName in
            return SBDDomainList(name: newName, domains: Set(list.items))
        }, listItemsMutateFunc: { list, newItemsSet in
            return SBDDomainList(name: list.name, domains: newItemsSet)
        }, listsSortCompareFunc: SBDDomainListController.comparator)
    }
    
    /// Retrieves sorted by alphabet (ascending) domain lists' array
    /// - Parameter lists: Domain lists' dictionary without order
    /// - Returns: Sorted domain lists
    public static func retrieveSortedDomainLists(_ lists: [String: SBDDomainList]) -> [SBDDomainList] {
        return retrieveSortedLists(lists: lists, comparator: comparator)
    }
    
    /// Domain list sort comparator func
    /// - Parameters:
    ///   - listA: Domain list 'A'
    ///   - listB: Domain list 'B'
    /// - Returns: Lists comparison result
    static func comparator(listA: SBDDomainList, listB: SBDDomainList) -> ComparisonResult {
        return listA.name.compare(listB.name)
    }

}