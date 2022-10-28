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
    
    private(set) public var completion: ((AuthorizationStatus) -> Void)?
    
    public func start(completion: @escaping (AuthorizationStatus) -> Void) {
        manager.delegate = self
        self.completion = completion
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            completion?(.denied)
            
        case .restricted:
            completion?(.unavailable)
         
        case .authorizedWhenInUse, .authorizedAlways:
            completion?(.available)
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        @unknown default:
            completion?(.unknown)
        }
    }
}
