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
    private let paginatedRelay = PublishRelay<Paginated<VaccinationCenter>>()
    
    var loadMoreLoader: (() -> Single<Paginated<VaccinationCenter>>)?
    
    var isLoading = false
    
    init(loadMoreLoader: (() -> Single<Paginated<VaccinationCenter>>)?) {
        self.loadMoreLoader = loadMoreLoader
    }
    
    var paginatedObservable: Observable<Paginated<VaccinationCenter>> {
        paginatedRelay.asObservable()
    }
    
    func loadMore() {
        guard !isLoading else { return }
        
        loadMoreLoader?()
            .do(onSubscribe: { [weak self] in
                self?.isLoading = true
            }, onDispose:{ [weak self] in
                self?.isLoading = false
            })
            .subscribe(onSuccess: { [paginatedRelay] paginated in
                paginatedRelay.accept(paginated)
            })
            .disposed(by: bag)
    }
}
