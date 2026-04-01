//
//  SBDObjController.swift
//  SwByeDPI
//
//  Created by developer on 06.03.2026.
//

import Foundation

/// Abstract object control delegate (internal specification)
protocol SBDObjControlDelegate: AnyObject {
    
#if swift(>=5.5)
    /// Object type alias
    associatedtype ItemType: Hashable, Sendable
#else
    /// Object type alias
    associatedtype ItemType: Hashable
#endif
    
    /// New items added to collection event name
    var itemsAddEventPayloadKeyName: String {get}

    /// Exist items updated in collection event name
    var itemsUpdateEventPayloadKeyName: String {get}
    
    /// Deleted items from collection event name
    var itemsDeleteEventPayloadKeyName: String {get}
    
    /// Whole collection update event name
    var itemsCollectionUpdateEventPayloadKeyName: String {get}
    
    /// Items collection set
    var items: Set<ItemType> {get set}
    
    /// Items comparator func
    func itemsSortComparator(a: ItemType, b: ItemType) -> ComparisonResult
}

/// Abstract object control delegate (public specification)
public protocol SBDObjControlPublicDelegate: AnyObject {
    
#if swift(>=5.5)
    /// Object type alias
    associatedtype ItemType: Hashable, Sendable
#else
    /// Object type alias
    associatedtype ItemType: Hashable
#endif
    
    /// New items added to collection event
    var itemsAddEvent: Notification.Name {get}

    /// Exist items updated in collection event
    var itemsUpdateEvent: Notification.Name {get}

    /// Deleted items from collection event
    var itemsDeleteEvent: Notification.Name {get}

    /// Whole collection update event
    var itemsCollectionUpdateEvent: Notification.Name {get}

    /// Items collection set for outside access. Represents copy, which unlinked from internal collection set
    var uniqueItems: Set<ItemType> { get }

    /// Add items to collection
    func addItems(_ items: Set<ItemType>)

    /// Item exist check
    func itemExists(_ item: ItemType) -> Bool

    /// Delete items from collection
    func deleteItems(_ items: Set<ItemType>)
    
    /// Sorted items array retriever from the set
    func retrieveSortedUniqueItems() -> [ItemType]

    /// Remove all items data
    func clearData()
}

extension SBDObjControlDelegate {
    
    /// Sorted items array retrieve func
    /// - Parameters:
    ///   - items: Items collection set
    ///   - comparator: items sort comparator func
    /// - Returns: Sorted items array
    static func retrieveSortedUniqueItems(_ items: Set<ItemType>, comparator: (ItemType, ItemType) -> ComparisonResult) -> [ItemType] {
        var res = [ItemType].init(items)
        res.sort { a, b in
            return comparator(a,b) == .orderedAscending
        }
        return res
    }
    
}
