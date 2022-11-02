//
//  VaccinationCenter.swift
//  AutoCript-Assignment
//
//  Created by klioop on 2022/10/16.
//

import Foundation

public struct VaccinationCenter: Hashable {
    public let id: CenterID
    public let name: String
    public let facilityName: String
    public let address: String
    public let lat: String
    public let lng: String
    public let updatedAt: String
    public let phoneNumber: String
    
    public init(id: CenterID, name: String, facilityName: String, address: String, lat: String, lng: String, updatedAt: String, phoneNumber: String) {
        self.id = id
        self.name = name
        self.facilityName = facilityName
        self.address = address
        self.lat = lat
        self.lng = lng
        self.updatedAt = updatedAt
        self.phoneNumber = phoneNumber
    }
}

public struct CenterID: Hashable {
    public let id: Int
    
    public init(id: Int) {
        self.id = id
    }
}
