//
//  SBDAndroidConfig.swift
//  SwByeDPI
//
//  Created by developer on 01.03.2026.
//

import Foundation

/// ByeByeDPI (Android) config iOS adapter
public final class SBDByeDPIAndroidConfig: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case app
        case version
        case apps
        case domainLists
        case history
        case settings
    }
    
    public static let appBundleId: String = "io.github.romanvht.byedpi"
    public static let appVersionCode: String = "1.7.3"
    
    public let dpiConfig: SBDConfig
    public let domainLists: [SBDDomainList]
    public let testConfig: SBDTestConfig
    
    public let apps: [String]
    public let cmdHistory: [String]
    public let dnsIpAddr: String
    
    fileprivate var androidSettings: SBDAndroidByeDPISettings {
        get {
            return SBDAndroidByeDPISettings(dpiConfig: dpiConfig, testConfig: testConfig, domainLists: domainLists, dnsIpAddr: dnsIpAddr)
        }
    }
    
    public init(dpiConfig: SBDConfig, domainLists: [SBDDomainList], testConfig: SBDTestConfig, apps: [String], cmdHistory: [String], dnsIpAddr: String) {
        self.dpiConfig = dpiConfig
        self.domainLists = domainLists
        self.testConfig = testConfig
        self.apps = apps
        self.cmdHistory = cmdHistory
        self.dnsIpAddr = dnsIpAddr
    }
    
    fileprivate init(androidSettings: SBDAndroidByeDPISettings, domainLists: [SBDDomainList], apps: [String], cmdHistory: [String]) {
        self.dpiConfig = androidSettings.dpiConfig
        self.domainLists = domainLists
        self.testConfig = androidSettings.testConfig
        self.apps = apps
        self.cmdHistory = cmdHistory
        self.dnsIpAddr = androidSettings.dnsIpAddr
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        apps = (try? container.decodeIfPresent([String].self, forKey: .apps)) ?? []
        domainLists = (try? container.decode([SBDDomainList].self, forKey: .domainLists)) ?? []
        let parsedHistory = (try? container.decodeIfPresent([SBDAndroidByeDPIHistory].self, forKey: .history)) ?? []
        cmdHistory = parsedHistory.map({ historyItem in
            return historyItem.text
        })
        let parsedSettings = try container.decode(SBDAndroidByeDPISettings.self, forKey: .settings)
        dpiConfig = parsedSettings.dpiConfig
        testConfig = parsedSettings.testConfig
        dnsIpAddr = parsedSettings.dnsIpAddr
    }
    
    public func asExportDictionary() -> [String: Any] {
        let res: [String: Any] = [
            CodingKeys.app.rawValue: SBDByeDPIAndroidConfig.appBundleId,
            CodingKeys.version.rawValue: SBDByeDPIAndroidConfig.appVersionCode,
            CodingKeys.apps.rawValue: apps,
            CodingKeys.domainLists.rawValue: domainLists.map({ list in
                return list.asExportDictionary()
            }),
            CodingKeys.history.rawValue: cmdHistory.map({ item in
                let dict: [String: Any] = [
                    "pinned": false,
                    "text": item
                ]
                return dict
            }),
            CodingKeys.settings.rawValue: androidSettings.asExportDictionary()
        ]
        return res
    }
}

fileprivate final class SBDAndroidByeDPIHistory: Sendable, Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case pinned
        case text
    }
    
    let pinned: Bool
    let text: String
    
    init(pinned: Bool, text: String) {
        self.pinned = pinned
        self.text = text
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pinned = (try? container.decodeIfPresent(Bool.self, forKey: .pinned)) ?? false
        self.text = try container.decode(String.self, forKey: .text)
    }
    
}

