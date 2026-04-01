import Foundation

/// Domain processing util
public final class SBDDomainUtil {

    /// Retrieve second-level domain (SLD)
    /// - Parameter domain: Domain
    /// - Returns: Second-level domain (SLD) form
    public static func retrieveSLD(_ domain: String) -> String? {
        let splitted = domain.split(separator: ".")
        if (splitted.count < 1) {
           //Possible not domain at all -> nil
            return nil
        }
        var processedDomain = String(splitted[splitted.count - 2]) + "." + String(splitted[splitted.count - 1])
        if (splitted.count >= 3 && (
            (splitted[splitted.count - 1] == "uk" && splitted[splitted.count - 2] == "co") ||
            (splitted[splitted.count - 1] == "ec" &&
             (splitted[splitted.count - 2] == "rus" || splitted[splitted.count - 2] == "ruc")
            ))) {
            //domain.co.uk or lib.rus.ec -> use 3 parts
            processedDomain = String(splitted[splitted.count - 3]) + "." + processedDomain
        }
        if (processedDomain.hasPrefix("http")) {
            processedDomain = processedDomain.replacingOccurrences(of: "http://", with: "").replacingOccurrences(of: "https://", with: "")
        }
        if (processedDomain.isEmpty) {
            return nil
        }
        return processedDomain
    }
    
    fileprivate init() {}
}
