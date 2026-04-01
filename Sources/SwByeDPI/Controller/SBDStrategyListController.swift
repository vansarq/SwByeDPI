//
//  SBDStrategyListController.swift
//  SwByeDPI
//
//  Created by developer on 01.03.2026.
//

import Foundation

/// Strategiy lists controller
public class SBDStrategyListController: SBDObjNamedListControllerImpl<String, SBDStrategyList, SBDStrategy> {

    static let strategyListsAddEventName = "SBDStrategyListsAdd"
    static let strategyListsUpdateEventName = "SBDStrategyListsUpdate"
    static let strategyListsDeleteEventName = "SBDStrategyListsDelete"
    static let strategyListsCollectionUpdateEventName = "SBDStrategyListsCollectionUpdate"
    
    /// Unique strategy lists
    public var strategyLists: [String: SBDStrategyList] {
        get {
            return uniqueItemLists
        }
    }

    public init() {
        super.init(itemNotificationPayloadKeyName: SBDStrategyController.strategiesPayloadKeyName, itemsAddNotificationEventName: SBDStrategyController.strategiesAddEventName, itemsUpdateNotificationEventName: SBDStrategyController.strategiesUpdateEventName, itemsDeleteNotificationEventName: SBDStrategyController.strategiesDeleteEventName, itemsCollectionUpdateNotificationEventName: SBDStrategyController.strategiesCollectionUpdateEventName, itemsSortCompareFunc: SBDStrategyController.comparator, itemListsAddNotificationEventName: SBDStrategyListController.strategyListsAddEventName, itemListsUpdateNotificationEventName: SBDStrategyListController.strategyListsUpdateEventName, itemListsDeleteNotificationEventName: SBDStrategyListController.strategyListsDeleteEventName, itemListsCollectionUpdateNotificationEventName: SBDStrategyListController.strategyListsCollectionUpdateEventName, listKeyRetrieveFunc: { list in
            return list.id
        }, listItemsRetrieveFunc: { list in
            return list.items
        }, listNameMutateFunc: { list, newName in
            return SBDStrategyList(name: newName, strategies: Set(list.items))
        }, listItemsMutateFunc: { list, newItemsSet in
            return SBDStrategyList(name: list.name, strategies: newItemsSet)
        }, listsSortCompareFunc: SBDStrategyListController.comparator)
    }

    /// Retrieves sorted by alphabet (ascending) strategy lists' array
    /// - Parameter lists: Strategy lists' dictionary without order
    /// - Returns: Sorted strategy lists
    public static func retrieveSortedStrategyLists(_ lists: [String: SBDStrategyList]) -> [SBDStrategyList] {
        return retrieveSortedLists(lists: lists, comparator: comparator)
    }
    
    /// Strategy list sort comparator func
    /// - Parameters:
    ///   - listA: Strategy list 'A'
    ///   - listB: Strategy list 'B'
    /// - Returns: Lists comparison result
    static func comparator(listA: SBDStrategyList, listB: SBDStrategyList) -> ComparisonResult {
        return listA.name.compare(listB.name)
    }
}
