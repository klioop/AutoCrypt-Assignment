//
//  LocationAuthorizationServiceTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/26.
//

import XCTest
import AutoCrypt_Assignment
import CoreLocation

class LocationAuthorizationServiceTests: XCTestCase {
    
    func test_init_configures() {
        let sut = makeSUT()
        
        XCTAssertNil(sut.authorizationCompletion)
    }
    
    func test_start_captureCompletion() {
        let sut = makeSUT()
        
        sut.startAuthorization { _ in }
        
        XCTAssertNotNil(sut.authorizationCompletion)
    }
    
    func test_start_deliversDeniedForLocationServiceIsDenied() {
        let sut = makeSUT(stubStatus: .denied)
      
        expect(sut, toCompletedWith: .failure(anyNSError()))
    }
    
    func test_start_deliversUnavailableWhenLocationServiceIsUnavailable() {
        let sut = makeSUT(stubStatus: .restricted)
        
        expect(sut, toCompletedWith: .failure(anyNSError()))
    }
    
    func test_start_deliversAvailableWhenLocationServiceIsAvailableInUse() {
        let sut = makeSUT(stubStatus: .authorizedWhenInUse)
        
        expect(sut, toCompletedWith: .success(()))
    }
    
    func test_start_deliversAvailableWhenLocationServiceIsAvailableAlways() {
        let sut = makeSUT(stubStatus: .authorizedAlways)
        
        expect(sut, toCompletedWith: .success(()))
    }
    
    func test_start_requestsWhenInUseAuthorizationOnNotDetermined() {
        let manager = LocationManagerStub(stubStatus: .notDetermined)
        let sut = CoreLocationService(manager: manager)
        
        sut.startAuthorization { _ in }
        manager.delegate?.locationManagerDidChangeAuthorization?(manager)
        
        XCTAssertEqual(manager.whenInUseAuthorizationRequestCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(stubStatus: CLAuthorizationStatus = .notDetermined, file: StaticString = #filePath, line: UInt = #line) -> CoreLocationService {
        let manager = LocationManagerStub(stubStatus: stubStatus)
        let sut = CoreLocationService(manager: manager)
        trackMemoryLeak(manager, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: CoreLocationService, toCompletedWith expectedResult: LocationAuthorizationService.Result, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for start completion")
        sut.startAuthorization { receivedResult in
            if case let .failure(receivedError) = receivedResult {
                XCTAssertNotNil(receivedError)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private class LocationManagerStub: CLLocationManager {
        var whenInUseAuthorizationRequestCallCount = 0
        
        var stubStatus: CLAuthorizationStatus
        
        init(stubStatus: CLAuthorizationStatus) {
            self.stubStatus = stubStatus
        }
        
        override var authorizationStatus: CLAuthorizationStatus {
            stubStatus
        }
        
        override func requestWhenInUseAuthorization() {
            whenInUseAuthorizationRequestCallCount += 1
        }
    }
}
