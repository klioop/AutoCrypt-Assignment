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
    private let bag = DisposeBag()
    
    private let loadingRelay = PublishRelay<Bool>()
    private let loadedRelay = PublishRelay<Paginated<VaccinationCenter>>()
    
    private let loadSingle: () -> Single<Paginated<VaccinationCenter>>
    var loadMoreLoader: (((@escaping Paginated<VaccinationCenter>.LoadCompletion) -> Void))?
    
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
            loadedRelay.map { .loaded($0) }
        ])
    }
    
    var onLoadMore: ((Paginated<VaccinationCenter>) -> Void)?
    
    func load() {
        loadSingle()
            .observe(on: MainScheduler.instance)
            .do(onSubscribe: { [loadingRelay] in
                loadingRelay.accept(true)
            }, onDispose: { [loadingRelay] in
                loadingRelay.accept(false)
            })
                .subscribe(onSuccess: { [loadedRelay] paginated in
                    loadedRelay.accept(paginated)
                })
                .disposed(by: bag)
    }
    
    func loadMore() {
        loadMoreLoader? { _ in }
    }
}
