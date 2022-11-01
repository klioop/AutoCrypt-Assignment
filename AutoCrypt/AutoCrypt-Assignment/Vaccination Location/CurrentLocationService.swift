//
//  CurrentLocationService.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/11/01.
//

import Foundation

public protocol CurrentLocationService {
    typealias Result = Swift.Result <CoordinateViewModel, Error>
    
    func currentLocation(completion: @escaping (Result) -> Void)
}
