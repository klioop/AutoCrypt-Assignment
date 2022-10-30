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
    public typealias AuthorizationStatus = LocationAuthorizationService.AuthorizationStatus
    
    public let authorizationTrigger = PublishRelay<Void>()
    
    private let locationViewModel: VaccinationCenterLocationViewModel
    let vaccinationButtonViewModel: LocationButtonViewModel
    let currentButtonViewModel: LocationButtonViewModel
    private let start: () -> Single<AuthorizationStatus>
    
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
            isSame(lhs, rhs)
        }
        
        case unavailable(message: String)
        case unknown
        case available
        case currentLocation(region: MKCoordinateRegion)
        case vaccinationLocation(region: MKCoordinateRegion)
    }
    
    public var state: Observable<State> {
        Observable.merge(
            authorizationState(),
            centerButtonTap(),
            currentButtonTap()
        )
    }
    
    // MARK: - Helpers
    
    private static func isSame(_ lhs: VaccinationCenterMapViewModel.State, _ rhs: VaccinationCenterMapViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case let (.currentLocation(lhsRegion), .currentLocation(rhsRegion)):
            return (lhsRegion.center.latitude == rhsRegion.center.latitude) && (lhsRegion.center.longitude == rhsRegion.center.longitude)
            
        case let (.vaccinationLocation(lhsRegion), .vaccinationLocation(rhsRegion)):
            return (lhsRegion.center.latitude == rhsRegion.center.latitude) && (lhsRegion.center.longitude == rhsRegion.center.longitude)
            
        case let (.unavailable(lMessage), .unavailable(rMessage)):
            return lMessage == rMessage
            
        default:
            return true
        }
    }
    
    private func authorizationState() -> Observable<State> {
        authorizationTrigger
            .flatMap { [start] in
                start()
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
        
        return vaccinationButtonViewModel.tap
            .map { [mkRegion] in
                .vaccinationLocation(region: mkRegion(coordinate))}
    }
    
    private func currentButtonTap() -> Observable<State> {
        currentButtonViewModel.tap
            .flatMap { [locationViewModel] in
                locationViewModel.currentLocation()
            }
            .map { [mkRegion] in .currentLocation(region: mkRegion($0)) }
    }
    
    private func mkRegion(_ coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: locationViewModel.span)
    }
}
