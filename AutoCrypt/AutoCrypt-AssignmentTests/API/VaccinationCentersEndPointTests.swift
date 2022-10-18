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
        let get = VaccinationCenterListEndPoint.get
        let url = get.url(with: baseURL)
        
        XCTAssertEqual(url.scheme, baseURL.scheme, "scheme")
        XCTAssertEqual(url.host, baseURL.host, "host")
        XCTAssertEqual(url.path, "/15077586/v1/centers")
        XCTAssertEqual(url.query?.contains("serviceKey="+get.serviceKey.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!), true, "service key query")
    }
}
