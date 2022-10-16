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
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            completion(result
                    .mapError { _ in Error.connectivity }
                    .flatMap { data, response in
                        guard let centers = try? VaccinationCenterMapper.map(data, from: response) else {
                            return .failure(Error.invalidData)
                        }
                        return .success(centers)
                    })
        }
    }
}
