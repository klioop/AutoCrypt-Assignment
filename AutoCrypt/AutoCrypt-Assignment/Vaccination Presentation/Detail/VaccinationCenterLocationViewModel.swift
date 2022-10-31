//
//  VaccinationCenterLocationViewModel.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import MapKit
import CoreLocation
import RxSwift

public struct VaccinationCenterLocationViewModel {
    public let coordinate: CLLocationCoordinate2D
    public let span: MKCoordinateSpan
    
    public init(coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        self.coordinate = coordinate
        self.span = span
    }
}
