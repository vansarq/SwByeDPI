import NetworkExtension

extension NETunnelProviderProtocol {
    
    var byeDPIVPNRunning: Bool {
        get {
            return providerConfiguration?[UserDefaultsAppKeys.byeDPIVPNRunning.rawValue] as? Bool ?? false
        }
        set {
            providerConfiguration?[UserDefaultsAppKeys.byeDPIVPNRunning.rawValue] = newValue as NSObject
        }
    }
    
    var byeDPIListenIp: String {
        get {
            return providerConfiguration?[UserDefaultsAppKeys.selectedByeDPIListenIpAddrKey.rawValue] as? String ?? ""
        }
        set {
            providerConfiguration?[UserDefaultsAppKeys.selectedByeDPIListenIpAddrKey.rawValue] = newValue as NSObject
        }
    }
    
    var byeDPIListenPort: UInt16 {
        get {
            return providerConfiguration?[UserDefaultsAppKeys.selectedByeDPIListenPortKey.rawValue] as? UInt16 ?? 0
        }
        set {
            providerConfiguration?[UserDefaultsAppKeys.selectedByeDPIListenPortKey.rawValue] = newValue as NSObject
        }
    }
    
    var byeDPIBufSize: Int32 {
        get {
            return providerConfiguration?[UserDefaultsAppKeys.selectedByeDPIBufSizeKey.rawValue] as? Int32 ?? 0
        }
        set {
            providerConfiguration?[UserDefaultsAppKeys.selectedByeDPIBufSizeKey.rawValue] = newValue as NSObject
        }
    }
    
    var byeDPICmdArgs: [String] {
        get {
            return providerConfiguration?[UserDefaultsAppKeys.selectedByeDPICmdArgsKey.rawValue] as? [String] ?? []
        }
        set {
            providerConfiguration?[UserDefaultsAppKeys.selectedByeDPICmdArgsKey.rawValue] = newValue as NSObject
        }
    }
    
    var resolvedDnsServers: [String] {
        get {
            return providerConfiguration?[UserDefaultsAppKeys.resolvedDnsServersKey.rawValue] as? [String] ?? []
        }
        set {
            providerConfiguration?[UserDefaultsAppKeys.resolvedDnsServersKey.rawValue] = newValue as NSObject
        }
    }
    
    var dnsOverAddr: String {
        get {
            return providerConfiguration?[UserDefaultsAppKeys.selectedDnsOverAddrKey.rawValue] as? String ?? ""
        }
        set {
            providerConfiguration?[UserDefaultsAppKeys.selectedDnsOverAddrKey.rawValue] = newValue as NSObject
        }
    }
    
    var tunMtu: UInt16 {
        get {
            return providerConfiguration?[UserDefaultsAppKeys.selectedTunMtuKey.rawValue] as? UInt16 ?? 0
        }
        set {
            providerConfiguration?[UserDefaultsAppKeys.selectedTunMtuKey.rawValue] = newValue as NSObject
        }
    }
    
}
