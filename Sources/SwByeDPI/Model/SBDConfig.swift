//
//  SBDConfig.swift
//  SwByeDPI
//
//  Created by developer on 19.02.2026.
//

import Foundation

/// ByeDPI launch configuration
public final class SBDConfig: Codable, Cloneable {
    
    /// ByeDPI SOCKS proxy default listen IP address - 127.0.0.1 (localhost)
    public static let defaultListenIP = "127.0.0.1"

    /// ByeDPI SOCKS proxy default listen port - 10800
    public static let defaultListenPort: UInt16 = 10800 // Can't use default SOCKS port 1080 at iOS ('bind: Address already in use' error)

    /// ByeDPI SOCKS proxy default buffer size (in bytes) - 16384 bytes
    public static let defaultBufSize: Int32 = 16384
    
    /// ByeDPI SOCKS proxy default maximum client connections count - 512
    public static let defaultMaxConn: UInt16 = 512
    
    static let cmdValidateSet: Set<String> = ["-i", "--ip", "-p", "--port", "-b", "--bufSize", "-c", "--max-conn", "-g", "--def-ttl", "-x", "--debug"]
    static let cmdWithoutParamValidateSet: Set<String> = ["-N", "--no-domain", "-U", "--no-udp"]
#if targetEnvironment(simulator) || targetEnvironment(macCatalyst) || os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
    static let appleCmdWithParamRestrictedSet: Set<String> = ["-T", "--timeout", "-n", "--fake-sni"]
    static let appleCmdWithoutParamRestrictedSet: Set<String> = ["-Y", "--drop-sack", "-S", "--md5sig", "-E", "--transparent", "-F", "--tfo"]
#endif
    
    /// IP address to bind the SOCKS5 listener to (e.g. 127.0.0.1).
    public let listenIP: String

    /// TCP port for the local SOCKS5 listener.
    public let listenPort: UInt16
    
    /// recv/send max data size in bytes
    public let bufSize: Int32
    
    /// Maximum client connections count
    public let maxConn: UInt16
    
    /// Outgoing connections TTL
    public let ttl: UInt8?
    
    /// Deny domain resolving
    public let noDomain: Bool
    
    /// Deny UDP association
    public let noUDP: Bool
    
    /// ByeDPI logging level
    public let logLevel: SBDLogLevel?

    /// DPI-evasion command-line arguments. Not use for byeDPI launch
    ///
    /// Example:
    ///   "--disorder 1 --auto=torst --tlsrec 1+s"
    public let cmdArgs: [String]
    
    /// ByeDPI logging level raw arg value
    public var logLevelRaw: UInt8? {
        get {
            return logLevel?.rawValue
        }
    }
    
    /// Combined IP/Port parameters with deduplicated and validated cmdArgs. Use for byeDPI launch
    public var args: [String] {
        var res: [String] = [
            "-i", listenIP,
            "-p", String(listenPort),
            "-b", String(bufSize),
            "-c", String(maxConn),
            
        ]
        if let safeTtl = ttl, safeTtl != 0 {
            res.append(contentsOf: ["-g", String(safeTtl)])
        }
        if let safeLogLevelRaw = logLevelRaw {
            res.append(contentsOf: ["-x", String(safeLogLevelRaw)])
        }
        if (noDomain) {
            res.append("-N")
        }
        if (noUDP) {
            res.append("-U")
        }
        res.append(contentsOf: SBDConfig.validateCmdArgs(cmdArgs))
        return res
    }

    public init(listenIP: String = SBDConfig.defaultListenIP, listenPort: UInt16 = SBDConfig.defaultListenPort, bufSize: Int32 = SBDConfig.defaultBufSize, maxConn: UInt16 = SBDConfig.defaultMaxConn, ttl: UInt8? = nil, noDomain: Bool = false, noUDP: Bool = false, logLevel: SBDLogLevel? = nil, commandArgs: [String] = []) {
        self.listenIP = listenIP
        self.listenPort = listenPort
        self.bufSize = bufSize
        self.maxConn = maxConn
        self.ttl = ttl
        self.noDomain = noDomain
        self.noUDP = noUDP
        self.logLevel = logLevel
        self.cmdArgs = commandArgs
    }
    
    public init(source: SBDConfig) {
        self.listenIP = source.listenIP
        self.listenPort = source.listenPort
        self.bufSize = source.bufSize
        self.maxConn = source.maxConn
        self.ttl = source.ttl
        self.noDomain = source.noDomain
        self.noUDP = source.noUDP
        self.logLevel = source.logLevel
        self.cmdArgs = [String].init(source.cmdArgs)
    }
    
    /// Creates the new instance - clone with optinal edited values
    /// - Parameters:
    ///   - listenIP: New ByeDPI SOCKS proxy listen IP address. Optional
    ///   - listenPort: New ByeDPI SOCKS proxy listen port. Optional
    ///   - bufSize: New recv/send max data size in bytes. Optional
    ///   - maxConn: New maximum client connections count. Optional
    ///   - ttl: New outgoing connections TTL. Optional
    ///   - noDomain: New deny domain resolving. Optional
    ///   - noUDP: New deny UDP association. Optional
    ///   - logLevel: New ByeDPI logging level. Optional
    ///   - commandArgs: New DPI-evasion command-line arguments. Optional
    /// - Returns: Cloned ByeDPI launch configuration
    public func copyWith(listenIP: String? = nil, listenPort: UInt16? = nil, bufSize: Int32? = nil, maxConn: UInt16? = nil, ttl: UInt8? = nil, noDomain: Bool? = nil, noUDP: Bool? = nil, logLevel: SBDLogLevel? = nil, commandArgs: [String]? = nil) -> SBDConfig {
        return SBDConfig(listenIP: listenIP ?? self.listenIP, listenPort: listenPort ?? self.listenPort, bufSize: bufSize ?? self.bufSize, maxConn: maxConn ?? self.maxConn, ttl: ttl ?? self.ttl, noDomain: noDomain ?? self.noDomain, noUDP: noUDP ?? self.noUDP, logLevel: logLevel ?? self.logLevel, commandArgs: commandArgs ?? self.cmdArgs)
    }
    
    /// Validates and corrects, if can, DPI-evasion command-line arguments
    /// - Parameter args: DPI-evasion command-line arguments for validation
    /// - Returns: Validated DPI-evasion command-line arguments
    static func validateCmdArgs(_ args: [String]) -> [String] {
        var out: [String] = []
        var i = 0
        while i < args.count {
            let t = args[i]
            if (cmdValidateSet.contains(t)) {
                // Skip option and the next value if present.
                i += 2
                continue
            }
            if (cmdWithoutParamValidateSet.contains(t)) {
                i += 1
                continue
            }
            #if targetEnvironment(simulator) || targetEnvironment(macCatalyst) || os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
            if (appleCmdWithParamRestrictedSet.contains(t)) {
                // Skip option and the next value if present.
                i += 2
                continue
            }
            if (appleCmdWithoutParamRestrictedSet.contains(t)) {
                i += 1
                continue
            }
            if (t.hasPrefix("-f")) {
                i += 1
                continue
            }
            if (t.hasPrefix("--fake")) {
                i += 2
                continue
            }
            #endif
            let noQuotesStr = t.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "'", with: "")
            out.append(noQuotesStr)
            i += 1
        }
        return out
    }
}

#if swift(>=5.5)
extension SBDConfig: Sendable {}
#endif
