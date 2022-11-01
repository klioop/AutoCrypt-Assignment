//
//  RxSwift+LocationService.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import CoreLocation
import RxSwift

public extension LocationAuthorizationService {
    func startAuthorization() -> Single<Void> {
        Single.create { observer in
            self.startAuthorization { result in
                observer(result)
            }
            return Disposables.create()
        }
    }
}
 
public extension CurrentLocationService {
    func currentLocation() -> Single<CoordinateViewModel> {
        Single.create { observer in
            self.currentLocation { result in
                observer(result)
            }
            return Disposables.create()
        }
    }
}
