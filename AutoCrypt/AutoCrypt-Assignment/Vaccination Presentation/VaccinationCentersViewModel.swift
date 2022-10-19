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
    let loadingRelay = PublishRelay<Bool>()
    let loadTrigger = PublishRelay<Void>()
    
    private let loadSingle: () -> Single<Paginated<VaccinationCenter>>
    
    init(loadSingle: @escaping () -> Single<Paginated<VaccinationCenter>>) {
        self.loadSingle = loadSingle
    }
    
    enum State {
        case loading(Bool)
        case loaded(Paginated<VaccinationCenter>)
    }
    
    var state: Observable<State> {
        Observable.merge([
            loadingRelay.map { .loading($0) },
            loadTrigger
                .flatMap { [loadSingle, loadingRelay] in
                    return loadSingle()
                        .observe(on: MainScheduler.instance)
                        .do(afterSuccess: { _ in
                            loadingRelay.accept(false)
                        })
                        .asObservable()
                }                
                .map { .loaded($0) }
        ])
    }
}
