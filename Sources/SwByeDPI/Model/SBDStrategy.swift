//
//  SBDStrategy.swift
//  SwByeDPI
//
//  Created by developer on 19.02.2026.
//

import Foundation

/// A reusable DPI-evasion strategy
public final class SBDStrategy: Hashable, Codable, CustomStringConvertible {
    
    fileprivate static let _autoShortArgKey = "-A"
    fileprivate static let _autoFullArgKey = "--auto"
    fileprivate static let _hostsShortArgKey = "-H"
    fileprivate static let _hostsFullArgKey = "--hosts"
    
    private enum CodingKeys: String, CodingKey {
      case id
      case cmdArgs
    }
    
    /// Computed from cmd args strategy ID
    public let id: Int
    
    /// DPI-evasion args
    public let cmdArgs: [String]
    
    /// DPI-evasion args line string
    public var cmdArgsLine: String {
        get {
            return cmdArgs.joined(separator: " ")
        }
    }
    
    public init(cmdArgs: [String]) {
        var validated = SBDStrategy.validateDomainsArgInStrategyCmd(cmdArgs)
        validated = SBDStrategy.validateIPSetArgInStrategyCmd(validated)
        id = validated.joined(separator: " ").hashValue
        self.cmdArgs = validated
    }
    
    public init(cmdLine: String) {
        let stockCmdArgs = cmdLine.split(separator: " ").map { subStr in
            return String(subStr)
        }
        var validated = SBDStrategy.validateDomainsArgInStrategyCmd(stockCmdArgs)
        validated = SBDStrategy.validateIPSetArgInStrategyCmd(validated)
        id = validated.joined(separator: " ").hashValue
        self.cmdArgs = validated
        /*id = cmdLine.hashValue
        var args: [String] = []
        var i = 0
        var quote = false
        var currArg = ""
        for ch in cmdLine {
            if (ch != " " && ch != "\"" && ch != "'") {
                currArg += String(ch)
                i += 1
                continue
            }
            if (ch == " ") {
                if (quote) {
                    currArg += String(ch)
                    continue
                }
                if (currArg.isEmpty) {
                    continue
                }
                args.append(currArg)
                currArg = ""
                continue
            }
            // Current character is ' or "
            if (!quote) {
                //Start string
                quote = true
                continue
            }
            //End string
            args.append(currArg)
            currArg = ""
            quote = false
        }
        if (!currArg.isEmpty) {
            args.append(currArg)
        }
        cmdArgs = args*/
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cmdArgs = (try? container.decode([String].self, forKey: .cmdArgs)) ?? []
        let strat = SBDStrategy(cmdArgs: cmdArgs)
        id = (try? container.decode(Int.self, forKey: .id)) ?? strat.id
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cmdArgs, forKey: .cmdArgs)
        try? container.encode(id, forKey: .id)
    }
    
    /// Transform DPI-evasion strategy to ByeDPI launch config
    public func generateConfig(listenIP: String = SBDConfig.defaultListenIP, listenPort: UInt16 = SBDConfig.defaultListenPort, bufSize: Int32 = SBDConfig.defaultBufSize, maxConn: UInt16 = SBDConfig.defaultMaxConn, ttl: UInt8? = nil, noDomain: Bool = false, noUDP: Bool = false, logLevel: SBDLogLevel? = nil) -> SBDConfig {
        let validatedCmdArgs = SBDConfig.validateCmdArgs(cmdArgs)
        return SBDConfig(listenIP: listenIP, listenPort: listenPort, bufSize: bufSize, maxConn: maxConn, ttl: ttl, noDomain: noDomain, noUDP: noUDP, logLevel: logLevel, commandArgs: validatedCmdArgs)
    }
    
    public func generateWithAppliedDomains(_ domains: Set<String>) -> SBDStrategy {
        let generatedCmdArgs = SBDStrategy.generateStrategyCmdArgsWithAppliedDomains(cmdArgs, domains: domains)
        return SBDStrategy(cmdArgs: generatedCmdArgs)
    }
    
    public func generateWithAppliedSLDs(sldSet: Set<String>) -> SBDStrategy {
        let generatedCmdArgs = SBDStrategy.generateStrategyCmdArgsWithAppliedSLDs(cmdArgs, sldSet: sldSet)
        return SBDStrategy(cmdArgs: generatedCmdArgs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var description: String {
        get {
            return cmdArgsLine
        }
    }
    
    public static func == (lhs: SBDStrategy, rhs: SBDStrategy) -> Bool {
        return lhs.id == rhs.id
    }
    
    public static func validateDomainsArgInStrategyCmd(_ cmd: [String]) -> [String] {
        return validateStringArgInStrategyCmd(cmd, argKeyShort: "-H", argKeyLong: "--hosts")
    }
    
    public static func validateIPSetArgInStrategyCmd(_ cmd: [String]) -> [String] {
        return validateStringArgInStrategyCmd(cmd, argKeyShort: "-j", argKeyLong: "--ipset")
    }
    
    public static func validateStringArgInStrategyCmd(_ cmd: [String], argKeyShort: String, argKeyLong: String) -> [String] {
        var res: [String] = []
        var i = 0
        while (i < cmd.count) {
            var arg = cmd[i]
            if (!arg.hasPrefix(argKeyShort) && !arg.hasPrefix(argKeyLong)) {
                res.append(arg)
                i += 1
                continue
            }
            if (!arg.hasPrefix(argKeyShort + ":") && !arg.hasPrefix(argKeyLong + ":")) {
                // The next arg is file or single arg value
                i += 1
                let checkSplit = arg.split(separator: " ", omittingEmptySubsequences: true)
                if (checkSplit.count == 1) {
                    res.append(arg)
                    continue
                }
                for entry in checkSplit {
                    res.append(String(entry))
                }
                continue
            }
            // The arg is string -> check and validate
            let splitted = arg.split(separator: " ")
            if (splitted.count >= 2) {
                //Possible single arg contains all entries -> remove quotes and add
                res.append(arg.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "'", with: ""))
                i += 1
                continue
            }
            //Entries are contained in cmd as discrette args -> inner cycle until arg in cmd, which starts from with prefix '-' (next parameter section)
            if (i + 1 >= cmd.count) {
                res.append(arg.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "'", with: ""))
                i += 1
                continue
            }
            var validated = arg
            i += 1
            arg = cmd[i]
            while (!arg.hasPrefix("-") && i < cmd.count) {
                validated += " " + arg
                i += 1
                if (i >= cmd.count) {
                    // Last
                    break
                }
                arg = cmd[i]
            }
            res.append(validated.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "'", with: ""))
        }
        return res
    }
    
    public static func generateDnsBypassArg() -> String {
        return "-V53"
    }
    
    public static func generateStrategyCmdArgsWithAppliedDomains(_ strategyCmdArgs: [String], domains: Set<String>) -> [String] {
        if (domains.isEmpty) {
            return strategyCmdArgs
        }
        var sldSet = Set<String>()
        for domain in domains {
            guard let safeSld = SBDDomainUtil.retrieveSLD(domain) else {
                continue
            }
            if (sldSet.contains(safeSld)) {
                continue
            }
            sldSet.insert(safeSld)
        }
        return generateStrategyCmdArgsWithAppliedSLDs(strategyCmdArgs, sldSet: sldSet)
    }
    
    public static func generateStrategyCmdArgsWithAppliedSLDs(_ strategyCmdArgs: [String], sldSet: Set<String>) -> [String] {
        if (sldSet.isEmpty) {
            return strategyCmdArgs
        }
        let filterHostsArg = generateSLDsHostsArg(sldSet: sldSet)
        var resCmdArgs: [String] = []
        var iterator = 0
        var currCmdArg = ""
        var lastAutoArgIndex = -1
        var lastHostsArgIndex = -1
        if (strategyCmdArgs.count >= 1) {
            currCmdArg = strategyCmdArgs[iterator]
            if (currCmdArg.hasPrefix(SBDStrategy._autoShortArgKey) || currCmdArg.hasPrefix(SBDStrategy._autoFullArgKey)) {
                //The first arg is '-A{t,r,s}' or '--auto={torst,redirect,ssl_err}' -> Can't insert filter hosts
                resCmdArgs.append(strategyCmdArgs[iterator])
                lastAutoArgIndex = iterator
                iterator += 1
            } else if (currCmdArg.hasPrefix(SBDStrategy._hostsShortArgKey) || currCmdArg.hasPrefix(SBDStrategy._hostsFullArgKey)) {
                //The first arg is '-H:"domain.com"' or '-H site.txt' or '--hosts="domain.com' or '--hosts site.txt'
                resCmdArgs.append(currCmdArg)
                lastHostsArgIndex = iterator
                iterator += 1
                if (currCmdArg.hasPrefix(SBDStrategy._hostsShortArgKey + ":\"") || currCmdArg.hasPrefix(SBDStrategy._hostsFullArgKey + "=\"")) {
                    //Sites string -> Add all args-domains before '"'
                    while (iterator < strategyCmdArgs.count && currCmdArg.hasSuffix("\"")) {
                        currCmdArg = strategyCmdArgs[iterator]
                        iterator += 1
                        resCmdArgs.append(currCmdArg)
                    }
                } else {
                    //The next parameter is file name -> Add to res
                    currCmdArg = strategyCmdArgs[iterator]
                    resCmdArgs.append(currCmdArg)
                    iterator += 1
                }
            } else {
                // Not '-A' or '-H' -> Can insert filter domains arg
                resCmdArgs.append(filterHostsArg)
            }
        }
        if (lastAutoArgIndex == 0 && lastHostsArgIndex < 0 && strategyCmdArgs.count >= 2) {
            //There is '-A' at pos 0 and no '-H' -> Search '-H' arg
            currCmdArg = strategyCmdArgs[iterator]
            if (currCmdArg.hasPrefix(SBDStrategy._hostsShortArgKey) || currCmdArg.hasPrefix(SBDStrategy._hostsFullArgKey)) {
                //The second arg is '-H:"domain.com"' or '-H site.txt' or '--hosts="domain.com' or '--hosts site.txt'
                resCmdArgs.append(currCmdArg)
                lastHostsArgIndex = iterator
                iterator += 1
                if (currCmdArg.hasPrefix(SBDStrategy._hostsShortArgKey + ":\"") || currCmdArg.hasPrefix(SBDStrategy._hostsFullArgKey + "=\"")) {
                    //Sites string -> Add all args-domains before '"'
                    while (iterator < strategyCmdArgs.count && currCmdArg.hasSuffix("\"")) {
                        currCmdArg = strategyCmdArgs[iterator]
                        iterator += 1
                        resCmdArgs.append(currCmdArg)
                    }
                } else {
                    //The next parameter is file name -> Add to res
                    currCmdArg = strategyCmdArgs[iterator]
                    resCmdArgs.append(currCmdArg)
                    iterator += 1
                }
            } else if (!currCmdArg.hasPrefix(SBDStrategy._hostsShortArgKey) && !currCmdArg.hasPrefix(SBDStrategy._hostsFullArgKey)) {
                // Neither '-H' nor '-A' -> Can insert filter domains arg
                resCmdArgs.append(filterHostsArg)
            }
        }
        lastAutoArgIndex = -1
        lastHostsArgIndex = -1
        while (iterator < strategyCmdArgs.count) {
            currCmdArg = strategyCmdArgs[iterator]
            if (lastAutoArgIndex >= 0 && lastAutoArgIndex + 1 == iterator) {
                //Previous arg is '-A{t,r,s}' or '--auto={torst,redirect,ssl_err}' -> Search for domains or insert filter
                if (currCmdArg.hasPrefix(SBDStrategy._hostsShortArgKey) || currCmdArg.hasPrefix(SBDStrategy._hostsFullArgKey)) {
                    //The current arg is '-H:"domain.com"' or '-H site.txt' or '--hosts="domain.com' or '--hosts site.txt'
                    resCmdArgs.append(currCmdArg)
                    lastHostsArgIndex = iterator
                    iterator += 1
                    if (currCmdArg.hasPrefix(SBDStrategy._hostsShortArgKey + ":\"") || currCmdArg.hasPrefix(SBDStrategy._hostsFullArgKey + "=\"")) {
                        //Sites string -> Add all args-domains before '"'
                        while (iterator < strategyCmdArgs.count && currCmdArg.hasSuffix("\"")) {
                            currCmdArg = strategyCmdArgs[iterator]
                            iterator += 1
                            resCmdArgs.append(currCmdArg)
                        }
                    } else {
                        //The next parameter is file name -> Add to res
                        currCmdArg = strategyCmdArgs[iterator]
                        resCmdArgs.append(currCmdArg)
                        iterator += 1
                    }
                } else if (!currCmdArg.hasPrefix(SBDStrategy._hostsShortArgKey) && !currCmdArg.hasPrefix(SBDStrategy._hostsFullArgKey)) {
                    // Neither '-H' nor '-A' -> Can insert filter domains arg
                    resCmdArgs.append(filterHostsArg)
                    lastAutoArgIndex = -1
                }
            }
            if (!currCmdArg.hasPrefix(SBDStrategy._autoShortArgKey) && !currCmdArg.hasPrefix(SBDStrategy._autoFullArgKey) && !currCmdArg.hasPrefix(SBDStrategy._hostsShortArgKey) && !currCmdArg.hasPrefix(SBDStrategy._hostsFullArgKey)) {
                resCmdArgs.append(currCmdArg)
                iterator += 1
                continue
            }
            if (currCmdArg.hasPrefix(SBDStrategy._autoShortArgKey) || currCmdArg.hasPrefix(SBDStrategy._autoFullArgKey)) {
                //The arg is '-A{t,r,s}' or '--auto={torst,redirect,ssl_err}'
                resCmdArgs.append(strategyCmdArgs[iterator])
                lastAutoArgIndex = iterator
                iterator += 1
                continue
            }
        }
        return resCmdArgs
    }
    
    /// Generates byedpi '-H:string' arg with provided unqiue domains, which will be transformed into unique Second-Level Domains (SLDs)
    public static func generateDomainsHostsArg(_ domains: Set<String>) -> String {
        if (domains.isEmpty) {
            return ""
        }
        var sldSet = Set<String>()
        for domain in domains {
            guard let safeSld = SBDDomainUtil.retrieveSLD(domain) else {
                continue
            }
            if (sldSet.contains(safeSld)) {
                continue
            }
            sldSet.insert(safeSld)
        }
        return generateSLDsHostsArg(sldSet: sldSet)
    }
    
    /// Generates byedpi '-H:string' arg with provided Second-Level Domains (SLDs)
    public static func generateSLDsHostsArg(sldSet: Set<String>) -> String {
        if (sldSet.isEmpty) {
            return ""
        }
        // Insert second-level domains as -H:"domain1.com domain2.com .. domain-n.com"
        // For byedpi in cmd '-H:"domain1.com domain2.com .. domain-n.com"' is a single arg
        let cmdArgs = "-H:" + sldSet.joined(separator: " ")
        return cmdArgs
    }
}

#if swift(>=5.5)
extension SBDStrategy: Sendable {}
#endif
