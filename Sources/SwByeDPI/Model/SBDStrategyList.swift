//
//  SBDStrategyList.swift
//  SwByeDPI
//
//  Created by developer on 19.02.2026.
//

import Foundation

/// Named DPI-evasion strategy list
public final class SBDStrategyList: SBDNamedListDelegate, Codable {
    
    public typealias ListItemType = SBDStrategy
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case strategies
    }
    
    public var id: String {
        get {
            return SBDStrategyList.retrieveIDFromName(name)
        }
    }

    public let name: String
    

    public let items: Set<SBDStrategy>

    /// Strategies list
    public var strategies: Set<SBDStrategy> {
        get {
            return items
        }
    }

    public var rawItems: [String] {
        get {
            var res: [String] = [String].init(repeating: "", count: items.count)
            var i = 0
            for item in items {
                res[i] = item.cmdArgsLine
                i += 1
            }
            res.sort { a, b in
                return a.compare(b) == .orderedAscending
            }
            return res
        }
    }
    
    public init(name: String, strategies: Set<SBDStrategy>) {
        self.name = name
        self.items = strategies
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try? container.decode(String.self, forKey: .id)
        let name = try? container.decode(String.self, forKey: .name)
        if let safeID = id, name == nil || name?.isEmpty == true {
            self.name = safeID
        } else if let safeName = name {
            self.name = safeName
        } else {
            self.name = UUID().uuidString
        }
        
        let strategiesArr = (try? container.decode([String].self, forKey: .strategies)) ?? []
        items = Set<SBDStrategy>(strategiesArr.map({ cmdLine in
            return SBDStrategy(cmdLine: cmdLine)
        }))
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode([String].init(strategies.map({ strategy in
            return strategy.cmdArgsLine
        })), forKey: .strategies)
    }
    
    /// Retrieves model raw data dictionary for export (Android BBD fromat)
    public func asExportDictionary() -> [String: Any] {
        let res: [String: Any] = [
            CodingKeys.id.rawValue: id,
            CodingKeys.name.rawValue: name,
            CodingKeys.strategies.rawValue: [String].init(strategies.map({ strategy in
                strategy.cmdArgs.joined(separator: " ")
            })),
        ]
        return res
    }
}
