//
//  VaccinationCenterLocationViewModel.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import MapKit
import CoreLocation

public struct VaccinationCenterLocationViewModel {
    public let coordinate: CLLocationCoordinate2D
    public let span: MKCoordinateSpan
    public let currentLocation: () -> CLLocation
    
    public init(coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan, currentLocation: @escaping () -> CLLocation) {
        self.coordinate = coordinate
        self.span = span
        self.currentLocation = currentLocation
    }
}
