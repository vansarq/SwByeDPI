//
//  Notification+TestingEvents.swift
//  SwByeDPI
//
//  Created by developer on 20.02.2026.
//

import Foundation

extension Notification.Name {
    
    /// DPI-evasion strategies test progress update event. Payload (User info) contains "tested": Int and "total": Int
    public static let SBDTestingProgressUpdate = Notification.Name(SBDTestController.testingProgressUpdateEventName)
    
    /// DPI-evasion currently testing strategy update event.  Payload (User info) contains "strategy": SBDStrategy
    public static let SBDTestingStrategyUpdate = Notification.Name(SBDTestController.testingStrategyUpdateEventName)
    
    /// No testing DPI-evasion strategy event
    public static let SBDNoTestingStrategy = Notification.Name(SBDTestController.noTestingStrategyUpdateEventName)
    
    /// DPI-evasion currently testing strategy progress through domains update event. Payload (User info) contains "successDomainRequestsCount": Int, "failDomainRequestsCount": Int and "totalDomainRequestsCount": Int. notification.object is a SBDStrategy.id (Int)
    public static let SBDTestingStrategyProgressUpdate = Notification.Name(SBDTestController.testingStrategyProgressUpdateEventName)
    
    /// DPI-evasion strategy testing progress (checked domains) update event = Payload (User info) contains "tested": Int and "total": Int. notification.object is a SBDStrategy.id (Int)
    public static let SBDTestingStrategyDomainsProgressUpdate = Notification.Name(SBDTestController.testingStrategyDomainsProgressUpdateEventName)
    
    /// DPI-evasion domain checking progress (requests count) update event. Payload (User info) contains "success": UInt8, "fail": UInt8, "tested": Int and "total": Int. notification.object is a String (strategyDomainLink.id)
    public static let SBDTestingDomainProgress = Notification.Name(SBDTestController.testingDomainProgressUpdateEventName)
    
    /// DPI-evasion strategy test finish event. Payload (User info) contains "result": SBDStrategyTestResult. notification.object is a SBDStrategy.id (Int)
    public static let SBDTestedStrategy = Notification.Name(SBDTestController.testedStrategyEventName)
    
    /// DPI-evasion strategy domain test finish event. Payload (User info) contains "result": SBDDomainTestResult. notification.object is a SBDStrategy.id (Int)
    public static let SBDTestedStrategyDomain = Notification.Name(SBDTestController.testedStrategyDomainEventName)
}
