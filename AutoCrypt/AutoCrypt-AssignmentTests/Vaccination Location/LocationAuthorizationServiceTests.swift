//
//  LocationAuthorizationServiceTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/26.
//

import XCTest
import CoreLocation

final class LocationAuthorizationService: NSObject, CLLocationManagerDelegate {
    enum AuthorizationStatus {
        case denied
    }
    
    private let manager: CLLocationManager
    
    init(manager: CLLocationManager) {
        self.manager = manager
    }
    
    private(set) var completion: ((AuthorizationStatus) -> Void)?
    
    func start(completion: @escaping (AuthorizationStatus) -> Void) {
        manager.delegate = self
        self.completion = completion
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            completion?(.denied)
            
        default: break
        }
    }
    
}

class LocationAuthorizationServiceTests: XCTestCase {
    
    func test_init_configures() {
        let manager = LocationManagerStub(stubStatus: .denied)
        let sut = LocationAuthorizationService(manager: manager)
        
        XCTAssertNil(sut.completion)
    }
    
    func test_start_captureCompletion() {
        let manager = LocationManagerStub(stubStatus: .denied)
        let sut = LocationAuthorizationService(manager: manager)
        
        sut.start { _ in }
        
        XCTAssertNotNil(sut.completion)
    }
    
    func test_start_deliversDeniedForLocationServiceIsDenied() {
        let manager = LocationManagerStub(stubStatus: .denied)
        let sut = LocationAuthorizationService(manager: manager)
        
        let exp = expectation(description: "wait for start completion")
        sut.start { status in
            XCTAssertEqual(status, .denied)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private class LocationManagerStub: CLLocationManager {
        let stubStatus: CLAuthorizationStatus
        
        init(stubStatus: CLAuthorizationStatus) {
            self.stubStatus = stubStatus
        }
        
        override var authorizationStatus: CLAuthorizationStatus {
            stubStatus
        }
    }
}
