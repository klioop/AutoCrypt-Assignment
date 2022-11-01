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

class VaccinationCenterMapViewModelTests: XCTestCase {
    
    func test_init_startsWithEmptyState() {
        let (_, state, _) = makeSUT()
        
        XCTAssertEqual(state.values, [])
    }
    
    func test_triggerRequestAuthorization_sendsLocationStateWithCurrentRegionOnAvailable() {
        let (sut, state, _) = makeSUT(status: .success(()))
        
        sut.authorizationTrigger.accept(())
        
        XCTAssertEqual(state.values, [.available])
    }
    
    func test_vaccinationCenterLocationButtonTap_sendsLocationStateWithVaccinationCenterLocation() {
        let centerLocation = CLLocationCoordinate2D(latitude: 4.0, longitude: 5.0)
        let viewModel = CoordinateViewModel(coordinate: centerLocation)
        let (_, state, buttons) = makeSUT(coordinate: centerLocation)
        
        buttons.vaccination.tap.accept(())
        
        XCTAssertEqual(state.values, [.centerLocation(viewModel)])
    }
    
    func test_currentLocationButtonTap_sendsLocationStateWithCurrentRegion() {
        let currentCoordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let viewModel = CoordinateViewModel(coordinate: currentCoordinate)
        let (_, state, buttons) = makeSUT(currentCoordinate: currentCoordinate, status: .success(()))
        
        buttons.current.tap.accept(())
        
        XCTAssertEqual(state.values, [.currentLocation(viewModel)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        currentCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0),
        coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 2.0, longitude: 2.0),
        status: Result<Void, Error> = .failure(anyNSError()),
        file: StaticString = #filePath,
        line: UInt = #line)
    -> (sut: VaccinationCenterMapViewModel,
        state: StateSpy,
        buttons: (vaccination: LocationButtonViewModel, current: LocationButtonViewModel)) {
        let vaccinationButton = LocationButtonViewModel()
        let currentButton = LocationButtonViewModel()
        let service = LocationServiceStub(status: status)
        let locationViewModel = VaccinationCenterLocation(coordinate: coordinate)
        let sut = VaccinationCenterMapViewModel(centerLocation: locationViewModel,
                                                centerButtonViewModel: vaccinationButton,
                                                currentButtonViewModel: currentButton,
                                                authorization: service.start,
                                                currentLocation: { .just(CoordinateViewModel(coordinate: currentCoordinate)) })
        let state = StateSpy(sut.state)
        trackMemoryLeak(service, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        trackMemoryLeak(service, file: file, line: line)
        return (sut, state, (vaccinationButton, currentButton))
    }
    
    private class LocationServiceStub {
        private let status: Result<Void, Error>
        
        init(status: Result<Void, Error>) {
            self.status = status
        }
        
        func start() -> Single<Void> {
            if let _ = try? status.get() {
                return .just(())
            } else {
                return .error(anyNSError())
            }
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
