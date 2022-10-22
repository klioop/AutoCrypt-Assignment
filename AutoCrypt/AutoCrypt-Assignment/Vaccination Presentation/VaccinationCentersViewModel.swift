//
//  VaccinationCentersViewModel.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation
import RxSwift
import RxRelay

public final class VaccinationCentersViewModel {
    private let loadingRelay = PublishRelay<Bool>()
    public let loadTrigger = PublishRelay<Void>()
    
    private let loadSingle: () -> Single<Paginated<VaccinationCenter>>
    
    public init(loadSingle: @escaping () -> Single<Paginated<VaccinationCenter>>) {
        self.loadSingle = loadSingle
    }
    
    public enum State: Equatable {
        case loading(Bool)
        case loaded(Paginated<VaccinationCenter>)
    }
    
    public var state: Observable<State> {
        Observable.merge([
            loadingRelay.map { .loading($0) },
            loadTrigger
                .do(onNext: { [loadingRelay] _ in
                    loadingRelay.accept(true)
                })
                .flatMap { [loadSingle, loadingRelay] in
                    return loadSingle()
                        .observe(on: MainScheduler.instance)
                        .do(afterSuccess: { _ in loadingRelay.accept(false) },
                            onError: { _ in loadingRelay.accept(false) })
                        .asObservable()
                }                
                .map { .loaded($0) }
        ])
    }
}
