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
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                do {
                    let centers = try VaccinationCenterMapper.map(data, from: response)
                    completion(.success(centers))
                } catch {
                    completion(.failure(Error.invalidData))
                }
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
