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

public final class VaccinationCenterMapViewModel {
    public typealias AuthorizationStatus = CoreLocationService.AuthorizationStatus
    
    public let authorizationTrigger = PublishRelay<Void>()
    
    private let locationViewModel: VaccinationCenterLocationViewModel
    let centerButtonViewModel: LocationButtonViewModel
    let currentButtonViewModel: LocationButtonViewModel
    private let authorization: () -> Single<AuthorizationStatus>
    private let currentLocation: () -> Single<CLLocationCoordinate2D>
    
    public init(
        locationViewModel: VaccinationCenterLocationViewModel,
        centerButtonViewModel: LocationButtonViewModel,
        currentButtonViewModel: LocationButtonViewModel,
        authorization: @escaping () -> Single<AuthorizationStatus>,
        currentLocation: @escaping () -> Single<CLLocationCoordinate2D>) {
            self.locationViewModel = locationViewModel
            self.centerButtonViewModel = centerButtonViewModel
            self.currentButtonViewModel = currentButtonViewModel
            self.authorization = authorization
            self.currentLocation = currentLocation
    }
    
    public enum State: Equatable {
        public static func == (lhs: VaccinationCenterMapViewModel.State, rhs: VaccinationCenterMapViewModel.State) -> Bool {
            isSame(lhs, rhs)
        }
        
        case unavailable(message: String)
        case unknown
        case available
        case currentLocation(region: MKCoordinateRegion)
        case centerLocation(region: MKCoordinateRegion)
    }
    
    public var state: Observable<State> {
        Observable.merge(
            authorizationState(),
            centerButtonTap(),
            currentButtonTap())
    }
    
    // MARK: - Helpers
    
    private static func isSame(_ lhs: VaccinationCenterMapViewModel.State, _ rhs: VaccinationCenterMapViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case let (.currentLocation(lhsRegion), .currentLocation(rhsRegion)):
            return (lhsRegion.center.latitude == rhsRegion.center.latitude) && (lhsRegion.center.longitude == rhsRegion.center.longitude)
            
        case let (.centerLocation(lhsRegion), .centerLocation(rhsRegion)):
            return (lhsRegion.center.latitude == rhsRegion.center.latitude) && (lhsRegion.center.longitude == rhsRegion.center.longitude)
            
        case let (.unavailable(lMessage), .unavailable(rMessage)):
            return lMessage == rMessage
            
        default:
            return true
        }
    }
    
    private func authorizationState() -> Observable<State> {
        authorizationTrigger
            .flatMap { [weak self] in
                self?.authorization() ?? .just(.unknown)
            }
            .map { status in
                switch status {
                case .denied, .unavailable:
                    return .unavailable(message: "위치 서비스 이용 불가능")
                    
                case .available:
                    return .available
                        
                default: return .unknown
                }
            }
    }
    
    private func centerButtonTap() -> Observable<State> {
        let coordinate = locationViewModel.coordinate
        
        let region = mkRegion(coordinate)
        return centerButtonViewModel.tap
            .map { .centerLocation(region: region) }
    }
    
    private func currentButtonTap() -> Observable<State> {
        currentButtonViewModel.tap
            .flatMap { [weak self] in
                self?.currentLocation() ?? .just(.init(latitude: 1.00, longitude: 1.00))
            }
            .map(mkRegion)
            .map { .currentLocation(region: $0) }
    }
    
    private func mkRegion(_ coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: locationViewModel.span)
    }
}
