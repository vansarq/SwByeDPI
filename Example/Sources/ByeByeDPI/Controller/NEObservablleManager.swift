//
//  NEObservablleManager.swift
//  SwByeDPI
//
//  Created by developer on 06.03.2026.
//

import SwiftUI
import NetworkExtension

@available(tvOS 17.0, *)
class NEObservableManager: ObservableObject {
    
    @Published fileprivate(set) var neTunnelProviderManager: NETunnelProviderManager?
    
    init(initCompletion: @escaping (NETunnelProviderManager?, (any Error)?) -> Void) {
        neTunnelProviderManager = nil
        getOrInitNEManager(completion: initCompletion)
    }
    
    func startConnection(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        if let safeManager = neTunnelProviderManager {
            startConnection(manager: safeManager, completion: completion)
            return
        }
        getOrInitNEManager { manager, err in
            guard let safeManager = manager else {
                return
            }
            self.startConnection(manager: safeManager, completion: completion)
        }
    }
    
    func stopConnection() {
        if let safeManager = neTunnelProviderManager {
            safeManager.connection.stopVPNTunnel()
            return
        }
        getOrInitNEManager { manager, err in
            guard let safeManager = manager else {
                return
            }
            safeManager.connection.stopVPNTunnel()
        }
    }
    
    fileprivate func startConnection(manager: NETunnelProviderManager, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        manager.loadFromPreferences { loadErr in
            if let safeLoadErr = loadErr {
                completion(false, safeLoadErr)
                return
            }
            let firstTimeVpnSet = manager.protocolConfiguration == nil
            let startTunnelOptions = NEUtil.generateConnectionParamsFromAppUserDefaults()
            manager.isEnabled = true
            let vpnProtocol = NETunnelProviderProtocol()
            vpnProtocol.providerConfiguration = startTunnelOptions
            vpnProtocol.serverAddress = UserDefaultsAppProperties.byeDPIListenIp
            vpnProtocol.providerBundleIdentifier = Constants.VPN_PROVIDER_BUNDLE_ID
            vpnProtocol.includeAllNetworks = false
            if #available(iOS 16.4, *) {
                vpnProtocol.excludeAPNs = true
            }
            if #available(iOS 14.2, *) {
                vpnProtocol.excludeLocalNetworks = true
            }
            if #available(iOS 17.4, *) {
                vpnProtocol.excludeDeviceCommunication = true
            }
            manager.protocolConfiguration = vpnProtocol
            manager.saveToPreferences { saveErr in
                if let safeSaveErr = saveErr {
                    completion(false, safeSaveErr)
                    return
                }
                if (firstTimeVpnSet) {
                    //Load after the first save
                    self.startConnection(manager: manager, completion: completion)
                    return
                }
                do {
                    try manager.connection.startVPNTunnel(options: startTunnelOptions)
                    completion(true, nil)
                } catch {
#if DEBUG
                    print("Start VPN error")
                    print(error)
#endif
                    completion(false, error)
                }
            }
        }
    }
    
    fileprivate func getOrInitNEManager(completion: @escaping (NETunnelProviderManager?, (any Error)?) -> Void) {
        if let safeManager = neTunnelProviderManager {
            completion(safeManager, nil)
            return
        }
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            if let safeError = error {
                print(safeError)
                completion(nil, error)
                return
            }
            guard let safeManagers = managers else {
                print("NE Tunnel Provider managers array from cache is nil - Init the new one")
                let manager = NETunnelProviderManager()
                self.neTunnelProviderManager = manager
                completion(manager, nil)
                return
            }
            if (safeManagers.isEmpty) {
                print("NE Tunnel Provider managers array from cache is empty -> Init the new one")
                let manager = NETunnelProviderManager()
                self.neTunnelProviderManager = manager
                completion(manager, nil)
                return
            }
            self.neTunnelProviderManager = safeManagers[0]
            completion(safeManagers[0], nil)
        }
    }
}
