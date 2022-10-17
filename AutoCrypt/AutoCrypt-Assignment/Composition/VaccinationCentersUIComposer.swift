//
//  VaccinationCentersUIComposer.swift
//  AutoCrypt-Assignment
//
//  Created by klioop on 2022/10/16.
//

import Foundation
import RxSwift
import RxRelay

public final class VaccinationCentersUIComposer {
    static public func vaccinationCenterListComposedWith(loadSingle: @escaping () -> Single<Paginated<VaccinationCenter>>) -> VaccinationCenterListViewController {
        let viewModel = VaccinationCentersViewModel(loadSingle: loadSingle)
        let refreshController = VaccinationCentersRefreshController(viewModel: viewModel)
        let centerListController = VaccinationCenterListViewController(refreshController: refreshController)
        
        refreshController.onLoad = { [weak centerListController] paginated in
            centerListController?.set(paginated.items.map { VaccinationCenterCellController(model: $0) })
            
            guard let loadMoreSingle = paginated.loadMoreSingle else {
                return
            }
            
            let pagingViewModel = PagingViewModel(loadMoreLoader: loadMoreSingle)
            let pagingController = PagingController(viewModel: pagingViewModel)
            centerListController?.pagingController = pagingController
        }
        
        return centerListController
    }
}
