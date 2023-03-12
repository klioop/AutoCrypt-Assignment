//
//  CoreLocationService.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/28.
//

import Foundation
import CoreLocation

public final class CoreLocationService: NSObject, CLLocationManagerDelegate {
    private let manager: CLLocationManager
    
    public init(manager: CLLocationManager) {
        self.manager = manager
    }
    
    private(set) public var authorizationCompletion: ((LocationAuthorizationService.Result) -> Void)?
    private(set) public var currentLocationCompletion: ((CurrentLocationService.Result) -> Void)?
}

extension CoreLocationService: LocationAuthorizationService {
    public enum Error: Swift.Error {
        case denied
        case unavailable
        case unknown
    }
    
    public func startAuthorization(completion: @escaping (LocationAuthorizationService.Result) -> Void) {
        manager.delegate = self
        self.authorizationCompletion = completion
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

extension CoreLocationService: CurrentLocationService {
    public func currentLocation(completion: @escaping (CurrentLocationService.Result) -> Void) {
        self.currentLocationCompletion = completion
        
        manager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let coordinate = VaccinationCenterCoordinate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)
        
        currentLocationCompletion?(.success(coordinate))
        manager.stopUpdatingLocation()
    }
}
