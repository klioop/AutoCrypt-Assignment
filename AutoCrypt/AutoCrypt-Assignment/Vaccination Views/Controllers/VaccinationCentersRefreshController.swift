//
//  VaccinationCentersRefreshController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit
import RxSwift
import RxCocoa

final class VaccinationCentersRefreshController {
    private let bag = DisposeBag()
    
    private(set) lazy var view = binded(UIRefreshControl())
    
    private let viewModel: VaccinationCentersViewModel
    
    init(viewModel: VaccinationCentersViewModel) {
        self.viewModel = viewModel
    }
    
    var onLoad: ((Paginated<VaccinationCenter>) -> Void)?
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        view.rx
            .controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                self?.viewModel.load()
            })
            .disposed(by: bag)
                    
        viewModel.state
            .subscribe(onNext: { [weak self] state in
                switch state {
                case let .loading(isLoading):
                    isLoading ? view.beginRefreshing() : view.endRefreshing()
                    
                case let .loaded(paginated):
                    self?.onLoad?(paginated)
                }
            })
            .disposed(by: bag)
        
        return view
    }
    
    func refresh() {
        viewModel.load()
    }
}
