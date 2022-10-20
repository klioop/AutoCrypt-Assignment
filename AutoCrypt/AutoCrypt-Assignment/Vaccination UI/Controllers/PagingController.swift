//
//  PagingController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/17.
//

import Foundation
import RxSwift

final class PagingController {
    private let bag = DisposeBag()
    
    var isLastPage = false
    var viewModel: PagingViewModel
    
    init(viewModel: PagingViewModel) {
        self.viewModel = viewModel
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
        guard !viewModel.isLoading, !isLastPage else { return }
        
        binded()
        viewModel.loadMoreTrigger.accept(())
    }
}
