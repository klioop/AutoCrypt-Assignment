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
    private let vaccinationButtonViewModel: LocationButtonViewModel
    private let currentButtonViewModel: LocationButtonViewModel
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
            tap(on: vaccinationButtonViewModel, with: locationViewModel.coordinate),
            tap(on: currentButtonViewModel, with: locationViewModel.currentLocation().coordinate)
        )
    }
    
    // MARK: - Helpers
    
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
    
    private func tap(on viewModel: LocationButtonViewModel, with coordinate: CLLocationCoordinate2D) -> Observable<State> {
        viewModel
            .tap
            .map { [mkRegion] in
                .location(region: mkRegion(coordinate))}
    }
    
    private func mkRegion(_ coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, span: locationViewModel.span)
    }
}
