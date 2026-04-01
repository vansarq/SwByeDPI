//
//  SBDLogLevel.swift
//  SwByeDPI
//
//  Created by developer on 31.03.2026.
//

public enum SBDLogLevel: UInt8, Codable {
    case error = 0
    case debug = 1
    case verbose = 2
}

#if swift(>=5.5)
extension SBDLogLevel: Sendable {}
#endif
