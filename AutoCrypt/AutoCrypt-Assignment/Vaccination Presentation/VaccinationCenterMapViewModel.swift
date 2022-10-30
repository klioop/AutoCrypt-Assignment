//
//  VaccinationCenterMapViewModel.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import MapKit
import CoreLocation
import RxSwift
import RxRelay

public struct VaccinationCenterLocationViewModel {
    public let coordinate: CLLocationCoordinate2D
    public let span: MKCoordinateSpan
    public let currentLocation: () -> CLLocation
    
    public init(coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan, currentLocation: @escaping () -> CLLocation) {
        self.coordinate = coordinate
        self.span = span
        self.currentLocation = currentLocation
    }
}

public struct LocationButtonViewModel {
    public let tap = PublishRelay<Void>()
    
    public init() {}
}

public final class VaccinationCenterMapViewModel {
    public typealias AuthorizationStatus = LocationAuthorizationService.AuthorizationStatus
    
    public let authorizationTrigger = PublishRelay<Void>()
    
    let locationViewModel: VaccinationCenterLocationViewModel
    let vaccinationButtonViewModel: LocationButtonViewModel
    let currentButtonViewModel: LocationButtonViewModel
    let start: () -> Single<AuthorizationStatus>
    
    public init(
        locationViewModel: VaccinationCenterLocationViewModel,
        vaccinationButtonViewModel: LocationButtonViewModel,
        currentButtonViewModel: LocationButtonViewModel,
        start: @escaping () -> Single<AuthorizationStatus>) {
            self.locationViewModel = locationViewModel
            self.vaccinationButtonViewModel = vaccinationButtonViewModel
            self.currentButtonViewModel = currentButtonViewModel
            self.start = start
    }
    
    public enum State: Equatable {
        public static func == (lhs: VaccinationCenterMapViewModel.State, rhs: VaccinationCenterMapViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case let (.location(lhsRegion), .location(rhsRegion)):
                return (lhsRegion.center.latitude == rhsRegion.center.latitude) && (lhsRegion.center.longitude == rhsRegion.center.longitude)
                
            case let (.unavailable(lMessage), .unavailable(rMessage)):
                return lMessage == rMessage
                
            default:
                return false
            }
        }
        
        case unavailable(message: String)
        case unknown
        case location(region: MKCoordinateRegion)
    }
    
    public var state: Observable<State> {
        Observable.merge(
            authorizationState(),
            vaccinationButtonViewModel
                .tap
                .map { [locationViewModel] in
                    .location(region: .init(center: locationViewModel.coordinate, span: locationViewModel.span))},
            currentButtonViewModel
                .tap
                .map { [locationViewModel] in
                    let location = locationViewModel.currentLocation()
                    return .location(region: .init(center: location.coordinate, span: locationViewModel.span))}
        )
    }
    
    private func authorizationState() -> Observable<State> {
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
                    return .location(region: .init(center: location.coordinate, span: locationViewModel.span))
                        
                default: return .unknown
                }
            }

    }
}

public extension LocationAuthorizationService {
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
