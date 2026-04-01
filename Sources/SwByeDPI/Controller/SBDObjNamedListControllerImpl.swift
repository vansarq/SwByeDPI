
import Foundation

/// Generic named list controller implementation
public class SBDObjNamedListControllerImpl<K,T,X>: SBDObjControllerImpl<X>, SBDObjNamedListControlDelegate, SBDObjNamedListControlPublicDelegate where K: Sendable, K: Hashable, T: Sendable, T: SBDNamedListDelegate, X: Sendable, X:Hashable {

    public typealias ItemsListKeyType = K
    public typealias ItemsListType = T

    fileprivate let itemListsAddNotificationEventName: String
    fileprivate let itemListsUpdateNotificationEventName: String
    fileprivate let itemListsDeleteNotificationEventName: String
    fileprivate let itemListsCollectionUpdateNotificationEventName: String

    fileprivate let listKeyRetrieveFunc: (T) -> K
    fileprivate let listItemsRetrieveFunc: (T) -> Set<X>
    fileprivate let listNameMutateFunc: (T, String) -> T
    fileprivate let listItemsMutateFunc: (T, Set<X>) -> T
    fileprivate let listsSortCompareFunc: (T, T) -> ComparisonResult
    
    fileprivate var _itemLists: [K : T]
    
    var itemLists: [K : T] {
        get {
            return _itemLists
        }
        set {
            _itemLists = newValue
        }
    }

    public var uniqueItemLists: [K: T] {
        get {
            var res: [ItemsListKeyType: ItemsListType] = [:]
            for entry in itemLists {
                res[entry.key] = entry.value
            }
            return res
        }
    }

    public var itemListsAddEvent: Notification.Name {
        get {
            return Notification.Name(rawValue: itemListsAddNotificationEventName)
        }
    }
    var itemListsAddEventPayloadKeyName: String {
        get {
            return itemNotificationPayloadKeyName
        }
    }
    
    public var itemListsUpdateEvent: Notification.Name {
        get {
            return Notification.Name(rawValue: itemListsUpdateNotificationEventName)
        }
    }
    var itemListsUpdateEventPayloadKeyName: String {
        get {
            return itemNotificationPayloadKeyName
        }
    }
    
    public var itemListsDeleteEvent: Notification.Name {
        get {
            return Notification.Name(rawValue: itemListsDeleteNotificationEventName)
        }
    }
    var itemListsDeleteEventPayloadKeyName: String {
        get {
            return itemNotificationPayloadKeyName
        }
    }
    
    public var itemListsCollectionUpdateEvent: Notification.Name {
        get {
            return Notification.Name(rawValue: itemListsCollectionUpdateNotificationEventName)
        }
    }
    var itemListsCollectionUpdateEventPayloadKeyName: String {
        get {
            return itemNotificationPayloadKeyName
        }
    }

    public init(itemNotificationPayloadKeyName: String, itemsAddNotificationEventName: String, itemsUpdateNotificationEventName: String, itemsDeleteNotificationEventName: String, itemsCollectionUpdateNotificationEventName: String, itemsSortCompareFunc: @escaping (X, X) -> ComparisonResult, itemListsAddNotificationEventName: String, itemListsUpdateNotificationEventName: String, itemListsDeleteNotificationEventName: String, itemListsCollectionUpdateNotificationEventName: String, listKeyRetrieveFunc: @escaping (T) -> K, listItemsRetrieveFunc: @escaping (T) -> Set<X>, listNameMutateFunc: @escaping (T, String) -> T, listItemsMutateFunc: @escaping (T, Set<X>) -> T, listsSortCompareFunc: @escaping (T, T) -> ComparisonResult) {
        _itemLists = [:]
        self.itemListsAddNotificationEventName = itemListsAddNotificationEventName
        self.itemListsUpdateNotificationEventName = itemListsUpdateNotificationEventName
        self.itemListsDeleteNotificationEventName = itemListsDeleteNotificationEventName
        self.itemListsCollectionUpdateNotificationEventName = itemListsCollectionUpdateNotificationEventName
        
        self.listKeyRetrieveFunc = listKeyRetrieveFunc
        self.listItemsRetrieveFunc = listItemsRetrieveFunc
        self.listNameMutateFunc = listNameMutateFunc
        self.listItemsMutateFunc = listItemsMutateFunc
        self.listsSortCompareFunc = listsSortCompareFunc
        super.init(itemNotificationPayloadKeyName: itemNotificationPayloadKeyName, itemsAddNotificationEventName: itemsAddNotificationEventName, itemsUpdateNotificationEventName: itemsUpdateNotificationEventName, itemsDeleteNotificationEventName: itemsDeleteNotificationEventName, itemsCollectionUpdateNotificationEventName: itemsCollectionUpdateNotificationEventName, itemsSortCompareFunc: itemsSortCompareFunc)
    }

