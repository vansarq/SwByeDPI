//
//  SBDError.swift
//  ByeDPIKit
//
//  Created by Developer on 08.02.2026.
//

///Represents general exceptions of framework
public enum SBDError
{
    ///General-purpose error
    case general(errCode: Int, desc: String)
    
    ///List with defined ID not found
    case listNotFound(id: String)
    ///List with defined ID already exists
    case listDuplicate(id: String)
}

extension SBDError: Error {    
    public var errorDescription: String {
        switch(self) {
        case .general(let errCode, let desc):
            return "General error - " + String(errCode) + "; " + desc
            
        case .listNotFound(let id):
            return "List with defined ID '" + id + "' not found"
        case .listDuplicate(let id):
            return "List with defined ID '" + id + "' already exists"
        }
    }
}

#if swift(>=5.5)
extension SBDError: Sendable {}
#endif
