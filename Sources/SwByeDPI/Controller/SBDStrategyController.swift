//
//  SBDStrategyController.swift
//  SwByeDPI
//
//  Created by developer on 01.03.2026.
//

import Foundation

/// Strategy controller
public class SBDStrategyController: SBDObjControllerImpl<SBDStrategy> {

    static let strategiesPayloadKeyName = "strategies"
    static let strategiesAddEventName = "SBDStrategiesAdd"
    static let strategiesUpdateEventName = "SBDStrategiesUpdate"
    static let strategiesDeleteEventName = "SBDStrategiesDelete"
    static let strategiesCollectionUpdateEventName = "SBDStrategiesCollectionUpdate"
    
    /// Unique strategies
    public var strategies: Set<SBDStrategy> {
        get {
            return uniqueItems
        }
    }

    public init() {
        super.init(itemNotificationPayloadKeyName: SBDStrategyController.strategiesPayloadKeyName, itemsAddNotificationEventName: SBDStrategyController.strategiesAddEventName, itemsUpdateNotificationEventName: SBDStrategyController.strategiesUpdateEventName, itemsDeleteNotificationEventName: SBDStrategyController.strategiesDeleteEventName, itemsCollectionUpdateNotificationEventName: SBDStrategyController.strategiesCollectionUpdateEventName, itemsSortCompareFunc: SBDStrategyController.comparator)
    }
    
    /// Retrieves sorted by alphabet (ascending) strategies array
    /// - Parameter strategies: Strategies set without order
    /// - Returns: Sorted strategies
    public static func retrieveSortedStrategies(_ strategies: Set<SBDStrategy>) -> [SBDStrategy] {
        return retrieveSortedUniqueItems(strategies, comparator: comparator)
    }
    
    /// Strategy sort comparator func
    /// - Parameters:
    ///   - strategyA: Strategy 'A'
    ///   - strategyB: Strategy 'B'
    /// - Returns: Strategies comparison result
    static func comparator(strategyA: SBDStrategy, strategyB: SBDStrategy) -> ComparisonResult {
        return strategyA.cmdArgsLine.compare(strategyB.cmdArgsLine)
    }

}
