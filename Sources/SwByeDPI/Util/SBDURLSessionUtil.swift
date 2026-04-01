//
//  SBDURLSessionUtil.swift
//  SwByeDPI
//
//  Created by developer on 19.02.2026.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// URL Session utils
public final class SBDURLSessionUtil {

    //"kCF.." defs error at non-Apple swift SDK
    //Fix - set direct values from https://github.com/apple-oss-distributions/CF/blob/main/CFSocketStream.c
    
    private init() {}
    
    /// Creates URL session with HTTP proxy settings
    /// - Parameters:
    ///   - addr: HTTP proxy address
    ///   - port: HTTP proxy port
    /// - Returns: URL Session with HTTP proxy settings
    public static func initHttpProxySession(addr: String, port: UInt16) -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.connectionProxyDictionary = [
            "HTTPSEnable": 1,//kCFNetworkProxiesHTTPEnable as String: 1,
            "HTTPSProxy": addr,//kCFNetworkProxiesHTTPProxy as String: addr,
            "HTTPSPort": port,//kCFNetworkProxiesHTTPPort as String: port,
        ]
        let session = URLSession(configuration: configuration)
        return session
    }
    
    /// Creates URL Session with SOCKS5 proxy settings
    /// - Parameters:
    ///   - addr: SOCKS5 proxy address
    ///   - port: SOCKS5 proxy port
    /// - Returns: URL Session with SOCKS5 proxy settings
    public static func initSocksProxySession(addr: String, port: UInt16) -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.connectionProxyDictionary = [
            //kCFNetworkProxiesSOCKSEnable: true,
            //kCFNetworkProxiesSOCKSProxy: addr,
            //kCFNetworkProxiesSOCKSPort: port,
            "SOCKSEnable": true,//kCFStreamPropertySOCKSProxyHost: true,
            "SOCKSProxy": addr,//kCFStreamPropertySOCKSProxyPort: addr,
            "SOCKSPort": port,//kCFStreamPropertySOCKSProxyPort: port,
            "kCFStreamPropertySOCKSVersion": "kCFStreamSocketSOCKSVersion5",//kCFStreamPropertySOCKSVersion: kCFStreamSocketSOCKSVersion5
        ]
        
        let session = URLSession(configuration: configuration)
        return session
    }
    
}
