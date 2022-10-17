//
//  PagingController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation
import RxSwift

class PagingController {
    private let bag = DisposeBag()
    
    let viewModel: PagingViewModel
    
    init(viewModel: PagingViewModel) {
        self.viewModel = viewModel
        
        binded()
    }
    
    var onLoadMore: ((Paginated<VaccinationCenter>) -> Void)?
    
    private func binded() {
        viewModel
            .paginatedObservable
            .subscribe(onNext: { [weak self] in
                self?.onLoadMore?($0)
            })
            .disposed(by: bag)
    }
    
    func loadMore() {
        viewModel.loadMore()
    }
}