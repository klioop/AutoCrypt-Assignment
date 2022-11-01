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
    public let authorizationTrigger = PublishRelay<Void>()
    
    private let locationViewModel: VaccinationCenterLocationViewModel
    let centerButtonViewModel: LocationButtonViewModel
    let currentButtonViewModel: LocationButtonViewModel
    private let authorization: () -> Single<Void>
    private let currentLocation: () -> Single<CLLocationCoordinate2D>
    
    public init(
        locationViewModel: VaccinationCenterLocationViewModel,
        centerButtonViewModel: LocationButtonViewModel,
        currentButtonViewModel: LocationButtonViewModel,
        authorization: @escaping () -> Single<Void>,
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
        
        case unAuthorized
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
            
        default:
            return true
        }
    }
    
    private func authorizationState() -> Observable<State> {
        authorizationTrigger
            .flatMap { [authorization] in
                authorization()
            }
            .map { .available }
    }
    
    private func centerButtonTap() -> Observable<State> {
        let coordinate = locationViewModel.coordinate
        
        let region = mkRegion(coordinate)
        return centerButtonViewModel.tap
            .map { .centerLocation(region: region) }
    }
    
    private func currentButtonTap() -> Observable<State> {
        currentButtonViewModel.tap
            .flatMap { [currentLocation] in
                currentLocation()
            }
            .map(mkRegion)
            .map { .currentLocation(region: $0) }
    }
    
    private func mkRegion(_ coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: locationViewModel.span)
    }
}
