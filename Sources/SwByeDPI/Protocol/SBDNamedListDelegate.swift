//
//  SBDStrategyList.swift
//  SwByeDPI
//
//  Created by developer on 19.02.2026.
//

import Foundation

#if swift(>=5.5)
/// Named object list protocol
public protocol SBDNamedListDelegate: Sendable {
    
    /// List item type alias
    associatedtype ListItemType: Hashable, Sendable
    
    /// List ID
    var id: String {get}
    /// List 'human' name
    var name: String {get}
    /// Items list
    var items: Set<ListItemType> {get}
    /// Items list raw
    var rawItems: [String] {get}
}
#else
/// Named object list protocol
public protocol SBDNamedListDelegate {
    
    /// List item type alias
    associatedtype ListItemType: Hashable
    
    /// List ID
    var id: String {get}
    /// List 'human' name
    var name: String {get}
    /// Items list
    var items: Set<ListItemType> {get}
    /// Items list raw
    var rawItems: [String] {get}
}
#endif

public extension SBDNamedListDelegate {
    
    /// List ID default retriever from its name
    /// - Parameter name: List name
    /// - Returns: Rretrieved from name ID
    static func retrieveIDFromName(_ name: String) -> String {
        return name.lowercased()
    }
}
