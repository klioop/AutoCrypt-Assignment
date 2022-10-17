//
//  PaginatedCenters.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation

public struct Paginated<Item> {
    public typealias LoadCompletion = (Result<Self, Error>) -> Void
    
    public let items: [Item]
    public let loader: ((@escaping LoadCompletion) -> Void)?
    
    public init(items: [Item], loader: ((@escaping (LoadCompletion)) -> Void)? = nil) {
        self.items = items
        self.loader = loader
    }
}
