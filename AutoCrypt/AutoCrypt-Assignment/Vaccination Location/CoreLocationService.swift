//
//  CoreLocationService.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/28.
//

import Foundation
import CoreLocation

public final class CoreLocationService: NSObject, CLLocationManagerDelegate, LocationAuthorizationService, CurrentLocationService {
    public enum Error: Swift.Error {
        case denied
        case unavailable
        case unknown
    }
    
    private let manager: CLLocationManager
    
    public init(manager: CLLocationManager) {
        self.manager = manager
    }
    
    private(set) public var authorizationCompletion: ((LocationAuthorizationService.Result) -> Void)?
    private(set) public var currentLocationCompletion: ((CurrentLocationService.Result) -> Void)?
    
    public func startAuthorization(completion: @escaping (LocationAuthorizationService.Result) -> Void) {
        manager.delegate = self
        self.authorizationCompletion = completion
    }
    
    public func currentLocation(completion: @escaping (CurrentLocationService.Result) -> Void) {
        manager.startUpdatingLocation()
        self.currentLocationCompletion = completion
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocationCompletion?(.success(location.coordinate))
        manager.stopUpdatingLocation()
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            authorizationCompletion?(.failure(Error.denied))
            
        case .restricted:
            authorizationCompletion?(.failure(Error.unavailable))
         
        case .authorizedWhenInUse, .authorizedAlways:
            authorizationCompletion?(.success(()))
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        @unknown default:
            authorizationCompletion?(.failure(Error.unknown))
        }
    }
}
