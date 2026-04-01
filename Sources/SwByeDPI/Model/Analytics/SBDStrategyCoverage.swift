import Foundation

public final class SBDStrategyCoverage: Sendable {

    public let strategy: SBDStrategy
    
    public let sldCoverage: [Bool: Set<String>]

    public var successSLDsCount: Int {
        get {
            return sldCoverage[true]?.count ?? 0
        }
    }

    public var failSLDsCount: Int {
        get {
            return sldCoverage[false]?.count ?? 0
        }
    }

    public var strategyApplicable: Bool {
        get {
            return successSLDsCount > 0
        }
    }

    public init(strategy: SBDStrategy, sldCoverage: [Bool: Set<String>]) {
        self.strategy = strategy
        var clonedCoverage: [Bool: Set<String>] = [:]
        for entry in sldCoverage {
            clonedCoverage[entry.key] = entry.value
        }
        self.sldCoverage = clonedCoverage
    }   
}