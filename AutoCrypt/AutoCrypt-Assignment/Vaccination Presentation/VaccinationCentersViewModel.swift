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
    private let loadedRelay = PublishRelay<[VaccinationCenter]>()
    
    private let loadSingle: () -> Single<[VaccinationCenter]>
    
    init(loadSingle: @escaping () -> Single<[VaccinationCenter]>) {
        self.loadSingle = loadSingle
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
    
    func load() {
        loadSingle()
            .observe(on: MainScheduler.instance)
            .do(onSubscribe: { [loadingRelay] in
                loadingRelay.accept(true)
            }, onDispose: { [loadingRelay] in
                loadingRelay.accept(false)
            })
                .subscribe(onSuccess: { [loadedRelay] centers in
                    loadedRelay.accept(centers)
                })
                .disposed(by: bag)
    }
}
