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
    private let centerButtonViewModel: LocationButtonViewModel
    private let currentButtonViewModel: LocationButtonViewModel
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
        case centerLocation(VaccinationCenterLocation)
    }
    
    public var state: Observable<State> {
        Observable.merge(
            authorizationState(),
            centerButtonTap(),
            currentButtonTap())
    }
    
    var currentButtonTapInput: PublishRelay<Void> {
        currentButtonViewModel.tap
    }
    
    var centerButtonTapInput: PublishRelay<Void> {
        centerButtonViewModel.tap
    }
    
    // MARK: - Helpers
    
    private func authorizationState() -> Observable<State> {
        authorizationTrigger
            .flatMap { [authorization] in authorization() }
            .map { .available }
    }
    
    private func centerButtonTap() -> Observable<State> {
        let centerLocation = self.centerLocation
        
        return centerButtonViewModel.tap
            .map { .centerLocation(centerLocation) }
    }
    
    private func currentButtonTap() -> Observable<State> {
        currentButtonViewModel.tap
            .flatMap { [currentLocation] in currentLocation() }
            .map { .currentLocation($0) }
    }
}
