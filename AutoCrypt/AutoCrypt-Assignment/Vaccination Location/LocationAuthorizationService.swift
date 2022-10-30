//
//  LocationAuthorizationService.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/28.
//

import Foundation
import CoreLocation

public final class LocationAuthorizationService: NSObject, CLLocationManagerDelegate {
    public enum AuthorizationStatus {
        case denied
        case unavailable
        case available
        case unknown
    }
    
    private let manager: CLLocationManager
    
    public init(manager: CLLocationManager) {
        self.manager = manager
    }
    
    private(set) public var authorizationCompletion: ((AuthorizationStatus) -> Void)?
    private(set) public var currentLocationCompletion: ((CLLocation) -> Void)?
    
    public func startAuthorization(completion: @escaping (AuthorizationStatus) -> Void) {
        manager.delegate = self
        self.authorizationCompletion = completion
    }
    
    public func currentLocation(completion: @escaping (CLLocation) -> Void) {
        manager.startUpdatingLocation()
        self.currentLocationCompletion = completion
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocationCompletion?(location)
        manager.stopUpdatingLocation()
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            authorizationCompletion?(.denied)
            
        case .restricted:
            authorizationCompletion?(.unavailable)
         
        case .authorizedWhenInUse, .authorizedAlways:
            authorizationCompletion?(.available)
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        @unknown default:
            authorizationCompletion?(.unknown)
        }
    }
}
