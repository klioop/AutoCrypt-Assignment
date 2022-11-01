//
//  CoordinateViewModel.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/11/01.
//

import Foundation
import CoreLocation

public struct CoordinateViewModel: Equatable {
    public let coordinate: CLLocationCoordinate2D
    
    public init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    public static func ==(lhs: CoordinateViewModel, rhs: CoordinateViewModel) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
