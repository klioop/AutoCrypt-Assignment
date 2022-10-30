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
import RxRelay
import MapKit

final class VaccinationCenterLocationViewModel: NSObject, CLLocationManagerDelegate {
    let coordinate: CLLocationCoordinate2D
    let span: MKCoordinateSpan
    let currentLocation: () -> CLLocation
    
    init(coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan, currentLocation: @escaping () -> CLLocation) {
        self.coordinate = coordinate
        self.span = span
        self.currentLocation = currentLocation
    }
}

final class VaccinationCenterMapViewModel {
    typealias AuthorizationStatus = LocationAuthorizationService.AuthorizationStatus
    let authorizationTrigger = PublishRelay<Void>()
    
    let locationViewModel: VaccinationCenterLocationViewModel
    let start: () -> Single<AuthorizationStatus>
    
    init(locationViewModel: VaccinationCenterLocationViewModel, start: @escaping () -> Single<AuthorizationStatus>) {
        self.locationViewModel = locationViewModel
        self.start = start
    }
    
    enum State: Equatable {
        static func == (lhs: VaccinationCenterMapViewModel.State, rhs: VaccinationCenterMapViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case let (.available(lhsRegion), .available(rhsRegion)):
                return (lhsRegion.center.latitude == rhsRegion.center.latitude) && (lhsRegion.center.longitude == rhsRegion.center.longitude)
                
            case let (.unavailable(lMessage), .unavailable(rMessage)):
                return lMessage == rMessage
                
            default:
                return false
            }
        }
        
        case unavailable(message: String)
        case unknown
        case available(region: MKCoordinateRegion)
    }
    
    var state: Observable<State> {
        Observable.merge(
            authorizationTrigger
                .flatMap { [start] in
                    start()
                }
                .map { [locationViewModel] status in
                    switch status {
                    case .denied, .unavailable:
                        return .unavailable(message: "위치 서비스 이용 불가능")
                        
                    case .available:
                        let location = locationViewModel.currentLocation()
                        return .available(region: .init(center: location.coordinate, span: locationViewModel.span))
                            
                        
                    default: return .unknown
                    }
                }
        )
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
    
    func test_init_startsWithEmptyState() {
        let (_, state) = makeSUT()
        
        XCTAssertEqual(state.values, [])
    }
    
    func test_triggerRequestAuthorization_sendsUnavailableStateWithMessageOnDenied() {
        let (sut, state) = makeSUT(status: .denied)
        
        sut.authorizationTrigger.accept(())
        
        XCTAssertEqual(state.values, [.unavailable(message: "위치 서비스 이용 불가능")])
    }
    
    func test_triggerRequestAuthorization_sendsUnavailableStateWithMessageOnUnavailable() {
        let (sut, state) = makeSUT(status: .unavailable)
        
        sut.authorizationTrigger.accept(())
        
        XCTAssertEqual(state.values, [.unavailable(message: "위치 서비스 이용 불가능")])
    }
    
    func test_triggerRequestAuthorization_sendsCurrentRegionStateWithMessageOnUnavailable() {
        let currentCoordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let currentRegion = MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let (sut, state) = makeSUT(currentCoordinate: currentCoordinate, status: .available)
        
        sut.authorizationTrigger.accept(())
        
        XCTAssertEqual(state.values, [.available(region: currentRegion)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0),
        span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01),
        coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 2.0, longitude: 2.0),
        status: Status = .denied,
        file: StaticString = #filePath,
        line: UInt = #line)
    -> (sut: VaccinationCenterMapViewModel, state: StateSpy) {
        let service = LocationServiceStub(status: status)
        let locationViewModel = VaccinationCenterLocationViewModel(coordinate: coordinate, span: span, currentLocation: { .init(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude) })
        let sut = VaccinationCenterMapViewModel(locationViewModel: locationViewModel, start: service.start)
        let state = StateSpy(sut.state)
        trackMemoryLeak(service, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        trackMemoryLeak(service, file: file, line: line)
        return (sut, state)
    }
    
    typealias Status = LocationAuthorizationService.AuthorizationStatus
    
    private class LocationServiceStub {
        private let status: Status
        
        init(status: Status) {
            self.status = status
        }
        
        func start() -> Single<Status> {
            return .just(status)
        }
    }
    
    private class StateSpy {
        private let bag = DisposeBag()
        private(set) var values = [VaccinationCenterMapViewModel.State]()
        
        init(_ observable: Observable<VaccinationCenterMapViewModel.State>) {
            observable
                .subscribe(onNext: { [weak self] in
                    self?.values.append($0)
                }).disposed(by: bag)
        }
    }
}
