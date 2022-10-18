//
//  VaccinationCentersEndPointTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/18.
//

import XCTest
import AutoCrypt_Assignment

class VaccinationCentersEndPointTests: XCTestCase {
    
    func test_vaccinationCenterListEndPointURLTests() {
        let baseURL = URL(string: "https://base-url.com")!
        let get = VaccinationCenterListEndPoint.get()
        let url = get.url(with: baseURL)
        
        XCTAssertEqual(url.scheme, baseURL.scheme, "scheme")
        XCTAssertEqual(url.host, baseURL.host, "host")
        XCTAssertEqual(url.path, "/15077586/v1/centers")
        XCTAssertEqual(url.query?.contains("page=1"), true, "page query")
        XCTAssertEqual(url.query?.contains("serviceKey=\(get.serviceKey)"), true, "service key query")
    }
    
    func test_vaccinationCenterListEndPointURLWithPageTests() {
        let baseURL = URL(string: "https://base-url.com")!
        let page = 3
        let get = VaccinationCenterListEndPoint.get(page)
        let url = get.url(with: baseURL)
        
        XCTAssertEqual(url.scheme, baseURL.scheme, "scheme")
        XCTAssertEqual(url.host, baseURL.host, "host")
        XCTAssertEqual(url.path, "/15077586/v1/centers")
        XCTAssertEqual(url.query?.contains("page=\(page)"), true, "page query")
        XCTAssertEqual(url.query?.contains("serviceKey=\(get.serviceKey)"), true, "service key query")
    }
}
