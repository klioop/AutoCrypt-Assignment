//
//  VaccinationCentersViewModel.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation
import RxSwift
import RxRelay

final class VaccinationCentersViewModel {
    private let loadingRelay = PublishRelay<Bool>()
    private let loadedRelay = PublishRelay<[VaccinationCenter]>()
    
    private let load: (@escaping LoadCompletion) -> Void
    
    init(load: @escaping (@escaping LoadCompletion) -> Void) {
        self.load = load
    }
    
    enum State {
        case loading(Bool)
        case loaded([VaccinationCenter])
    }
    
    var state: Observable<State> {
        Observable.merge([
            loadingRelay.map { .loading($0) },
            loadedRelay.map { .loaded($0) }
        ])
    }
    
    func loadCenters() {
        loadingRelay.accept(true)
        
        load { [weak self] result in
            switch result {
            case let .success(centers):
                self?.loadedRelay.accept(centers)
                
            case .failure: break
            }
            self?.loadingRelay.accept(false)
        }
    }
}
