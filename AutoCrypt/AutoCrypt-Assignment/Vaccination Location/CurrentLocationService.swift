//
//  CurrentLocationService.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/11/01.
//

import Foundation
import CoreLocation

public protocol CurrentLocationService {
    typealias Result = Swift.Result <CLLocationCoordinate2D, Error>
    
    func currentLocation(completion: @escaping (Result) -> Void)
}
