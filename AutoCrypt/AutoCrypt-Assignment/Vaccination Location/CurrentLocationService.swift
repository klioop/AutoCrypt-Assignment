//
//  CurrentLocationService.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import CoreLocation
import RxSwift

final class CurrentLocationService: NSObject, CLLocationManagerDelegate {
    let manager: CLLocationManager
    
    init(manager: CLLocationManager) {
        self.manager = manager
        super.init()
        manager.delegate = self
    }
    
    var completion: ((CLLocation) -> Void)?
    
    func start(completion: @escaping (CLLocation) -> Void) {
        manager.startUpdatingLocation()
        self.completion = completion
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        completion?(location)
        manager.stopUpdatingLocation()
    }
}

extension CurrentLocationService {
    func start() -> Single<CLLocationCoordinate2D> {
        Single.create { [weak self] observer in
            self?.start { location in
                observer(Result {
                    return location.coordinate
                })
            }
            return Disposables.create()
        }
    }
}
