//
//  VaccinationCenterMapViewModelTests.swift
//  AutoCrypt-AssignmentTests
//
//  Created by klioop on 2022/10/30.
//

import XCTest
import AutoCrypt_Assignment
import CoreLocation
import RxSwift

final class VaccinationCenterMapViewModel {
    typealias AuthorizationStatus = LocationAuthorizationService.AuthorizationStatus
    
    let start: () -> Single<AuthorizationStatus>
    
    init(start: @escaping () -> Single<AuthorizationStatus>) {
        self.start = start
    }
}

extension LocationAuthorizationService {
    enum Error: Swift.Error {
        case unavailable
        case unRepresented
    }
    
    func start() -> Single<AuthorizationStatus> {
        Single.create { observer in
            self.start { status in
                observer(Result {
                    switch status {
                    case .denied, .unavailable:
                        throw Error.unavailable
                        
                    case .unknown:
                        throw Error.unRepresented
                        
                    case .available:
                        return status
                    }
                })
            }
            return Disposables.create()
        }
    }
}

class VaccinationCenterMapViewModelTests: XCTestCase {
    
    func test_init_doesNotRequestLocationAuthorization() {
        let manager = CLLocationManager()
        let service = LocationServiceStub(status: .denied)
        let sut = VaccinationCenterMapViewModel(start: service.start)
        
        XCTAssertEqual(service.startCallCount, 0)
    }
    
    // MARK: - Helpers
    
    private class LocationServiceStub {
        typealias Status = LocationAuthorizationService.AuthorizationStatus
        var startCallCount = 0
        
        let status: Status
        
        init(status: Status) {
            self.status = status
        }
        
        func start() -> Single<Status> {
            startCallCount += 1
            return .just(status)
        }
    }
}
