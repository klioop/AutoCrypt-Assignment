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
         
        case .authorizedWhenInUse, .authorizedAlways:
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
      
        expect(sut, toCompletedWith: .denied)
    }
    
    func test_start_deliversUnavailableWhenLocationServiceIsUnavailable() {
        let sut = makeSUT(stubStatus: .restricted)
        
        expect(sut, toCompletedWith: .unavailable)
    }
    
    func test_start_deliversAvailableWhenLocationServiceIsAvailableInUse() {
        let sut = makeSUT(stubStatus: .authorizedWhenInUse)
        
        expect(sut, toCompletedWith: .available)
    }
    
    func test_start_deliversAvailableWhenLocationServiceIsAvailableAlways() {
        let sut = makeSUT(stubStatus: .authorizedAlways)
        
        expect(sut, toCompletedWith: .available)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(stubStatus: CLAuthorizationStatus = .notDetermined, file: StaticString = #filePath, line: UInt = #line) -> LocationAuthorizationService {
        let manager = LocationManagerStub(stubStatus: stubStatus)
        let sut = LocationAuthorizationService(manager: manager)
        trackMemoryLeak(manager, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: LocationAuthorizationService, toCompletedWith expectedStatus: LocationAuthorizationService.AuthorizationStatus, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for start completion")
        sut.start { receivedStatus in
            XCTAssertEqual(receivedStatus, expectedStatus)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
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
