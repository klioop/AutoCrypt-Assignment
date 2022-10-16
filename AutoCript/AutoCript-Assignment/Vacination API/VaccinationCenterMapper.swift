//
//  VaccinationCenterMapper.swift
//  AutoCript-Assignment
//
//  Created by klioop on 2022/10/16.
//

import Foundation

enum VaccinationCenterMapper {
    private struct Root: Decodable {
        private let data: [Item]
        
        var centers: [VaccinationCenter] {
            data.map { VaccinationCenter(id: CenterID(id: $0.id), name: $0.centerName, facilityName: $0.facilityName, address: $0.address, lat: $0.lat, lng: $0.lng, updatedAt: $0.updatedAt) }
        }
    }
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    private struct Item: Decodable {
        let id: Int
        let centerName, facilityName, address: String
        let lat, lng: String
        let updatedAt: String
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [VaccinationCenter] {
        guard response.statusCode == 200 else { throw Error.invalidData }
        
        do {
            let decoder = JSONDecoder()
            let root = try decoder.decode(Root.self, from: data)
            return root.centers
        } catch {
            throw Error.invalidData
        }
    }
}
