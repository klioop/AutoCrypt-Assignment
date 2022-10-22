//
//  Paginated.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation

public struct Paginated<Item> {
    public typealias LoadCompletion = (Result<Self, Error>) -> Void
    
    public let items: [Item]
    public let loadMore: ((@escaping LoadCompletion) -> Void)?
    
    public init(items: [Item], loadMore: ((@escaping (LoadCompletion)) -> Void)? = nil) {
        self.items = items
        self.loadMore = loadMore
    }
}

extension Paginated: Equatable where Item: Equatable {
    public static func ==(lhs: Paginated, rhs: Paginated) -> Bool {
        lhs.items == rhs.items
    }
}
