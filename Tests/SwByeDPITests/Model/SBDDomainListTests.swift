//
//  SBDConfigTests.swift
//  SwByeDPI
//
//  Created by developer on 02.03.2026.
//

import XCTest
@testable import SwByeDPI

final class SBDDomainListTests: XCTestCase {

    static fileprivate let testDomains = Set<String>([
        "google.com",
        "google.co",
        "google.uk",
        "google.co.uk",
        "www.site.com",
        "https://another.com",
        "https://www.other.com",
        "http://unsafe.com",
        "subdomain.s.foo.com",
        "lib.ruc.ec"
    ])

    static fileprivate let expectedDomains = Set<String>([
        "google.com",
        "google.co",
        "google.uk",
        "google.co.uk",
        "site.com",
        "another.com",
        "other.com",
        "unsafe.com",
        "foo.com",
        "lib.ruc.ec"
    ])
    
    func testRetrieveSLDList() {

        let list = SBDDomainList(name: "Test", domains: SBDDomainListTests.testDomains)
        let filteredList = list.retrieveSLDList()
        
        XCTAssertEqual(SBDDomainListTests.expectedDomains, filteredList.domains, "Invalid SDL retriever")

    }
    
    /*func testFilterAndTestHostsGenerator() {
        let expected = TelegramFilterHosts.domainsList
        var actual = expected.retrieveSLDList()
        
        XCTAssertEqual(expected.domains, actual.domains, "Invalid filter hosts generator. Expected the same set")
        
        actual = TelegramTestDomains.domainsList.retrieveSLDList()
        
        XCTAssertEqual(expected.domains, actual.domains, "Invalid SDL retriever")
    }*/
}
