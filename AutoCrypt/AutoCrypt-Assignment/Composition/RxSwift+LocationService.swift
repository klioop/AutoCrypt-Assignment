//
//  RxSwift+LocationService.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import CoreLocation
import RxSwift

public extension CoreLocationService {
    func startAuthorization() -> Single<Void> {
        Single.create { [weak self] observer in
            self?.startAuthorization { result in
                observer(result)
            }
            return Disposables.create()
        }
    }
    
    func currentLocation() -> Single<CLLocationCoordinate2D> {
        Single.create { [weak self] observer in
            self?.currentLocation { result in
                observer(result)
            }
            return Disposables.create()
        }
    }
}
