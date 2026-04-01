
import Foundation

/// Generic object controller implementation
public class SBDObjControllerImpl<T>: SBDObjControlDelegate, SBDObjControlPublicDelegate where T: Hashable, T: Sendable {

    public typealias ItemType = T
    
    let itemNotificationPayloadKeyName: String
    fileprivate let itemsAddNotificationEventName: String
    fileprivate let itemsUpdateNotificationEventName: String
    fileprivate let itemsDeleteNotificationEventName: String
    fileprivate let itemsCollectionUpdateNotificationEventName: String
    
    fileprivate let itemsSortCompareFunc: (T, T) -> ComparisonResult

    fileprivate var _items: Set<T>

    var items: Set<T> {
        get {
            return _items
        }
        set {
            _items = newValue
        }
    }

    public var uniqueItems: Set<T> {
        get {
            return Set<T>(items)
        }
    }

    public var itemsAddEvent: Notification.Name {
        get {
            return Notification.Name(rawValue: itemsAddNotificationEventName)
        }
    }
    var itemsAddEventPayloadKeyName: String {
        get {
            return itemNotificationPayloadKeyName
        }
    }
    
    public var itemsUpdateEvent: Notification.Name {
        get {
            return Notification.Name(rawValue: itemsUpdateNotificationEventName)
        }
    }
    var itemsUpdateEventPayloadKeyName: String {
        get {
            return itemNotificationPayloadKeyName
        }
    }
    
    public var itemsDeleteEvent: Notification.Name {
        get {
            return Notification.Name(rawValue: itemsDeleteNotificationEventName)
        }
    }
    var itemsDeleteEventPayloadKeyName: String {
        get {
            return itemNotificationPayloadKeyName
        }
    }
    
    public var itemsCollectionUpdateEvent: Notification.Name {
        get {
            return Notification.Name(rawValue: itemsCollectionUpdateNotificationEventName)
        }
    }
    var itemsCollectionUpdateEventPayloadKeyName: String {
        get {
            return itemNotificationPayloadKeyName
        }
    }
    
    public init(itemNotificationPayloadKeyName: String, itemsAddNotificationEventName: String, itemsUpdateNotificationEventName: String, itemsDeleteNotificationEventName: String, itemsCollectionUpdateNotificationEventName: String, itemsSortCompareFunc: @escaping (T, T) -> ComparisonResult) {
        _items = Set<T>()
        self.itemNotificationPayloadKeyName = itemNotificationPayloadKeyName
        self.itemsAddNotificationEventName = itemsAddNotificationEventName
        self.itemsUpdateNotificationEventName = itemsUpdateNotificationEventName
        self.itemsDeleteNotificationEventName = itemsDeleteNotificationEventName
        self.itemsCollectionUpdateNotificationEventName = itemsCollectionUpdateNotificationEventName
        self.itemsSortCompareFunc = itemsSortCompareFunc
    }
    
    func itemsSortComparator(a: T, b: T) -> ComparisonResult {
        return itemsSortCompareFunc(a,b)
    }
    
    public func addItems(_ items: Set<T>) {
        var added = Set<ItemType>()
        var updated = Set<ItemType>()
        for item in items {
            if (self.items.remove(item) != nil) {
                updated.insert(item)
            } else {
                added.insert(item)
            }
            self.items.insert(item)
        }
        if (added.isEmpty && updated.isEmpty) {
            return
        }
        if (!added.isEmpty) {
            notifyItemsAdd(added)
        }
        if (!updated.isEmpty) {
            notifyItemsUpdate(updated)
        }
        notifyItemsCollectionUpdate(uniqueItems)
    }
    
    public func itemExists(_ item: T) -> Bool {
        return items.contains(item)
    }
    
    public func deleteItems(_ items: Set<T>) {
        if (self.items.isEmpty) {
            return
        }
        var deleted = Set<ItemType>()
        for item in items {
            guard let removed = self.items.remove(item) else {
                continue
            }
            deleted.insert(removed)
        }
        if (deleted.isEmpty) {
            return
        }
        notifyItemsDelete(deleted)
        notifyItemsCollectionUpdate(uniqueItems)
    }
    
    public func retrieveSortedUniqueItems() -> [T] {
        return SBDObjControllerImpl.retrieveSortedUniqueItems(items, comparator: itemsSortComparator)
    }
    
    public func clearData() {
        notifyItemsDelete(uniqueItems)
        items.removeAll()
        notifyItemsCollectionUpdate(Set<T>())
    }
}

extension SBDObjControllerImpl {

    func notifyItemsAdd(_ items: Set<ItemType>) {
        sendNotification(name: itemsAddEvent, payloadKey: itemsAddEventPayloadKeyName, payload: items)
    }
    
    func notifyItemsUpdate(_ items: Set<ItemType>) {
        sendNotification(name: itemsUpdateEvent, payloadKey: itemsUpdateEventPayloadKeyName, payload: items)
    }
    
    func notifyItemsDelete(_ items: Set<ItemType>) {
        sendNotification(name: itemsDeleteEvent, payloadKey: itemsDeleteEventPayloadKeyName, payload: items)
    }
    
    func notifyItemsCollectionUpdate(_ items: Set<ItemType>) {
        sendNotification(name: itemsCollectionUpdateEvent, payloadKey: itemsCollectionUpdateEventPayloadKeyName, payload: items)
    }
    
    fileprivate func sendNotification(name: Notification.Name, payloadKey: String, payload: Set<ItemType>) {
        let notification = Notification(name: name, userInfo: [
            payloadKey: payload
        ])
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }

}
