//
//  VaccinationCenterMapper.swift
//  AutoCript-Assignment
//
//  Created by klioop on 2022/10/16.
//

import Foundation

public enum VaccinationCenterMapper {
    private struct Root: Decodable {
        private let data: [Item]
        
        var centers: [VaccinationCenter] {
            data.map { center(from: $0) }
        }
        
        private func center(from item: Item) -> VaccinationCenter {
            VaccinationCenter(id: CenterID(id: item.id),
                              name: item.centerName,
                              facilityName: item.facilityName,
                              address: item.address,
                              lat: item.lat, lng: item.lng,
                              updatedAt: item.updatedAt)
        }
    }
    
    private struct Item: Decodable {
        let id: Int
        let centerName, facilityName, address: String
        let lat, lng: String
        let updatedAt: String
    }
    
    private static var is_OK: Int {
        200
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [VaccinationCenter] {
        guard
            response.statusCode == is_OK,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else { throw Error.invalidData }
        
        return root.centers
    }
}
