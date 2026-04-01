//
//  SBDDomainList.swift
//  SwByeDPI
//
//  Created by developer on 19.02.2026.
//

import Foundation

/// Named domain list
public final class SBDDomainList: SBDNamedListDelegate, Codable {
    
    public typealias ListItemType = String
    
    private enum CodingKeys: String, CodingKey {
      case id
      case name
      case domains
    }
    
    public var id: String {
        get {
            return SBDDomainList.retrieveIDFromName(name)
        }
    }
    public let name: String
    
    public let items: Set<String>
    
    /// Domains list
    public var domains: Set<String> {
        get {
            return items
        }
    }

    public var rawItems: [String] {
        get {
            var res: [String] = [String].init(items)
            res.sort { a, b in
                return a.compare(b) == .orderedAscending
            }
            return res
        }
    }
    
    public init(name: String, domains: Set<String>) {
        self.name = name
        self.items = domains
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
        
        let domainsArr = (try? container.decode([String].self, forKey: .domains)) ?? []
        items = Set<String>(domainsArr)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode([String].init(domains), forKey: .domains)
    }
    
    /// Generates SLD (second-level domain) list from the current one
    /// 
    /// Use case: generate filter hosts list from test-related one
    public func retrieveSLDList(newName: String? = nil) -> SBDDomainList {
        var resSet = Set<String>()
        for domain in domains {
            guard let sld = SBDDomainUtil.retrieveSLD(domain) else {
                continue
            }            
            if (resSet.contains(sld)) {
                continue
            }
            resSet.insert(sld)
        }
        return SBDDomainList(name: newName ?? name, domains: resSet)
    }
    
    /// Retrieves model raw data dictionary for export (Android BBD format)
    public func asExportDictionary() -> [String: Any] {
        let res: [String: Any] = [
            CodingKeys.id.rawValue: id,
            "isActive": false,
            "isBuiltIn": false,
            CodingKeys.name.rawValue: name,
            CodingKeys.domains.rawValue: [String].init(domains),
        ]
        return res
    }
}
