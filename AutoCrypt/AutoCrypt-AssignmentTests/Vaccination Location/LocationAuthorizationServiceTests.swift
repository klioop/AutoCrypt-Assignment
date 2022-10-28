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
        case unavailable
        case available
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
            
        case .restricted:
            completion?(.unavailable)
         
        case .authorizedWhenInUse:
            completion?(.available)
            
        default: break
        }
    }
    
}

class LocationAuthorizationServiceTests: XCTestCase {
    
    func test_init_configures() {
        let sut = makeSUT()
        
        XCTAssertNil(sut.completion)
    }
    
    func test_start_captureCompletion() {
        let sut = makeSUT()
        
        sut.start { _ in }
        
        XCTAssertNotNil(sut.completion)
    }
    
    func test_start_deliversDeniedForLocationServiceIsDenied() {
        let sut = makeSUT(stubStatus: .denied)
        
        let exp = expectation(description: "wait for start completion")
        sut.start { status in
            XCTAssertEqual(status, .denied)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_start_deliversUnavailableWhenLocationServiceIsUnavailable() {
        let sut = makeSUT(stubStatus: .restricted)
        
        let exp = expectation(description: "wait for start completion")
        sut.start { status in
            XCTAssertEqual(status, .unavailable)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_start_deliversAvailableWhenLocationServiceIsAvailable() {
        let sut = makeSUT(stubStatus: .authorizedWhenInUse)
        
        let exp = expectation(description: "wait for start completion")
        sut.start { status in
            XCTAssertEqual(status, .available)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(stubStatus: CLAuthorizationStatus = .notDetermined, file: StaticString = #filePath, line: UInt = #line) -> LocationAuthorizationService {
        let manager = LocationManagerStub(stubStatus: stubStatus)
        let sut = LocationAuthorizationService(manager: manager)
        trackMemoryLeak(manager, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
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