    func listKeyRetriever(_ list: T) -> K {
        listKeyRetrieveFunc(list)
    }

    func listItemsRetriever(_ list: T) -> Set<X> {
        listItemsRetrieveFunc(list)
    }

    func listItemsMutator(_ list: T, newItemsSet: Set<X>) -> T {
        return listItemsMutateFunc(list, newItemsSet)
    }
    
    func listNameMutator(_ list: T, newName: String) -> T {
        return listNameMutateFunc(list, newName)
    }
    
    func listsSortComparator(a: T, b: T) -> ComparisonResult {
        return listsSortCompareFunc(a,b)
    }
    
    public func addListItems(_ lists: [T]) {
        if (lists.isEmpty) {
            return
        }
        var addedLists: [ItemsListKeyType: ItemsListType] = [:]
        var addedUniqueItems = Set<ItemType>()
        for list in lists {
            for item in listItemsRetriever(list) {
                if (addedUniqueItems.contains(item)) {
                    continue
                }
                addedUniqueItems.insert(item)
            }
            if (addedLists[listKeyRetriever(list)] == nil) {
                addedLists[listKeyRetriever(list)] = list
            }
            itemLists[listKeyRetriever(list)] = list
        }
        addItems(addedUniqueItems)
        notifyItemListsAdd(addedLists)
        notifyItemListsCollectionUpdate(uniqueItemLists)
    }
    
    public func addItemsToList(listKey: K, items: Set<X>) {
        guard let safeList = itemLists[listKey] else {
            return
        }
        var resItems = Set<ItemType>(listItemsRetriever(safeList))
        for item in items {
            if (resItems.contains(item)) {
                resItems.remove(item)
            }
            resItems.insert(item)
        }
        let updList = listItemsMutator(safeList, newItemsSet: resItems)
        itemLists[listKey] = updList
        addItems(items)
        notifyItemListsAdd([listKey: updList])
        notifyItemListsCollectionUpdate(uniqueItemLists)
    }
    
    public func listExists(id: K) -> Bool {
        return itemLists[id] != nil
    }
    
    public func deleteItemLists(listKeys: Set<K>) {
        if (itemLists.isEmpty) {
            return
        }
        var removedListKeys = Set<ItemsListKeyType>()
        var removedItems = Set<ItemType>()
        for key in listKeys {
            guard let removedList = itemLists.removeValue(forKey: key) else {
                continue
            }
            removedListKeys.insert(key)
            for item in listItemsRetriever(removedList) {
                removedItems.insert(item)
            }
        }
        if (removedListKeys.isEmpty) {
            return
        }
        var removedUniqueItems = Set<ItemType>()
        for removedItem in removedItems {
            var found = false
            for list in itemLists.values {
                if (!listItemsRetriever(list).contains(removedItem)) {
                    continue
                }
                found = true
                break
            }
            if (found) {
                continue
            }
            removedUniqueItems.insert(removedItem)
        }
        if (!removedUniqueItems.isEmpty) {
            deleteItems(removedUniqueItems)
        }
        notifyItemListsDelete(removedListKeys)
        notifyItemListsCollectionUpdate(uniqueItemLists)
    }
    
    public func deleteItemsFromList(listKey: K, items: Set<X>) {
        guard let safeList = itemLists[listKey] else {
            return
        }
        var resItems = Set<ItemType>(listItemsRetriever(safeList))
        if (resItems.isEmpty) {
            return
        }
        var removedItems = Set<ItemType>()
        for item in items {
            guard let removedDomain = resItems.remove(item) else {
                continue
            }
            removedItems.insert(removedDomain)
        }
        if (removedItems.isEmpty) {
            return
        }
        let updList = listItemsMutator(safeList, newItemsSet: resItems)
        itemLists[listKey] = updList
        var removedUniqueItems = Set<ItemType>()
        for removeItem in removedItems {
            var found = false
            for entry in itemLists {
                if (entry.key == listKey) {
                    continue
                }
                if (!listItemsRetriever(entry.value).contains(removeItem)) {
                    continue
                }
                found = true
                break
            }
            if (found) {
                continue
            }
            removedUniqueItems.insert(removeItem)
        }
        if (!removedUniqueItems.isEmpty) {
            deleteItems(removedUniqueItems)
        }
        notifyItemListsUpdate([listKey: updList])
        notifyItemListsCollectionUpdate(uniqueItemLists)
    }
    
