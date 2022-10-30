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
    public let currentLocation: () -> Single<CLLocationCoordinate2D>
    
    public init(coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan, currentLocation: @escaping () -> Single<CLLocationCoordinate2D>) {
        self.coordinate = coordinate
        self.span = span
        self.currentLocation = currentLocation
    }
}
