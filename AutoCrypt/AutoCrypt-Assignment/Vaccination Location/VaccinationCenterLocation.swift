//
//  VaccinationCenterLocation.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import CoreLocation

public struct VaccinationCenterLocation {
    public let coordinate: CLLocationCoordinate2D
    
    public init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
