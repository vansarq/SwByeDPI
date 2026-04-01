//
//  BDError.swift
//  ByeDPIKit
//
//  Created by Developer on 16.03.2026.
//

import Foundation

/// Represents general exceptions of framework
public enum BDError
{
    ///General-purpose error
    case general(errCode: Int, desc: String)
    ///ByeDPI proxy already running
    case alreadyRunning
    ///ByeDPI proxy start error
    case startError(errCode: Int)
}

extension BDError: Error {
    public var errorDescription: String {
        switch(self) {
        case .general(let errCode, let desc):
            return "General error - " + String(errCode) + "; " + desc
        case .alreadyRunning:
            return "ByeDPI proxy already running"
        case .startError(let errCode):
            return "ByeDPI proxy start error - " + String(errCode)
        }
    }
}

#if swift(>=5.5)
extension BDError: Sendable {}
#endif
