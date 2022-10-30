//
//  RxSwift+LocationAuthorization.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import RxSwift

public extension LocationAuthorizationService {
    enum Error: Swift.Error {
        case unavailable
        case unRepresented
    }
    
    func startAuthorization() -> Single<AuthorizationStatus> {
        Single.create { observer in
            self.startAuthorization { status in
                observer(Result {
                    switch status {
                    case .denied, .unavailable:
                        throw Error.unavailable
                        
                    case .unknown:
                        throw Error.unRepresented
                        
                    case .available:
                        return status
                    }
                })
            }
            return Disposables.create()
        }
    }
}
