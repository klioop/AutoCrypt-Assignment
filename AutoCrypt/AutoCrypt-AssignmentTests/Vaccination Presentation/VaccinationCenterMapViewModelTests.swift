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

final class VaccinationCenterMapViewModel {
    typealias AuthorizationStatus = LocationAuthorizationService.AuthorizationStatus
    let authorizationTrigger = PublishRelay<Void>()
    
    let start: () -> Single<AuthorizationStatus>
    
    init(start: @escaping () -> Single<AuthorizationStatus>) {
        self.start = start
    }
    
    enum State: Equatable {
        case unavailable(message: String)
    }
    
    var state: Observable<State> {
        Observable.merge(
            authorizationTrigger
                .flatMap { [start] in
                    start()
                }
                .map { _ in .unavailable(message: "위치 서비스 이용 불가능") }
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
    
    func test_triggerRequestAuthorization_sendsUnavailableStateWithMessage() {
        let (sut, state) = makeSUT(status: .denied)
        
        sut.authorizationTrigger.accept(())
        
        XCTAssertEqual(state.values, [.unavailable(message: "위치 서비스 이용 불가능")])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(status: Status = .denied, file: StaticString = #filePath, line: UInt = #line) -> (sut: VaccinationCenterMapViewModel, state: StateSpy) {
        let service = LocationServiceStub(status: status)
        let sut = VaccinationCenterMapViewModel(start: service.start)
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