    public func retrieveItemLinkWithList() -> [X: Set<K>] {
        var res: [ItemType: Set<ItemsListKeyType>] = [:]
        for entry in itemLists {
            for item in listItemsRetriever(entry.value) {
                guard let _ = res[item] else {
                    res[item] = Set<ItemsListKeyType>([entry.key])
                    continue
                }
                res[item]?.insert(entry.key)
            }
        }
        return res
    }
    
    public func retrieveSortedListItems(listKey: K) -> [X] {
        guard let safeList = itemLists[listKey] else {
            return []
        }
        let itemsSet = listItemsRetriever(safeList)
        return SBDObjNamedListControllerImpl.retrieveSortedUniqueItems(itemsSet, comparator: itemsSortComparator)
    }
    
    public func retrieveSortedLists() -> [T] {
        return SBDObjNamedListControllerImpl.retrieveSortedLists(lists: itemLists, comparator: listsSortComparator)
    }
    
    public func renameList(listKey: K, newName: String) -> SBDError? {
        guard let safeStockList = itemLists[listKey] else {
            return .listNotFound(id: String(describing: listKey))
        }
        let updList = listNameMutator(safeStockList, newName: newName)
        let updKey = listKeyRetriever(updList)
        if let _ = itemLists[updKey] {
            return .listDuplicate(id: String(describing: updKey))
        }
        itemLists.removeValue(forKey: listKey)
        itemLists[updKey] = updList
        notifyItemListsDelete(Set([
            listKey
        ]))
        notifyItemListsAdd([
            updKey: updList
        ])
        notifyItemListsCollectionUpdate(uniqueItemLists)
        return nil
    }
    
    public func updateItemsInList(listKey: K, items: Set<X>) -> SBDError? {
        guard let safeStockList = itemLists[listKey] else {
            return .listNotFound(id: String(describing: listKey))
        }
        let stockListItems = listItemsRetriever(safeStockList)
        let updList = listItemsMutator(safeStockList, newItemsSet: items)
        itemLists[listKey] = updList
        let updListItems = listItemsRetrieveFunc(updList)
        var addSet = Set<ItemType>()
        var removeSet = Set<ItemType>()
        for updListItem in updListItems {
            if (stockListItems.contains(updListItem)) {
                continue
            }
            addSet.insert(updListItem)
        }
        for stockListItem in stockListItems {
            if (updListItems.contains(stockListItem)) {
                continue
            }
            removeSet.insert(stockListItem)
        }
        var addedUniqueItems = Set<ItemType>()
        for item in addSet {
            if (items.contains(item)) {
                continue
            }
            addedUniqueItems.insert(item)
        }
        var removedUniqueItems = Set<ItemType>()
        for removeItem in removeSet {
            var found = false
            for entry in itemLists {
                if (entry.key == listKey) {
                    continue
                }
                if (!listItemsRetriever(entry.value).contains(removeItem)) {
                    continue
                }
                found = true
                break
            }
            if (found) {
                continue
            }
            removedUniqueItems.insert(removeItem)
        }
        if (!addedUniqueItems.isEmpty) {
            addItems(addedUniqueItems)
        }
        if (!removedUniqueItems.isEmpty) {
            deleteItems(removedUniqueItems)
        }
        notifyItemListsUpdate([listKey: updList])
        notifyItemListsCollectionUpdate(uniqueItemLists)
        return nil
    }
    
    public override func clearData() {
        super.clearData()
        notifyItemListsDelete(Set(itemLists.keys))
        itemLists.removeAll()
        notifyItemListsCollectionUpdate([:])
    }

}

extension SBDObjNamedListControllerImpl {
    func notifyItemListsAdd(_ itemLists: [ItemsListKeyType: ItemsListType]) {
        sendNotification(name: itemListsAddEvent, payloadKey: itemListsAddEventPayloadKeyName, payload: itemLists)
    }
    
    func notifyItemListsUpdate(_ itemLists: [ItemsListKeyType: ItemsListType]) {
        sendNotification(name: itemListsUpdateEvent, payloadKey: itemListsUpdateEventPayloadKeyName, payload: itemLists)
    }
    
    func notifyItemListsDelete(_ listIDs: Set<ItemsListKeyType>) {
        let notification = Notification(name: itemListsUpdateEvent, userInfo: [
            itemListsUpdateEventPayloadKeyName: listIDs
        ])
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyItemListsCollectionUpdate(_ itemLists: [ItemsListKeyType: ItemsListType]) {
        sendNotification(name: itemListsCollectionUpdateEvent, payloadKey: itemListsCollectionUpdateEventPayloadKeyName, payload: itemLists)
    }
    
    fileprivate func sendNotification(name: Notification.Name, payloadKey: String, payload: [ItemsListKeyType: ItemsListType]) {
        let notification = Notification(name: name, userInfo: [
            payloadKey: payload
        ])
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
}
