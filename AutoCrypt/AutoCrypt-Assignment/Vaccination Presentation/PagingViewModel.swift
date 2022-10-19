//
//  PagingViewModel.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation
import RxSwift
import RxRelay

final class PagingViewModel {
    private let bag = DisposeBag()
    let loadMoreTrigger = PublishRelay<Void>()
    
    private(set) var isLoading = false
    
    private let loadMoreLoader: () -> Single<Paginated<VaccinationCenter>>
    
    init(loadMoreLoader: @escaping () -> Single<Paginated<VaccinationCenter>>) {
        self.loadMoreLoader = loadMoreLoader
    }
    
    var paginatedObservable: Observable<Paginated<VaccinationCenter>> {
        loadMoreTrigger
            .do(onNext: { [weak self] in
                self?.isLoading = true
            })
            .flatMap { [loadMoreLoader] in
                loadMoreLoader()
                    .observe(on: MainScheduler.instance)
                    .do(onDispose: { [weak self] in
                        self?.isLoading = false
                    })
                    .asObservable()
            }
    }
}
