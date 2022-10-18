//
//  VaccinationCenterListEndPoint.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/18.
//

import Foundation

public enum VaccinationCenterListEndPoint {
    case get
    
    public func url(with baseURL: URL) -> URL {
        switch self {
        case .get:
            var component = URLComponents()
            component.scheme = baseURL.scheme
            component.host = baseURL.host
            component.path = baseURL.path + "/15077586/v1/centers"
            component.queryItems = [
                URLQueryItem(name: "page", value: "1")
            ].compactMap { $0 }
            let urlString = component.url!.absoluteString + "&serviceKey=\(serviceKey)"
            return URL(string: urlString)!
        }
    }
    
    public var serviceKey: String {
        "G%2BNU43EDZdI5nseI67t2beD9Lgaecfc2DFnmHI6419KLzpekWjxDnzhvMajqKVv96rluIxoKv5KSjiZ5%2FICxaw%3D%3D"
    }
}
