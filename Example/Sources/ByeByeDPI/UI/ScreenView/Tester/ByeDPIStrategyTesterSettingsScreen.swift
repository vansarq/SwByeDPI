//
//  ByeDPIStrategyTesterSettingsScreen.swift
//  ByeByeDPI
//
//  Created by developer on 06.03.2026.
//

import SwiftUI
import SwByeDPI

struct ByeDPIStrategyTesterSettingsScreen: View {
    
    @EnvironmentObject var properties: AppProperties
    @EnvironmentObject var domainsManager: DomainsManager
    @EnvironmentObject var strategiesManager: StrategiesManager
    
    @State fileprivate var delayBetweenReqeustsInS = "0"
    @State fileprivate var domainRequestsCount = "0"
    @State fileprivate var threadsCount = "1"
    @State fileprivate var domainAnswerTimeoutInS = "5"
    
    @State fileprivate var showStrategyListPickerSheet = false
    @State fileprivate var showDomainListPickerSheet = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 8.0) {
                VStack(alignment: .leading) {
                    Text(R.string.localizable.settingsGeneralSection)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(R.color.grSecondary))
                    SettingsEditableInfoView(title: R.string.localizable.settingsByeDPIStrategyTestDelay(), value: $delayBetweenReqeustsInS, leadingIcon: Image(R.image.icSettingsAlt), valueTextSuffix: " - " + R.string.localizable.settingsByeDPIStrategyTestDelayDesc(), validator: { input in
                        guard let _ = UInt8(input) else {
                            return false
                        }
                        return true
                    }, onNewValue: { input in
                        guard let parsedNum = UInt8(input) else {
                            return
                        }
                        if (properties.byeDPITestConfig.delayBetweenRequestsInS == parsedNum) {
                            return
                        }
                        delayBetweenReqeustsInS = input
                        properties.byeDPITestConfig = properties.byeDPITestConfig.copyWith(delayBetweenRequestsInS: parsedNum)
                        properties.save()
                    }, keyboardType: .numberPad)
                    SettingsEditableInfoView(title: R.string.localizable.settingsByeDPIStrategyTestDomainRequestsCount(), value: $domainRequestsCount, leadingIcon: Image(R.image.icSettingsAlt), valueTextSuffix: " - " + R.string.localizable.settingsByeDPIStrategyTestDomainRequestsCountDesc(), validator: { input in
                        guard let _ = UInt8(input) else {
                            return false
                        }
                        return true
                    }, onNewValue: { input in
                        guard let parsedNum = UInt8(input) else {
                            return
                        }
                        if (properties.byeDPITestConfig.domainRequestsCount == parsedNum) {
                            return
                        }
                        domainRequestsCount = input
                        properties.byeDPITestConfig = properties.byeDPITestConfig.copyWith(domainRequestsCount: parsedNum)
                        properties.save()
                    }, keyboardType: .numberPad)
                    SettingsEditableInfoView(title: R.string.localizable.settingsByeDPIStrategyTestThreadsCount(), value: $threadsCount, leadingIcon: Image(R.image.icSettingsAlt), valueTextSuffix: " - " + R.string.localizable.settingsByeDPIStrategyTestThreadsCountDesc(), validator: { input in
                        guard let _ = UInt8(input) else {
                            return false
                        }
                        return true
                    }, onNewValue: { input in
                        guard let parsedNum = UInt8(input) else {
                            return
                        }
                        if (properties.byeDPITestConfig.parallelRequestsCount == parsedNum) {
                            return
                        }
                        threadsCount = input
                        properties.byeDPITestConfig = properties.byeDPITestConfig.copyWith(parallelRequestsCount: parsedNum)
                        properties.save()
                    }, keyboardType: .numberPad)
                    SettingsEditableInfoView(title: R.string.localizable.settingsByeDPIStrategyTestResponseWaitTimeout(), value: $domainAnswerTimeoutInS, leadingIcon: Image(R.image.icSettingsAlt), valueTextSuffix: " - " + R.string.localizable.settingsByeDPIStrategyTestResponseWaitTimeoutDesc(), validator: { input in
                        guard let _ = UInt8(input) else {
                            return false
                        }
                        return true
                    }, onNewValue: { input in
                        guard let parsedNum = UInt8(input) else {
                            return
                        }
                        if (properties.byeDPITestConfig.domainAnswerTimeoutInS == parsedNum) {
                            return
                        }
                        domainAnswerTimeoutInS = input
                        properties.byeDPITestConfig = properties.byeDPITestConfig.copyWith(domainAnswerTimeoutInS: parsedNum)
                        properties.save()
                    }, keyboardType: .numberPad)
                }
                .padding(EdgeInsets(top: .zero, leading: .zero, bottom: 8.0, trailing: .zero))
                VStack(alignment: .leading) {
                    Text(R.string.localizable.settingsByeDPIStrategyTestDomainsStrategiesSection)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(R.color.grSecondary))
                    SettingsButtonView(title: R.string.localizable.settingsDomainsListOption(), text: R.string.localizable.settingsByeDPIStrategyTestDomainsOptionDesc(), leadingIcon: Image(R.image.icWorld), onPressed: {
                        if (showDomainListPickerSheet) {
                            return
                        }
                        showDomainListPickerSheet = true
                    })
                    .sheet(isPresented: $showDomainListPickerSheet, onDismiss: {
                        showDomainListPickerSheet = false
                    }, content: {
                        ListPickerScreen(lists: domainsManager.controller.domainLists.values.sorted(by: { a, b in
                            a.name.compare(b.name) == .orderedDescending
                        }), initCheckedListIDs: properties.byeDPITestConfig.domainListIDs, presented: $showDomainListPickerSheet) { lists, picked in
                            properties.byeDPITestConfig = properties.byeDPITestConfig.copyWith(domainListIDs: picked)
                            properties.save()
                        }
                    })
                    SettingsButtonView(title: R.string.localizable.settingsStrategiesListOption(), text: R.string.localizable.settingsByeDPIStrategyTestStrategiesOptionDesc(), leadingIcon: Image(R.image.icGridHexagon)) {
                        if (showStrategyListPickerSheet) {
                            return
                        }
                        showStrategyListPickerSheet = true
                    }
                    .sheet(isPresented: $showStrategyListPickerSheet, onDismiss: {
                        showStrategyListPickerSheet = false
                    }, content: {
                        ListPickerScreen(lists: strategiesManager.controller.strategyLists.values.sorted(by: { a, b in
                            a.name.compare(b.name) == .orderedAscending
                        }), initCheckedListIDs: properties.byeDPITestConfig.strategyListIDs, presented: $showStrategyListPickerSheet) { lists, picked in
                            properties.byeDPITestConfig = properties.byeDPITestConfig.copyWith(strategyListIDs: picked)
                            properties.save()
                        }
                    })
                }
                Rectangle()
                    .frame(width: 1.0, height: 12.0)
                    .opacity(0.0)
            }
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            delayBetweenReqeustsInS = String(properties.byeDPITestConfig.delayBetweenRequestsInS)
            domainRequestsCount = String(properties.byeDPITestConfig.domainRequestsCount)
            threadsCount = String(properties.byeDPITestConfig.parallelRequestsCount)
            domainAnswerTimeoutInS = String(properties.byeDPITestConfig.domainAnswerTimeoutInS)
        }
#if !os(tvOS)
        .navigationTitle(R.string.localizable.byeDPITestSettingsNavTitle())
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
#endif
    }
}

#if DEBUG
#Preview {
    NavigationView {
        ByeDPIStrategyTesterSettingsScreen()
    }
    .environmentObject(previewProperties)
    .environmentObject(previewDomainsManager)
    .environmentObject(previewStrategiesManager)
}
#endif
