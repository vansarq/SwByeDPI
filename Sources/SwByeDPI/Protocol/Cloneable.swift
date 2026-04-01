//
//  Cloneable.swift
//  SwByeDPI
//
//  Created by developer on 05.03.2026.
//

/// Cloneable ability protocol
protocol Cloneable {
    
    init(source: Self)
    
}

/// Protocol extension with pre-implemented methods
extension Cloneable {
    
    /// Creates the new instance from stock - clone
    /// - Returns: Cloned instance
    func clone() -> Self {
        return Self.init(source: self)
    }
    
    /// Creates the new instance from stock - clone
    /// - Parameter source: Stock instance
    /// - Returns: Cloned instance
    func copyWith(_ source: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try source(&copy)
        return copy
    }
    
}
