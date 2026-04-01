//
//  ContentView.swift
//  ByeDPI-iOS
//
//  Created by developer on 24.02.2026.
//

import SwiftUI
import SwByeDPI

struct HomeScreen: View {
    
    @EnvironmentObject fileprivate var properties: AppProperties
    @EnvironmentObject fileprivate var lnwPermissionManager: LNWPermissionManager
    @EnvironmentObject fileprivate var neManager: NEObservableManager
    
    @State var vpnEnabled = false
    @State var showVpnEnabledHintAlert = false
    
    fileprivate var byeDPIProxyAddr: String {
        get {
            return properties.byeDPILaunchConfig.listenIP + ":" + String(properties.byeDPILaunchConfig.listenPort)
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8.0) {
            Spacer(minLength: 16)
            Button {
                toggleVpn()
            } label: {
                Image(R.image.icPower)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.white)
            }
            .frame(width: 120, height: 120, alignment: .center)
            .background(Color(vpnEnabled
                              ? R.color.grPositive
                              : R.color.grAccent))
            .cornerRadius(120)
            Text(vpnEnabled ? R.string.localizable.homeVpnStateOn : R.string.localizable.homeVpnStateOff)
                .foregroundColor(Color(R.color.grSecondary))
                .font(.caption)
                .fontWeight(.semibold)
            Text(byeDPIProxyAddr)
                .foregroundColor(Color(R.color.grSecondary))
                .font(.headline)
                .fontWeight(.semibold)
            Spacer(minLength: 16)
            if (vpnEnabled) {
                Button {
                    if (showVpnEnabledHintAlert) {
                        return
                    }
                    showVpnEnabledHintAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: DispatchTimeInterval.seconds(3))) {
                        if (!showVpnEnabledHintAlert) {
                            return
                        }
                        showVpnEnabledHintAlert = false
                    }
                } label: {
                    Text(R.string.localizable.generalSettings)
                }
                .padding(EdgeInsets(top: .zero, leading: 16.0, bottom: 12.0, trailing: 16.0))
            } else {
                NavigationLink {
                    SettingsScreen()
                } label: {
                    Text(R.string.localizable.generalSettings)
                }
                .padding(EdgeInsets(top: .zero, leading: 16.0, bottom: 12.0, trailing: 16.0))
            }
        }
        .alert(isPresented: $showVpnEnabledHintAlert, content: {
            Alert(title: Text(R.string.localizable.homeSettingsAccessHint))
        })
    }
    
    fileprivate func toggleVpn() {
#if DEBUG
        if (ProcessInfo.processInfo.previewMode) {
            //Disable real VPN connection
            vpnEnabled = !vpnEnabled
            return
        }
#endif
        if (vpnEnabled) {
            neManager.stopConnection()
            vpnEnabled = false
            return
        }
        if (properties.byeDPILaunchConfig.listenIP == "0.0.0.0") {
            lnwPermissionManager.checkAndRequestPermission { status in
                print(status)
            }
        }
        neManager.startConnection { success, error in
            if (!success || error != nil) {
                return
            }
            vpnEnabled = true
        }
    }
}

#if DEBUG
#Preview {
    NavigationView {
        HomeScreen()
    }
    .environmentObject(previewProperties)
    .environmentObject(previewLnwPermissionManager)
    .environmentObject(previewDomainsManager)
    .environmentObject(previewStrategiesManager)
    .environmentObject(previewByeDPIManager)
    .environmentObject(previewNeManager)
    .environmentObject(previewTestManager)
}
#endif
