//
//  LocationAuthorizationService.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/11/01.
//

import Foundation

public protocol LocationAuthorizationService {
    typealias Result = Swift.Result<Void, Error>
    
    func startAuthorization(completion: @escaping (Result) -> Void)
}
