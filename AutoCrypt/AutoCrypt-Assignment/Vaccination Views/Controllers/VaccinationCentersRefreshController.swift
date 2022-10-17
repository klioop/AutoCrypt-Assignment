//
//  VaccinationCentersRefreshController.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import UIKit
import RxSwift
import RxCocoa

final class VaccinationCentersRefreshController: NSObject {
    private let bag = DisposeBag()
    
    private(set) lazy var view = binded(UIRefreshControl())
    
    private let viewModel: VaccinationCentersViewModel
    
    init(viewModel: VaccinationCentersViewModel) {
        self.viewModel = viewModel
    }
    
    var onLoad: (([VaccinationCenter]) -> Void)?
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        view.rx
            .controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                self?.viewModel.loadCenters()
            })
            .disposed(by: bag)
                    
        viewModel.state
            .subscribe(onNext: { [weak self, weak view] state in
                switch state {
                case let .loading(isLoading):
                    isLoading ? view?.beginRefreshing() : view?.endRefreshing()
                    
                case let .loaded(centers):
                    self?.onLoad?(centers)
                }
            })
            .disposed(by: bag)
        
        return view
    }
    
    func refresh() {
        viewModel.loadCenters()
    }
}
