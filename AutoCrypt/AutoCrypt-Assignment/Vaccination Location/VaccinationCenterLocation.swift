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
    public let coordinate: CLLocationCoordinate2D
    
    public init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
    
    public static func ==(lhs: VaccinationCenterLocation, rhs: VaccinationCenterLocation) -> Bool {
        lhs.name == rhs.name && lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
