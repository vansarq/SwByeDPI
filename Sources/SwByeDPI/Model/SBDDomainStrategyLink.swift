//
//  SBDDomainStrategyLink.swift
//  SwByeDPI
//
//  Created by developer on 13.03.2026.
//

/// Domain with strategy link (Testing purposes)
public final class SBDDomainStrategyLink {
    
    /// Strategy ID
    public let strategyID: Int
    /// Domain name
    public let domain: String
    
    /// Domain with strategy link
    public var linkID: String {
        get {
            return String(strategyID) + "-" + domain
        }
    }
    
    public init(strategyID: Int, domain: String) {
        self.strategyID = strategyID
        self.domain = domain
    }
    
}

#if swift(>=5.5)
extension SBDDomainStrategyLink: Sendable {}
#endif
