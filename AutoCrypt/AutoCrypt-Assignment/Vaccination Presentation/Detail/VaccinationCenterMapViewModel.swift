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

public struct CoordinateViewModel: Equatable {
    public let coordinate: CLLocationCoordinate2D
    
    public init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    public static func ==(lhs: CoordinateViewModel, rhs: CoordinateViewModel) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

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
        case unAuthorized
        case available
        case currentLocation(CoordinateViewModel)
        case centerLocation(CoordinateViewModel)
    }
    
    public var state: Observable<State> {
        Observable.merge(
            authorizationState(),
            centerButtonTap(),
            currentButtonTap())
    }
    
    // MARK: - Helpers
    
    private func authorizationState() -> Observable<State> {
        authorizationTrigger
            .flatMap { [authorization] in
                authorization()
            }
            .map { .available }
    }
    
    private func centerButtonTap() -> Observable<State> {
        let coordinate = locationViewModel.coordinate
        
        return centerButtonViewModel.tap
            .map { .centerLocation(CoordinateViewModel(coordinate: coordinate)) }
    }
    
    private func currentButtonTap() -> Observable<State> {
        currentButtonViewModel.tap
            .flatMap { [currentLocation] in
                currentLocation()
            }
            .map { .currentLocation(CoordinateViewModel(coordinate: $0)) }
    }
    
    private func mkRegion(_ coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: locationViewModel.span)
    }
}
