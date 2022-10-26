//
//  LocationAuthorizationServiceTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/26.
//

import XCTest

final class LocationAuthorizationService {
    private(set) var completion: (() -> Void)?
}

class LocationAuthorizationServiceTests: XCTestCase {
    
    func test_init_configures() {
        let sut = LocationAuthorizationService()
        
        XCTAssertNil(sut.completion)
    }
}
