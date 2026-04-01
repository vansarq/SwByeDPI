//
//  Notification+DomainEvents.swift
//  SwByeDPI
//
//  Created by developer on 01.03.2026.
//

import Foundation

extension Notification.Name {
    
    /// Strategy lists add event. Payload (User info) contains "strategies": [String: SBDStrategyList]
    public static let SBDStrategyListsAdd = Notification.Name(SBDStrategyListController.strategyListsAddEventName)
    
    /// Strategies add event. Payload (User info) contains "strategies": Set<SBDStrategy>
    public static let SBDStrategiesAdd = Notification.Name(SBDStrategyController.strategiesAddEventName)
    
    /// Strategy lists update event. Payload (User info) contains "strategies": [String: SBDStrategyList]
    public static let SBDStrategyListsUpdate = Notification.Name(SBDStrategyListController.strategyListsUpdateEventName)
    
    /// Strategies update event. Payload (User info) contains "strategies": Set<SBDStrategy>
    public static let SBDStrategiesUpdate = Notification.Name(SBDStrategyController.strategiesUpdateEventName)
    
    /// Strategy lists delete event. Payload (User info) contains "strategies": Set<String>
    public static let SBDStrategyListsDelete = Notification.Name(SBDStrategyListController.strategyListsDeleteEventName)
    
    /// Strategies delete event. Payload (User info) contains "strategies": Set<SBDStrategy>
    public static let SBDStrategiesDelete = Notification.Name(SBDStrategyController.strategiesDeleteEventName)
    
    /// Strategy lists collection update event. Payload (User info) contains "strategies": [String: SBDStrategyList]
    public static let SBDStrategyListsCollectionUpdate = Notification.Name(SBDStrategyListController.strategyListsCollectionUpdateEventName)
    
    /// Strategies collection update event. Payload (User info) contains "strategies": Set<SBDStrategy>
    public static let SBDStrategiesCollectionUpdate = Notification.Name(SBDStrategyController.strategiesCollectionUpdateEventName)
}
