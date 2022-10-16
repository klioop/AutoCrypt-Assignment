//
//  RemoteVaccinationCentersLoader.swift
//  AutoCript-Assignment
//
//  Created by klioop on 2022/10/16.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}


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

public struct VaccinationCenter: Equatable {
    public let id: CenterID
    public let name: String
    public let facilityName: String
    public let address: String
    public let lat: String
    public let lng: String
    public let updatedAt: String
    
    public init(id: CenterID, name: String, facilityName: String, address: String, lat: String, lng: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.facilityName = facilityName
        self.address = address
        self.lat = lat
        self.lng = lng
        self.updatedAt = updatedAt
    }
}

public struct CenterID: Equatable {
    public let id: Int
    
    public init(id: Int) {
        self.id = id
    }
}
