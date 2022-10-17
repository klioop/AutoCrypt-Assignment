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
            centerListController?.set(paginated.cellController)
            
            let pagingViewModel = PagingViewModel(loadMoreLoader: paginated.loadMoreSingle)
            let pagingController = PagingController(viewModel: pagingViewModel)
            
            pagingController.onLoadMore = { [weak centerListController] paginated in
                centerListController?.add(paginated.cellController)
                pagingViewModel.loadMoreLoader = paginated.loadMoreSingle
            }
            
            centerListController?.pagingController = pagingController
        }
        
        return centerListController
    }
}

private extension Paginated where Item == VaccinationCenter {
    var cellController: [VaccinationCenterCellController] {
        items.map { VaccinationCenterCellController(model: $0) }
    }
}
