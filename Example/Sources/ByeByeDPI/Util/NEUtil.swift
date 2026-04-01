//
//  NEUtil.swift
//  SwByeDPI
//
//  Created by developer on 26.03.2026.
//

import Foundation

final class NEUtil {
    
    static func generateConnectionParamsFromAppUserDefaults() -> [String: NSObject] {
        let res: [String: NSObject] = [
            UserDefaultsAppKeys.selectedByeDPIListenIpAddrKey.rawValue: UserDefaultsAppProperties.byeDPIListenIp as NSObject,
            UserDefaultsAppKeys.selectedByeDPIListenPortKey.rawValue: UserDefaultsAppProperties.byeDPIListenPort as NSObject,
            UserDefaultsAppKeys.selectedByeDPIBufSizeKey.rawValue: UserDefaultsAppProperties.byeDPIBufSize as NSObject,
            UserDefaultsAppKeys.selectedByeDPICmdArgsKey.rawValue: UserDefaultsAppProperties.byeDPICmdArgs as NSObject,
            UserDefaultsAppKeys.selectedDnsOverAddrKey.rawValue: UserDefaultsAppProperties.dnsOverAddr as NSObject,
            UserDefaultsAppKeys.resolvedDnsServersKey.rawValue: UserDefaultsAppProperties.resolvedDnsServers as NSObject,
            UserDefaultsAppKeys.selectedTunMtuKey.rawValue: UserDefaultsAppProperties.tunMtu as NSObject,
        ]
        return res
    }
    
}
