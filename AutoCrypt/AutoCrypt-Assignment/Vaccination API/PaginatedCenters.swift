//
//  PaginatedCenters.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation

public struct PaginatedCenters {
    public typealias LoadCompletion = (Result<[VaccinationCenter], Error>) -> Void
    
    public let centers: [VaccinationCenter]
    public let loader: ((@escaping LoadCompletion) -> Void)?
}
