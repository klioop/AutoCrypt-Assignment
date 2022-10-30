//
//  LocationButtonViewModel.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/30.
//

import Foundation
import RxRelay

public struct LocationButtonViewModel {
    public let tap = PublishRelay<Void>()
    
    public init() {}
}
