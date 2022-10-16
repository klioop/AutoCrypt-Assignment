//
//  URLSessionHTTPClient.swift
//  AutoCript-Assignment
//
//  Created by klioop on 2022/10/16.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedRepresentationError: Error {}
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void){
        session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                }
                guard let data = data, let response = response as? HTTPURLResponse else { throw UnexpectedRepresentationError() }
                
                return (data, response)
            })
        }.resume()
    }
}