fileprivate final class SBDAndroidByeDPISettings: Sendable, Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case testLogClickable = "byedpi_proxytest_logclickable"
        case applistType = "applist_type"
        case domainListIDs = "byedpi_proxytest_domain_lists"
        case domains = "byedpi_proxytest_domains"
        case domainRequestsCount = "byedpi_proxytest_requestsсount"
        case domainRequestsCountAnother = "byedpi_proxytest_requests"
        case parallelRequestsCount = "byedpi_proxytest_limit"
        case requestsDelay = "byedpi_proxytest_delay"
        case requestsAnswerWaitTimeout = "byedpi_proxytest_timeout"
        case httpConnect = "byedpi_http_connect"
        case gdomain = "byedpi_proxytest_gdomain"
        case language
        case theme = "app_theme"
        case autostart
        case autoConnect = "auto_connect"
        case dpiIpAddr = "byedpi_proxy_ip"
        case dpiPort = "byedpi_proxy_port"
        case dpiCmdArgs = "byedpi_cmd_args"
        case testSni = "byedpi_proxytest_sni"
        case ipv6 = "ipv6_enable"
        case domainInitialLoaded = "domain_initial_loaded"
        case testRunning = "is_test_running"
        case useCmdEditor = "byedpi_enable_cmd_settings"
        case dpiMode = "byedpi_mode"
        case dnsIpAddr = "dns_ip"
        case customStrategies = "byedpi_proxytest_usercommands"
    }
    
    let theme: String
    let language: String
    let domainListIDs: [String]
    let domains: [String]
    let domainRequestsCount: UInt8
    let parallelRequestsCount: UInt8
    let requestsDelay: UInt8
    let requestsAnswerWaitTimeout: UInt8
    let testSni: String
    let dpiIpAddr: String
    let dpiPort: UInt16
    let dpiCmdArgs: String
    let dnsIpAddr: String
    
    var dpiConfig: SBDConfig {
        get {
            let strategy = SBDStrategy(cmdLine: dpiCmdArgs)
            return strategy.generateConfig(listenIP: dpiIpAddr, listenPort: dpiPort, bufSize: SBDConfig.defaultBufSize)
        }
    }
    
    var testConfig: SBDTestConfig {
        get {
            return SBDTestConfig(domainRequestsCount: domainRequestsCount, parallelRequestsCount: parallelRequestsCount, domainAnswerTimeoutInS: requestsAnswerWaitTimeout, delayBetweenRequestsInS: requestsDelay, fakeSNI: testSni, domainListIDs: Set<String>(domainListIDs), strategyListIDs: Set<String>([BuiltInDPIeStrategies.strategiesList.id]))
        }
    }
    
    init(theme: String, language: String, domainListIDs: [String], domains: [String], domainRequestsCount: UInt8, parallelRequestsCount: UInt8, requestsDelay: UInt8, requestsAnswerWaitTimeout: UInt8, testSni: String, dpiIpAddr: String, dpiPort: UInt16, dpiCmdArgs: String, dnsIpAddr: String) {
        self.theme = theme
        self.language = language
        self.domainListIDs = domainListIDs
        self.domains = domains
        self.domainRequestsCount = domainRequestsCount
        self.parallelRequestsCount = parallelRequestsCount
        self.requestsDelay = requestsDelay
        self.requestsAnswerWaitTimeout = requestsAnswerWaitTimeout
        self.testSni = testSni
        self.dpiIpAddr = dpiIpAddr
        self.dpiPort = dpiPort
        self.dpiCmdArgs = dpiCmdArgs
        self.dnsIpAddr = dnsIpAddr
    }
    
    init(dpiConfig: SBDConfig, testConfig: SBDTestConfig, domainLists: [SBDDomainList], dnsIpAddr: String) {
        theme = "system"
        language = "system"
        domainListIDs = [String].init(testConfig.domainListIDs)
        domains = [String].init(testConfig.retrieveDomains(domainLists: domainLists))
        domainRequestsCount = testConfig.domainRequestsCount
        parallelRequestsCount = testConfig.parallelRequestsCount
        requestsDelay = testConfig.delayBetweenRequestsInS
        requestsAnswerWaitTimeout = testConfig.domainRequestsCount
        testSni = testConfig.fakeSNI
        dpiIpAddr = dpiConfig.listenIP
        dpiPort = dpiConfig.listenPort
        dpiCmdArgs = dpiConfig.cmdArgs.joined(separator: " ")
        self.dnsIpAddr = dnsIpAddr
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        theme = (try? container.decodeIfPresent(String.self, forKey: .theme)) ?? "system"
        language = (try? container.decodeIfPresent(String.self, forKey: .language)) ?? "system"
        domainListIDs = (try? container.decodeIfPresent([String].self, forKey: .domainListIDs)) ?? []
        let domainsStr = (try? container.decodeIfPresent(String.self, forKey: .domains)) ?? ""
        domains = domainsStr.split(separator: "\n", omittingEmptySubsequences: true).map({ subStr in
            return String(subStr)
        })
        var buffStr = (try? container.decodeIfPresent(String.self, forKey: .domainRequestsCount)) ?? ""
        domainRequestsCount = UInt8(buffStr) ?? 1
        buffStr = (try? container.decodeIfPresent(String.self, forKey: .parallelRequestsCount)) ?? ""
        parallelRequestsCount = UInt8(buffStr) ?? 10
        buffStr = (try? container.decodeIfPresent(String.self, forKey: .requestsDelay)) ?? ""
        requestsDelay = UInt8(buffStr) ?? 1
        buffStr = (try? container.decodeIfPresent(String.self, forKey: .requestsAnswerWaitTimeout)) ?? ""
        requestsAnswerWaitTimeout = UInt8(buffStr) ?? 5
        testSni = (try? container.decodeIfPresent(String.self, forKey: .testSni)) ?? ""
        dpiIpAddr = (try? container.decodeIfPresent(String.self, forKey: .dpiIpAddr)) ?? SBDConfig.defaultListenIP
        buffStr = (try? container.decodeIfPresent(String.self, forKey: .dpiPort)) ?? ""
        dpiPort = UInt16(buffStr) ?? SBDConfig.defaultListenPort
        dpiCmdArgs = (try? container.decodeIfPresent(String.self, forKey: .dpiCmdArgs)) ?? ""
        dnsIpAddr = (try? container.decodeIfPresent(String.self, forKey: .dnsIpAddr)) ?? ""
    }
    
    
    func asExportDictionary() -> [String: Any] {
        let res: [String: Any] = [
            CodingKeys.testLogClickable.rawValue: false,
            CodingKeys.theme.rawValue: theme,
            CodingKeys.language.rawValue: language,
            CodingKeys.autostart.rawValue: false,
            CodingKeys.autoConnect.rawValue: false,
            CodingKeys.domainListIDs.rawValue: domainListIDs,
            CodingKeys.domains.rawValue: domains.joined(separator: "\n"),
            
            CodingKeys.testRunning.rawValue: false,
            CodingKeys.httpConnect.rawValue: false,
            CodingKeys.gdomain.rawValue: true,
            CodingKeys.domainInitialLoaded.rawValue: true,
            CodingKeys.applistType.rawValue: "whitelist",
            CodingKeys.ipv6.rawValue: false,
            CodingKeys.customStrategies.rawValue: false,
            
            CodingKeys.dnsIpAddr.rawValue: dnsIpAddr,
            
            CodingKeys.dpiIpAddr.rawValue: dpiIpAddr,
            CodingKeys.dpiPort.rawValue: String(dpiPort),
            CodingKeys.dpiCmdArgs.rawValue: dpiCmdArgs,
            CodingKeys.dpiMode.rawValue: "vpn",
            
            CodingKeys.useCmdEditor.rawValue: true,
            CodingKeys.domainRequestsCount.rawValue: String(domainRequestsCount),
            CodingKeys.domainRequestsCountAnother.rawValue: String(domainRequestsCount),
            CodingKeys.testSni.rawValue: testSni,
            CodingKeys.parallelRequestsCount.rawValue: String(parallelRequestsCount),
            CodingKeys.requestsDelay.rawValue: String(requestsDelay),
            CodingKeys.requestsAnswerWaitTimeout.rawValue: String(requestsAnswerWaitTimeout)
        ]
        return res
    }
}

#if swift(>=5.5)
extension SBDByeDPIAndroidConfig: Sendable {}
#endif
