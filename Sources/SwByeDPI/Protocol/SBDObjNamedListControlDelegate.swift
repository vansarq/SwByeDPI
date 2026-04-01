//
//  SBDObjListControllerDelegate.swift
//  SwByeDPI
//
//  Created by developer on 06.03.2026.
//

import Foundation

/// Abstract named list control delegate (internal specification)
protocol SBDObjNamedListControlDelegate: SBDObjControlDelegate {
    
#if swift(>=5.5)
    /// List key (ID) type alias
    associatedtype ItemsListKeyType: Hashable, Sendable
    /// List type alias
    associatedtype ItemsListType: Sendable, SBDNamedListDelegate
#else
    /// List key (ID) type alias
    associatedtype ItemsListKeyType: Hashable
    /// List type alias
    associatedtype ItemsListType: SBDNamedListDelegate
#endif
    
    /// New lists added to collection event name
    var itemListsAddEventPayloadKeyName: String {get}
    
    /// Exist lists updated in collection event name
    var itemListsUpdateEventPayloadKeyName: String {get}
    
    /// Deleted list items from the collection event name
    var itemListsDeleteEventPayloadKeyName: String {get}
    
    /// List collection update event name
    var itemListsCollectionUpdateEventPayloadKeyName: String {get}
    
    /// Lists dictionary. Key is list ID, value - the list itself
    var itemLists: [ItemsListKeyType: ItemsListType] {get set}
    
    /// List ID retriever func
    /// - Parameters:
    ///   - list: Named list
    /// - Returns: List ID
    func listKeyRetriever(_ list: ItemsListType) -> ItemsListKeyType

    /// List items retriever func
    /// - Parameters:
    ///   - list: Named list
    /// - Returns: List items
    func listItemsRetriever(_ list: ItemsListType) -> Set<ItemType>

    /// List rename func
    /// - Parameters:
    ///   - list: Named list
    ///   - newName: New name for list
    /// - Returns: Renamed list
    func listNameMutator(_ list: ItemsListType, newName: String) -> ItemsListType

    // List items update func
    /// - Parameters:
    ///   - list: Named list
    ///   - newItemsSet: New items for list
    /// - Returns: The list with updated items
    func listItemsMutator(_ list: ItemsListType, newItemsSet: Set<ItemType>) -> ItemsListType

    /// Lists sort comparator func
    func listsSortComparator(a: ItemsListType, b: ItemsListType) -> ComparisonResult
}

/// Abstract named list control delegate (public specification)
public protocol SBDObjNamedListControlPublicDelegate: SBDObjControlPublicDelegate {
    
#if swift(>=5.5)
    /// List key (ID) type alias
    associatedtype ItemsListKeyType: Hashable, Sendable
    /// List type alias
    associatedtype ItemsListType: Sendable, SBDNamedListDelegate
#else
    /// List key (ID) type alias
    associatedtype ItemsListKeyType: Hashable
    /// List type alias
    associatedtype ItemsListType: SBDNamedListDelegate
#endif
    
    /// New lists added to collection event
    var itemListsAddEvent: Notification.Name {get}

    /// Exist lists updated in collection event
    var itemListsUpdateEvent: Notification.Name {get}

    /// Deleted list items from the collection event
    var itemListsDeleteEvent: Notification.Name {get}

    /// List collection update event
    var itemListsCollectionUpdateEvent: Notification.Name {get}

    /// Lists dictionary for outside access. Represents copy, which unlinked from internal collection
    var uniqueItemLists: [ItemsListKeyType: ItemsListType] {get}
    
    /// Add named lists to collection
    func addListItems(_ lists: [ItemsListType])
    
    /// Add items to named list by its key
    func addItemsToList(listKey: ItemsListKeyType, items: Set<ItemType>)
    
    /// List exist check
    func listExists(id: ItemsListKeyType) -> Bool
    
    /// Delete lists from collection by keys
    func deleteItemLists(listKeys: Set<ItemsListKeyType>)
    
    /// Delete items from the defined by key list
    func deleteItemsFromList(listKey: ItemsListKeyType, items: Set<ItemType>)
    
    /// Retrieve unique items dictionary with links to lists-containers, where they present
    func retrieveItemLinkWithList() -> [ItemType: Set<ItemsListKeyType>]
    
    /// Sorted items array retriever from the defined list
    func retrieveSortedListItems(listKey: ItemsListKeyType) -> [ItemType]
    
    /// Sorted lists array retriever from the dictionary
    func retrieveSortedLists() -> [ItemsListType]
    
    /// Rename list
    func renameList(listKey: ItemsListKeyType, newName: String) -> SBDError?
    
    /// Insert or update items to the defined list
    func updateItemsInList(listKey: ItemsListKeyType, items: Set<ItemType>) -> SBDError?
    
    /// Remove all data
    func clearData()
}

extension SBDObjNamedListControlDelegate {
    
    /// Sorted lists array retrieve func
    /// - Parameters:
    ///   - lists: Named lists dictionary
    ///   - comparator: Named list sort comparator func
    /// - Returns: Sorted lists
    static func retrieveSortedLists(lists: [ItemsListKeyType: ItemsListType], comparator: (ItemsListType, ItemsListType) -> ComparisonResult) -> [ItemsListType] {
        var res = [ItemsListType].init(lists.values)
        res.sort { a, b in
            return comparator(a,b) == .orderedAscending
        }
        return res
    }
    
}
