//
//  RemoteVaccinationCentersLoader.swift
//  AutoCript-Assignment
//
//  Created by klioop on 2022/10/16.
//

import Foundation

public final class RemoteVaccinationCentersLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public typealias LoadResult = Result<[VaccinationCenter], Error>
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private struct Root: Decodable {
        private let data: [Item]
        
        var centers: [VaccinationCenter] {
            data.map { VaccinationCenter(id: CenterID(id: $0.id), name: $0.centerName, facilityName: $0.facilityName, address: $0.address, lat: $0.lat, lng: $0.lng, updatedAt: $0.updatedAt) }
        }
    }
    
    private struct Item: Decodable {
        let id: Int
        let centerName, facilityName, address: String
        let lat, lng: String
        let updatedAt: String
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                if response.statusCode != 200 {
                    completion(.failure(Error.invalidData))
                    return
                }
                do {
                    let root = try JSONDecoder().decode(Root.self, from: data)
                    completion(.success(root.centers))
                } catch {
                    completion(.failure(Error.invalidData))
                }
                
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
