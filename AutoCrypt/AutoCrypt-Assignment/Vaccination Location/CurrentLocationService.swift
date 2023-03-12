//
//  CurrentLocationService.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/11/01.
//

import Foundation

public struct VaccinationCenterCoordinate: Equatable {
    public let latitude: Double
    public let longitude: Double
}

public protocol CurrentLocationService {
    typealias Result = Swift.Result <VaccinationCenterCoordinate, Error>
    
    func currentLocation(completion: @escaping (Result) -> Void)
}
