import AppIntents

@available(macOS 13.0, iOS 16.0, tvOS 17.0, *)
///Toggle network extension VPN (ByeDPI SOCKS to TUN) shortcut
struct ToggleByeDPIVPNIntent: SetValueIntent {
    
    static let title = LocalizedStringResource("appIntentToggleByeDPIVPNTitle", defaultValue: "Toggle ByeByeDPI", table: "AppIntent")
    static let description = IntentDescription(LocalizedStringResource("appIntentToggleByeDPIVPNDesc", defaultValue: "Toggles ByeByeDPI and VPN TUNNEL session state", table: "AppIntent"))
    
    @Parameter(title: LocalizedStringResource("appIntentToggleByeDPIVPRunngingParamTitle", defaultValue: "On/Off state", table: "AppIntent"))
    var value: Bool
    
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
        if (value) {
            // Start VPN
            let res = try await StartByeDPIVPNIntent().perform()
            return .result(value: res.value ?? false)
        } else {
            // Stop VPN
            _ = try await StopByeDPIVPNIntent().perform()
        }
        return .result(value: true)
    }
}
