//
//  VaccinationCenterLocation.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import CoreLocation

public struct VaccinationCenterLocation: Equatable {
    public let name: String
    public let coordinate: VaccinationCenterCoordinate
    
    public init(name: String, coordinate: VaccinationCenterCoordinate) {
        self.name = name
        self.coordinate = coordinate
    }
}
