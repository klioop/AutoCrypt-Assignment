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
