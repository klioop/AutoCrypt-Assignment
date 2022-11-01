//
//  VaccinationCenterMapViewModel.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import RxSwift
import RxRelay

public final class VaccinationCenterMapViewModel {
    public let authorizationTrigger = PublishRelay<Void>()
    
    private let centerLocation: VaccinationCenterLocation
    let centerButtonViewModel: LocationButtonViewModel
    let currentButtonViewModel: LocationButtonViewModel
    private let authorization: () -> Single<Void>
    private let currentLocation: () -> Single<CoordinateViewModel>
    
    public init(
        centerLocation: VaccinationCenterLocation,
        centerButtonViewModel: LocationButtonViewModel,
        currentButtonViewModel: LocationButtonViewModel,
        authorization: @escaping () -> Single<Void>,
        currentLocation: @escaping () -> Single<CoordinateViewModel>) {
            self.centerLocation = centerLocation
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
            .flatMap { [authorization] in authorization() }
            .map { .available }
    }
    
    private func centerButtonTap() -> Observable<State> {
        let coordinate = centerLocation.coordinate
        
        return centerButtonViewModel.tap
            .map { .centerLocation(CoordinateViewModel(coordinate: coordinate)) }
    }
    
    private func currentButtonTap() -> Observable<State> {
        currentButtonViewModel.tap
            .flatMap { [currentLocation] in currentLocation() }
            .map { .currentLocation($0) }
    }
}
